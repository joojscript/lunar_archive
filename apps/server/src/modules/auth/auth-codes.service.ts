import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthCodesService {
  AuthCodesStore: Record<string, string>;

  constructor() {
    this.AuthCodesStore = {};
  }

  set(code: string, email: string) {
    this.AuthCodesStore[email] = code;
  }

  get(email: string) {
    return this.AuthCodesStore[email];
  }

  delete(email: string) {
    delete this.AuthCodesStore[email];
  }

  clear() {
    this.AuthCodesStore = {};
  }
}
