import { MailerOptions } from '@nestjs-modules/mailer';
import { Injectable, Logger } from '@nestjs/common';
import { existsSync, readFileSync } from 'fs';
import { join } from 'path';
import { Environment } from './config.constants';

@Injectable()
export class ConfigService {
  environment: Environment;
  isDevelopment: boolean;
  isProduction: boolean;
  isTest: boolean;
  jwtSecret: string;

  constructor() {
    this.environment = this.getEnvironment();
    this.isDevelopment = this.environment === 'development';
    this.isProduction = this.environment === 'production';
    this.isTest = this.environment === 'test';
    this.jwtSecret = this.generateJWTSecret();

    Logger[this.isProduction ? 'warn' : 'log'](
      `Selected Application Environment: ${this.environment}`,
      'Environment',
    );
  }

  getEnvironment(): Environment {
    switch (process.env.NODE_ENV) {
      case 'production':
        return 'production';
      case 'test':
        return 'test';
      default:
      case 'development':
        return 'development';
    }
  }

  environmentSwitch<T>(cases: { development: T; production: T; test: T }): T {
    return cases[this.environment];
  }

  static async generateSSLConfiguration() {
    const keySrc = join(__dirname, '..', '..', '..', 'certs', 'fastify.key');
    const certSrc = join(__dirname, '..', '..', '..', 'certs', 'fastify.cert');

    const keyExists = existsSync(keySrc);
    const certExists = existsSync(certSrc);

    if (keyExists && certExists) {
      Logger.log('Using existing SSL certificates', 'SSL');
      return {
        http2: true,
        https: {
          key: readFileSync(keySrc),
          cert: readFileSync(certSrc),
        },
      };
    }

    Logger.warn("Couldn't find SSL certificates", 'SSL');
    Logger.warn('Application will run without certificates', 'SSL');
  }

  generateJWTSecret() {
    return (
      process.env.JWT_SECRET || Math.random().toString(36).substring(2, 15)
    );
  }

  static get mailerConfig(): MailerOptions {
    return {
      transport: process.env.MAIL_TRANSPORT,
      defaults: {
        from: `Lunar`,
      },
    };
  }
}
