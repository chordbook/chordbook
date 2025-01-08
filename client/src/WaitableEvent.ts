export default class WaitableEvent {
  constructor(
    private resolve: () => void,
    private reject: () => void = resolve,
  ) {
    this.resolve = resolve;
    this.reject = reject;
  }

  waitUntil(promise?: PromiseLike<unknown>) {
    (promise || Promise.resolve()).then(this.resolve, this.reject);
  }
}
