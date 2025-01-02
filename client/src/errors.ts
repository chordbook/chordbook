// Error handling for better reporting in tests

type ErrorLog = {
  name: string,
  message: string,
  url: string,
  stack?: string
}

const errors: ErrorLog[] = [];

function captureError(error: Error) {
  // Missing stack trace for some reason. Try to generate one
  if (!error.stack) {
    error.stack = new Error(error.message || error.toString()).stack;
  }

  errors.push({
    name: error.name, // e.g. ReferenceError
    message: error.message || error.toString(), // e.g. x is undefined
    url: document.location.href,
    stack: error.stack,
  });
}

window.addEventListener('error', (event) => captureError(event.error));
window.addEventListener("unhandledrejection", (event) => captureError(event.reason));

// Make available to tests
// eslint-disable-next-line @typescript-eslint/no-explicit-any
(window as any).errors = errors;
