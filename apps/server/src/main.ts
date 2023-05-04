import { NestFactory } from '@nestjs/core';
import { config as loadEnvVariables } from 'dotenv';
import { AppModule } from './app.module';

async function bootstrap() {
  loadEnvVariables();

  const { SERVER_PORT = 8000 } = process.env;

  const app = await NestFactory.create(AppModule);
  await app.listen(SERVER_PORT);
}
bootstrap();
