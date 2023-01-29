import { HelpersModule } from '@modules/helpers/helpers.module';
import { Module } from '@nestjs/common';
import { ScannerService } from './scanner.service';

@Module({
  imports: [HelpersModule],
  exports: [ScannerService],
})
export class ScannerModule {}
