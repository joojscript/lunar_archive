import { Module } from '@nestjs/common';
import { ConfigModule } from '../config/config.module';
import { HelpersModule } from '../helpers/helpers.module';
import { UserModule } from '../user/user.module';
import { AuthCodesService } from './auth-codes.service';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

@Module({
  imports: [UserModule, HelpersModule, ConfigModule],
  controllers: [AuthController],
  providers: [AuthService, AuthCodesService],
})
export class AuthModule {}
