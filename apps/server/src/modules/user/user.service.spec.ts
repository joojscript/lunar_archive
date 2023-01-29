import { Test, TestingModule } from '@nestjs/testing';
import { PrismaModule } from '@modules/prisma/prisma.module';
import { UserService } from './user.service';
import { faker } from '@faker-js/faker';
import { CreateUserDto } from './dto/create-user.dto';
import { hash } from 'bcryptjs';
import NETWORKS from 'prisma/seed/implementations/network';
import { PrismaService } from '../prisma/prisma.service';

describe('UserService', () => {
  let service: UserService;
  let prismaService: PrismaService;
  const createUserPayload: CreateUserDto = {
    email: faker.internet.email(),
    password: faker.internet.password(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [UserService],
      imports: [PrismaModule],
    }).compile();

    service = module.get<UserService>(UserService);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  it('should create a user', async () => {
    // For some reason, Prisma Service is not loaded (onInit), what prevents it
    // from encrypting the password. So we need to do it manually.
    const user = await service.create({
      ...createUserPayload,
      password: await hash(createUserPayload.password, 10),
    });

    expect(user).toBeDefined();
    expect(user.email).toEqual(createUserPayload.email);
    expect(user.password).not.toEqual(createUserPayload.password);
    expect(user.id).toBeDefined();
    expect(user.createdAt).toBeDefined();
    expect(user.updatedAt).toBeDefined();
    expect(user).toMatchObject({
      email: createUserPayload.email,
      password: expect.any(String),
      id: expect.any(String),
      createdAt: expect.any(Date),
      updatedAt: expect.any(Date),
    });
  });

  it('should attach an address to an user', async () => {
    const user = await service.findOneBy({
      email: createUserPayload.email,
    });

    const network = await prismaService.network.create({
      data: NETWORKS[0] as any,
    });

    if (!user || !network) {
      throw new Error('User or network could not be created');
    }

    const address = await service.attachAddress({
      userId: user.id,
      networkId: network.id,
      address: faker.finance.bitcoinAddress(),
    });

    expect(address).toBeDefined();
    expect(address.address).toBeDefined();
    expect(address.networkId).toEqual(network.id);
    expect(address.userId).toEqual(user.id);
    expect(address.id).toBeDefined();
    expect(address).toMatchObject({
      address: expect.any(String),
      networkId: network.id,
      userId: user.id,
      id: expect.any(String),
    });
  });

  it('should detach an address from an user', async () => {
    const user = await service.findOneBy({
      email: createUserPayload.email,
    });

    const network = await prismaService.network.create({
      data: NETWORKS[1] as any,
    });

    if (!user || !network) {
      throw new Error('User or network could not be created');
    }

    const address = await service.attachAddress({
      userId: user.id,
      networkId: network.id,
      address: faker.finance.bitcoinAddress(),
    });

    if (!address) {
      throw new Error('Address could not be created');
    }

    const deletedAddress = await service.detachAddress({
      userId: user.id,
      networkId: network.id,
      address: address.address,
    });

    expect(deletedAddress).toBeDefined();
    expect(deletedAddress.address).toEqual(address.address);
    expect(deletedAddress.networkId).toEqual(address.networkId);
    expect(deletedAddress.userId).toEqual(address.userId);
    expect(deletedAddress.id).toEqual(address.id);
    expect(deletedAddress).toMatchObject({
      address: address.address,
      networkId: address.networkId,
      userId: address.userId,
      id: address.id,
    });
  });

  it('should fail while trying to create a user with an existing user e-mail', async () => {
    await expect(
      service.create({
        ...createUserPayload,
        password: await hash(createUserPayload.password, 10),
      }),
    ).rejects.toThrowError(Error('User already exists'));
  });
});
