import { PitchDetector } from 'pitchy'
import useMovingAverage from 'moving-average'

const AudioContext = window.AudioContext || window.webkitAudioContext

let mediaDevices = navigator.mediaDevices
// Older browsers might not implement mediaDevices at all, so we set an empty object first
if (mediaDevices === undefined) {
  mediaDevices = {}
}

// Some browsers partially implement mediaDevices. We can't just assign an object
// with getUserMedia as it would overwrite existing properties.
// Here, we will just add the getUserMedia property if it's missing.
if (mediaDevices.getUserMedia === undefined) {
  mediaDevices.getUserMedia = function (constraints) {
    // First get ahold of the legacy getUserMedia, if present
    const getUserMedia = navigator.webkitGetUserMedia || navigator.mozGetUserMedia

    return new Promise(function (resolve, reject) {
      // Some browsers just don't implement it - return a rejected promise with an error
      // to keep a consistent interface
      if (!getUserMedia) {
        reject(new Error('getUserMedia is not implemented in this browser'))
      }

      // Otherwise, wrap the call to the old navigator.getUserMedia with a Promise
      getUserMedia.call(navigator, constraints, resolve, reject)
    })
  }
}

export class Tuner {
  constructor (a4, onNote) {
    this.middleA = a4 || 440
    this.onNote = onNote

    this.semitone = 69
    this.bufferSize = 2048
    this.noteStrings = ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B']

    this.pitchDetector = PitchDetector.forFloat32Array(this.bufferSize)

    this.movingAverage = useMovingAverage(250) // ms
  }

  async start () {
    this.stream = await mediaDevices.getUserMedia({ audio: true })

    this.audioContext = new AudioContext()

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

    if (clarity > 0.99) {
      this.movingAverage.push(Date.now(), frequency)
      const maFrequency = this.movingAverage.movingAverage()

      const note = this.getNote(maFrequency)
      const octave = parseInt(note / 12) - 1
      this.onNote({
        name: this.noteStrings[note % 12],
        value: note,
        cents: this.getCents(maFrequency, note),
        octave,
        frequency: maFrequency,
        clarity
      })
    }
  }

  async stop () {
    this.stream.getTracks().forEach(track => track.stop())
    await this.audioContext.close()
    this.audioContext = this.scriptProcessor = this.analyser = this.stream = this.source = null
  }

  /**
   * get musical note from frequency
   *
   * @param {number} frequency
   * @returns {number}
   */
  getNote (frequency) {
    const note = 12 * (Math.log(frequency / this.middleA) / Math.log(2))
    return Math.round(note) + this.semitone
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
