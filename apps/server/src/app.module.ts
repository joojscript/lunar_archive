import { AuthModule } from '@modules/auth/auth.module';
import { ConfigModule } from '@modules/config/config.module';
import { ConfigService } from '@modules/config/config.service';
import { HelpersModule } from '@modules/helpers/helpers.module';
import { HelpersService } from '@modules/helpers/helpers.service';
import { PrismaModule } from '@modules/prisma/prisma.module';
import { PrismaService } from '@modules/prisma/prisma.service';
import { UserModule } from '@modules/user/user.module';
import { MailerModule } from '@nestjs-modules/mailer';
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';

@Module({
  imports: [
    ConfigModule,
    HelpersModule,
    MailerModule.forRootAsync({
      useFactory: () => ConfigService.mailerConfig,
    }),
    PrismaModule,
    AuthModule,
    UserModule,
  ],
  controllers: [AppController],
  providers: [AppService, ConfigService, PrismaService, HelpersService],
})
export class AppModule {}
