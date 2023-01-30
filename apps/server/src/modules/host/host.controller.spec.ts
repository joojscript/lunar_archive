import { Test, TestingModule } from '@nestjs/testing';
import { HostController } from './host.controller';
import { HostService } from './host.service';

describe('HostController', () => {
  let controller: HostController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [HostController],
      providers: [HostService],
    }).compile();

    controller = module.get<HostController>(HostController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
