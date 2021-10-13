window.addEventListener('load', () => {
  navigator.serviceWorker.register('/service-worker.js').catch(registrationError => {
    console.log('Service worker registration failed: ', registrationError);
  });
});
