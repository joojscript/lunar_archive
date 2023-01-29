import { Test, TestingModule } from '@nestjs/testing';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { PrismaModule } from '@modules/prisma/prisma.module';
import { faker } from '@faker-js/faker';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from '@prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { createRequest, createResponse } from 'node-mocks-http';
import { NetworkSeed } from 'prisma/seed/implementations/network';
import { NetworkAddressRegExMap } from '@//constants/network.constants';
import ReRegExp from 'reregexp';

describe('UserController', () => {
  let controller: UserController;
  let prismaService: PrismaService;
  let createdUser: Partial<User>;
  const createUserPayload: CreateUserDto = {
    email: faker.internet.email(),
    password: faker.internet.password(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UserController],
      providers: [UserService],
      imports: [PrismaModule],
    }).compile();

    controller = module.get<UserController>(UserController);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  it('should return an array of users', async () => {
    const users = await controller.findAll();
    expect(users).toBeInstanceOf(Array);
    expect(users).toBeDefined();
    expect(users).toHaveProperty('length');
  });

  it('should create a user', async () => {
    const user = await controller.create(createUserPayload);
    expect(user).toHaveProperty('id');
    expect(user).toHaveProperty('email');
    expect(user).toHaveProperty('createdAt');
    expect(user).toHaveProperty('updatedAt');
    expect(user).toMatchObject({
      email: createUserPayload.email,
      password: expect.any(String),
      id: expect.any(String),
      createdAt: expect.any(Date),
      updatedAt: expect.any(Date),
    });
    createdUser = user;
  });

  it('should return a user', async () => {
    if (createdUser) {
      const user = await controller.findOne(createdUser.id);
      expect(user).toHaveProperty('id');
      expect(user).toHaveProperty('email');
      expect(user).toHaveProperty('createdAt');
      expect(user).toHaveProperty('updatedAt');
      expect(user).toMatchObject({
        email: createUserPayload.email,
        password: expect.any(String),
        id: expect.any(String),
        createdAt: expect.any(Date),
        updatedAt: expect.any(Date),
      });
      createdUser = user;
    }
  });

  it('should update a user', async () => {
    if (createdUser) {
      const user = await controller.update(createdUser.id, {
        email: faker.internet.email(),
        password: faker.internet.password(),
      });

      expect(user).toHaveProperty('id');
      expect(user).toHaveProperty('email');
      expect(user).toHaveProperty('createdAt');
      expect(user).toHaveProperty('updatedAt');
    }
  });

  it('should delete a user', async () => {
    if (createdUser) {
      const user = await controller.remove(createdUser.id);
      expect(user).toHaveProperty('id');
      expect(user).toHaveProperty('email');
      expect(user).toHaveProperty('createdAt');
      expect(user).toHaveProperty('updatedAt');
    }
  });

  it('should attach an address to an user', async () => {
    if (createdUser) {
      const _networkRegExpsKeys = Object.keys(NetworkAddressRegExMap);
      const _selectedNetworkKey =
        _networkRegExpsKeys[
          Math.floor(Math.random() * _networkRegExpsKeys.length)
        ];
      const _selectedNetworkRegExp =
        NetworkAddressRegExMap[_selectedNetworkKey];

      const request = createRequest();
      let response = createResponse();
      await new NetworkSeed().seed();
      const network = await prismaService.network.findFirst({
        where: {
          value: _selectedNetworkKey.toLowerCase(),
        },
      });
      const user = await prismaService.user.create({
        data: {
          email: faker.internet.email(),
          password: faker.internet.password(),
        },
      });

      request.user = user;

      if (!network || !user) {
        throw new Error('Network or user not found');
      }

      response = await controller.attachAddress(
        {
          address: new ReRegExp(_selectedNetworkRegExp).build(),
          networkId: network.id,
          userId: user.id,
        },
        request,
        response,
      );

      const attachedAddress = response._getData();
      expect(response.statusCode).toBe(201);
      expect(attachedAddress).toHaveProperty('id');
      expect(attachedAddress).toHaveProperty('address');
      expect(attachedAddress).toHaveProperty('networkId');
      expect(attachedAddress).toHaveProperty('userId');
    }
  });

  it('should fail to attach invalid address to user', async () => {
    if (createdUser) {
      const request = createRequest();
      let response = createResponse();
      const network = await new NetworkSeed().createSample();
      const user = await prismaService.user.create({
        data: {
          email: faker.internet.email(),
          password: faker.internet.password(),
        },
      });

      request.user = user;

      if (!network || !user) {
        throw new Error('Network or user not found');
      }

      response = await controller.attachAddress(
        {
          address: 'invalid-address',
          networkId: network.id,
          userId: user.id,
        },
        request,
        response,
      );

      const attachedAddress = response._getData();

      expect(response.statusCode).toBe(400);
      expect(attachedAddress).toHaveProperty('error');
      expect(attachedAddress.error).toBe(
        'Invalid address or unsupported network',
      );
    }
  });
});
