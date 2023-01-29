import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginAuthorizeDto } from './dto/login-authorize.dto';
import { LoginDto } from './dto/login.dto';
import { Public } from './decorators/public.decorator';
import { AuthGuard } from './guards/auth.guard';

@UseGuards(AuthGuard)
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post('login')
  create(@Body() loginDto: LoginDto) {
    return this.authService.logInAttempt(loginDto);
  }

  @Public()
  @Post('login/authorize')
  authorize(@Body() loginAuthorizeDto: LoginAuthorizeDto) {
    return this.authService.logInAuthorize(loginAuthorizeDto);
  }
}
