import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from './config.service';

describe('ConfigService', () => {
  let service: ConfigService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ConfigService],
    }).compile();

    service = module.get<ConfigService>(ConfigService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should return the correct environment', () => {
    expect(service.environment).toBe('test');
  });

  it('should return the correct isDevelopment', () => {
    expect(service.isDevelopment).toBe(false);
  });

  it('should return the correct isProduction', () => {
    expect(service.isProduction).toBe(false);
  });

  it('should return the correct isTest', () => {
    expect(service.isTest).toBe(true);
  });
});
