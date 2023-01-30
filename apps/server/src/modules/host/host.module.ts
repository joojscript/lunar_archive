import { Module } from '@nestjs/common';
import { ConfigModule } from '../config/config.module';
import { HostController } from './host.controller';
import { HostService } from './host.service';

@Module({
  imports: [ConfigModule],
  controllers: [HostController],
  providers: [HostService],
})
export class HostModule {}
