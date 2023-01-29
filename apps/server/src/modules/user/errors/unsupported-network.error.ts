export class UnsupportedNetworkError extends Error {
  constructor() {
    super('Invalid address or unsupported network');
    this.name = 'UnsupportedNetworkError';
  }
}
