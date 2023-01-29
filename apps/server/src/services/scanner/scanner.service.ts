import { HelpersService } from '@base/src/modules/helpers/helpers.service';
import { ScanResult } from '@base/src/types/network';
import { Injectable } from '@nestjs/common';

@Injectable()
export class ScannerService {
  constructor(private readonly helperService: HelpersService) {}

  async scan(host: string): Promise<ScanResult[]> {
    const result = await this.helperService.runBinary(
      'rustscan',
      '-a',
      host,
      '--scripts none',
    );
    return await this.parseScanResult(result);
  }

  private async parseScanResult(scanResult: string): Promise<ScanResult[]> {
    const scanParserRegex = /(open|closed)\s+([0-9\.]+):([0-9]+)/gim;
    const scanParserRegexResult = scanResult.matchAll(scanParserRegex);
    const returnValue: ScanResult[] = [];
    for (const result of scanParserRegexResult) {
      const [status, host, port] = result.slice(1, 4);
      returnValue.push({
        status: status as ScanResult['status'],
        port: Number(port),
        host,
      });
    }
    return returnValue;
  }
}
