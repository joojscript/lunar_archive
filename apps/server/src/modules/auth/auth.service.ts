import { Injectable } from '@nestjs/common';
import { sign } from 'jsonwebtoken';
import { ConfigService } from '../config/config.service';
import { HelpersService } from '../helpers/helpers.service';
import { UserService } from '../user/user.service';
import { AuthCodesService } from './auth-codes.service';
import { LoginAuthorizeDto } from './dto/login-authorize.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UserService,
    private readonly helperService: HelpersService,
    private readonly authCodesService: AuthCodesService,
    private readonly configService: ConfigService,
  ) {}

  async logInAttempt(loginDto: LoginDto) {
    const userExists = await this.userService.findOneBy(loginDto);

    if (userExists) {
      // 4 Digit code to verify user's identity:
      const code = Math.floor(1000 + Math.random() * 9000).toString();

      // Store the code in a store:
      this.authCodesService.set(code, loginDto.email);

      return await this.helperService.sendEmail('login', {
        to: loginDto.email,
        subject: "You've logged in!",
        templateVars: {
          code,
        },
      });
    }

    throw new Error('User not found');
  }

  async logInAuthorize(loginAuthorizeDto: LoginAuthorizeDto) {
    const code = this.authCodesService.get(loginAuthorizeDto.email);

    if (code == loginAuthorizeDto.code) {
      const user = await this.userService.findOneBy({
        email: loginAuthorizeDto.email,
      });

      this.authCodesService.delete(loginAuthorizeDto.email);
      const accessToken = sign(
        {
          id: user.id,
          email: user.email,
        },
        this.configService.jwtSecret,
        {
          expiresIn: this.configService.environmentSwitch({
            development: '9 years',
            test: '9 years',
            production: '1d',
          }),
        },
      );

      return {
        accessToken,
      };
    }

    throw new Error('Invalid code');
  }
}
