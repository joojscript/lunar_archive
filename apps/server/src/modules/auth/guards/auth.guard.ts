import {
  Injectable,
  CanActivate,
  ExecutionContext,
  Logger,
} from '@nestjs/common';
import { Request } from 'express';
import { verify } from 'jsonwebtoken';
import { ConfigService } from '../../config/config.service';
import { Reflector } from '@nestjs/core';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly configService: ConfigService,
  ) {}

  canActivate(context: ExecutionContext): boolean {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      return true;
    }

    const request = context.switchToHttp().getRequest<Request>();

    const headers = request.headers;
    let authorization = headers.authorization || headers.Authorization;
    authorization = Array.isArray(authorization)
      ? authorization[0]
      : authorization;

    if (!authorization) {
      return false;
    }

    const token = authorization.split(' ')[1];

    if (!token) {
      return false;
    }

    try {
      const payload = verify(token, this.configService.jwtSecret);
      request['user'] = payload;

      return true;
    } catch (err) {
      Logger.error(err);
      return false;
    }
  }
}
