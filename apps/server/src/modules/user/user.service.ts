import { PrismaService } from '@modules/prisma/prisma.service';
import { Injectable, OnModuleInit } from '@nestjs/common';
import { User } from '@prisma/client';
import { hash } from 'bcryptjs';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UserService implements OnModuleInit {
  constructor(private readonly prismaService: PrismaService) {}

  async onModuleInit() {
    await this.prismaService.$connect();
    this.prismaService.$use(async (params: any, next) => {
      if (
        (params.action == 'create' || params.action == 'update') &&
        params.model == 'User'
      ) {
        const user = params.args.data;
        const identity = await hash(user.identity, 10);
        user.identity = identity;
        params.args.data = user;
      }
      return await next(params);
    });
  }

  async create(createUserDto: CreateUserDto): Promise<User> {
    const userExists = await this.prismaService.user.findFirst({
      where: {
        email: createUserDto.email,
      },
    });

    if (!!userExists) {
      throw new Error('User already exists');
    }

    return this.prismaService.user.create({
      data: createUserDto,
    });
  }

  findAll() {
    return this.prismaService.user.findMany();
  }

  findOne(id: string) {
    return this.prismaService.user.findUnique({
      where: {
        id,
      },
    });
  }

  findOneBy(where: Partial<User>) {
    return this.prismaService.user.findFirst({ where });
  }

  update(id: string, updateUserDto: UpdateUserDto) {
    return this.prismaService.user.update({
      where: {
        id,
      },
      data: updateUserDto,
    });
  }

  remove(id: string) {
    return this.prismaService.user.delete({
      where: {
        id,
      },
    });
  }
}
