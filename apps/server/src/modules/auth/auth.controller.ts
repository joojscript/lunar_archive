import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginAuthorizeDto } from './dto/login-authorize.dto';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  create(@Body() loginDto: LoginDto) {
    return this.authService.logInAttempt(loginDto);
  }

  @Post('login/authorize')
  authorize(@Body() loginAuthorizeDto: LoginAuthorizeDto) {
    return this.authService.logInAuthorize(loginAuthorizeDto);
  }
}
