import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  index(): Record<string, string> {
    const appVersion = this.appService.getAppVersion();

    return {
      status: 'UP',
      version: appVersion,
    };
  }
}
