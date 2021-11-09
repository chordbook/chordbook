import aubio from 'aubiojs'

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
  constructor (a4) {
    this.middleA = a4 || 440
    this.semitone = 69
    this.bufferSize = 4096
    this.noteStrings = ['C', 'C♯', 'D', 'D♯', 'E', 'F', 'F♯', 'G', 'G♯', 'A', 'A♯', 'B']
  }

  async start (onNote) {
    if (!AudioContext) return alert('AudioContext not supported')

    this.audioContext = new AudioContext()
    this.analyser = this.audioContext.createAnalyser()
    this.scriptProcessor = this.audioContext.createScriptProcessor(this.bufferSize, 1, 1)

    const { Pitch } = await aubio()
    this.pitchDetector = new Pitch('default', this.bufferSize, 1, this.audioContext.sampleRate)
    const stream = await mediaDevices.getUserMedia({ audio: true })
    this.audioContext.createMediaStreamSource(stream).connect(this.analyser)
    this.analyser.connect(this.scriptProcessor)
    this.scriptProcessor.connect(this.audioContext.destination)
    this.scriptProcessor.addEventListener('audioprocess', (event) => {
      const frequency = this.pitchDetector.do(event.inputBuffer.getChannelData(0))

      if (frequency) {
        const note = this.getNote(frequency)
        onNote({
          name: this.noteStrings[note % 12],
          value: note,
          cents: this.getCents(frequency, note),
          octave: parseInt(note / 12) - 1,
          frequency: frequency
        })
      }
    })
  }

  stop () {
    return this.audioContext.close()
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
