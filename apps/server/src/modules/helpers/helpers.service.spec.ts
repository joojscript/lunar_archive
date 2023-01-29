import { Test, TestingModule } from '@nestjs/testing';
import { HelpersService } from './helpers.service';

describe('HelpersService', () => {
  let service: HelpersService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [HelpersService],
    }).compile();

    service = module.get<HelpersService>(HelpersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should generate a random string', () => {
    const result = service.generateRandomString(32);
    expect(result).toHaveLength(32);
    expect(result).toMatch(/^[a-zA-Z0-9]+$/);
  });

  it('should read a JSON file', () => {
    const result = service.readJsonFile(__dirname + '/../../../package.json');
    expect(result).toHaveProperty('name');
    expect(result).toHaveProperty('version');
  });
});
