import fastifyCookie from '@fastify/cookie';
import fastifyCsrf from '@fastify/csrf-protection';
import helmet from '@fastify/helmet';
import secureSession from '@fastify/secure-session';
import { HttpStatus, Logger, ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { AppModule } from './app.module';
import { ConfigService } from './modules/config/config.service';
import { HelpersService } from './modules/helpers/helpers.service';

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter(await ConfigService.generateSSLConfiguration()),
  );

  const helpersService = app.get<HelpersService>(HelpersService);

  app.enableCors({
    optionsSuccessStatus: HttpStatus.OK,
    origin: '*',
  });
  await app.register(fastifyCookie);
  await app.register(secureSession, {
    secret: helpersService.generateRandomString(32),
    salt: helpersService.generateRandomString(16),
  });
  await app.register(helmet);
  await app.register(fastifyCsrf);
  app.useGlobalPipes(new ValidationPipe());

  app
    .getHttpAdapter()
    .getInstance()
    .addHook('onRequest', (request, reply, done) => {
      reply.setHeader = function (key, value) {
        return this.raw.setHeader(key, value);
      };
      reply.end = function () {
        this.raw.end();
      };
      request.res = reply;
      done();
    });

  const SERVER_PORT = process.env.SERVER_PORT || 8000;
  await app.listen(SERVER_PORT, '0.0.0.0', () => {
    Logger.log(`Server running on port ${SERVER_PORT}`, 'Bootstrap');
  });
}
bootstrap();
