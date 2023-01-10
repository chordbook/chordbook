// Wrapper around console.log to be able to enable/disable logging
//
//   import console from "./console"
//
//   console.log("this message will not appear in the console")
//
//   // Enable with either of these:
//   window.debug = true
//   localStorage.setItem('debug', true)
//
//   console.log("This message will appear in the console")
//
export default new Proxy(console, {
  get (target, prop) {
    const debug = window.debug || localStorage.getItem('debug')
    return debug ? target[prop] : function () { }
  }
})
