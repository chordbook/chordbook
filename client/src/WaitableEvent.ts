export default class WaitableEvent {
  constructor(
    private resolve: () => void,
    private reject: () => void = resolve,
  ) {
    this.resolve = resolve;
    this.reject = reject;
  }

  waitUntil(promise: Promise<void>) {
    promise.then(this.resolve).catch(this.reject);
  }
}
