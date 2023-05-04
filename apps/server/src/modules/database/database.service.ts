import { Injectable } from '@nestjs/common';
import Surreal from 'surrealdb.js';
import { ConfigService } from '../config/config.service';

@Injectable()
export class DatabaseService {
  instance: Surreal;

  constructor(private readonly configService: ConfigService) {
    const [username, password, database, namespace, hostname, port] = [
      'DATABASE_USERNAME',
      'DATABASE_PASSWORD',
      'DATABASE_NAME',
      'DATABASE_NAMESPACE',
      'DATABASE_HOSTNAME',
      'DATABASE_PORT',
    ].map((key) => this.configService.get(key));

    if (!username || !password || !database || !namespace) {
      throw new Error('Database configuration is missing!');
    }

    this.instance = new Surreal(`http://${hostname}:${port}/rpc`);
    this.initialize(username, password);
  }

  private async initialize(username: string, password: string): Promise<void> {
    await this.instance.signin({ user: username, pass: password });
  }
}
