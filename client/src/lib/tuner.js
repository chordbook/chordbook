import { PitchDetector } from 'pitchy'
import useMovingAverage from 'moving-average'

export class Tuner {
  constructor (a4, onNote) {
    this.middleA = a4 || 440
    this.onNote = onNote
    this.clarityThreshold = 0.95

    this.semitone = 69
    this.bufferSize = 2048
    this.noteStrings = ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B']

    this.pitchDetector = PitchDetector.forFloat32Array(this.bufferSize)
    this.pitchDetector.minVolumeDecibels = -1000

    this.movingAverage = useMovingAverage(500) // ms
  }

  async start () {
    this.stream = await navigator.mediaDevices.getUserMedia({ audio: true })
    const { sampleRate } = this.stream.getAudioTracks()[0].getSettings()
    this.audioContext = new AudioContext({ sampleRate })

    this.scriptProcessor = this.audioContext.createScriptProcessor(this.bufferSize, 1, 1)
    this.scriptProcessor.addEventListener('audioprocess', this.process.bind(this))
    this.scriptProcessor.connect(this.audioContext.destination)

    this.analyser = new AnalyserNode(this.audioContext, { fftSize: this.bufferSize, smoothingTimeConstant: 0.9 })
    this.analyser.connect(this.scriptProcessor)

    this.source = this.audioContext.createMediaStreamSource(this.stream)
    this.source.connect(this.analyser)
  }

  process (event) {
    const data = event.inputBuffer.getChannelData(0)

    const [frequency, clarity] = this.pitchDetector.findPitch(data, this.audioContext.sampleRate)

    if (clarity > this.clarityThreshold) {
      this.movingAverage.push(Date.now(), frequency)
      this.onNote(this.getNote(this.movingAverage.movingAverage(), clarity))
    }
  }

  getNote (frequency, clarity = null) {
    const note = Math.round(12 * (Math.log(frequency / this.middleA) / Math.log(2))) + this.semitone
    const octave = parseInt(note / 12) - 1
    return {
      name: this.noteStrings[note % 12],
      value: note,
      cents: this.getCents(frequency, note),
      octave,
      frequency,
      clarity
    }
  }

  async stop () {
    await this.audioContext.close()
    this.stream.getTracks().forEach(track => track.stop())
    this.source.disconnect(this.analyser)
    this.analyser.disconnect(this.scriptProcessor)
    this.scriptProcessor.disconnect(this.audioContext.destination)
    this.audioContext = this.scriptProcessor = this.analyser = this.stream = this.source = null
  }

  /**
   * get the musical note's standard frequency
   *
   * @param note
   * @returns {number}
   */
  getStandardFrequency (note) {
    return this.middleA * Math.pow(2, (note - this.semitone) / 12)
  }

  /**
   * get cents difference between given frequency and musical note's standard frequency
   *
   * @param {number} frequency
   * @param {number} note
   * @returns {number}
   */
  getCents (frequency, note) {
    return Math.floor(
      (1200 * Math.log(frequency / this.getStandardFrequency(note))) / Math.log(2)
    )
  }
}
