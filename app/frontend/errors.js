// Error handling for better reporting in tests

const errors = []

function captureError (error) {
  // Missing stack trace for some reason. Try to generate one
  if (!error.stack) {
    error.stack = (new Error(error.message || error)).stack
  }

  errors.push({
    name: error.name, // e.g. ReferenceError
    message: error.message || error, // e.g. x is undefined
    url: document.location.href,
    stack: error.stack
  })
}

window.onerror = function (msg, url, lineNo, columnNo, error) {
  captureError(error)
}

window.addEventListener('unhandledrejection', event => {
  captureError(event.reason)
})

// Make available to tests
window.errors = errors
window.captureError = captureError
