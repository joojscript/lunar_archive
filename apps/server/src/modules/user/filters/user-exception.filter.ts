import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpStatus,
} from '@nestjs/common';

@Catch()
export class UserExceptionFilter implements ExceptionFilter {
  catch(error: Error, host: ArgumentsHost) {
    const response = host.switchToHttp().getResponse();

    response
      .status(HttpStatus.BAD_REQUEST)
      .send(error['response'] ? error['response'] : { error: error.message });
  }
}
