import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import * as dns from 'dns';
import { PrismaService } from '../prisma/prisma.service';
import { CreateHostDto } from './dto/create-host.dto';
import { UpdateHostDto } from './dto/update-host.dto';

@Injectable()
export class HostService {
  constructor(private readonly prismaService: PrismaService) {}

  create(createHostDto: CreateHostDto) {
    return this.prismaService.host.create({
      data: createHostDto,
    });
  }

  findAll(args: Prisma.HostFindManyArgs) {
    return this.prismaService.host.findMany(args ?? {});
  }

  findOne(id: string) {
    return this.prismaService.host.findUnique({
      where: {
        id,
      },
    });
  }

  async update(id: string, updateHostDto: UpdateHostDto) {
    const { ownerId, ...data } = updateHostDto;
    const host = await this.verifyOwnership(id, ownerId);

    return this.prismaService.host.update({
      where: { id: host.id },
      data: data as Prisma.HostUpdateInput,
    });
  }

  remove(id: string) {
    return this.prismaService.host.delete({
      where: {
        id,
      },
    });
  }

  async verifyOwnership(id: string, ownerId: string) {
    const host = await this.prismaService.host.findFirst({
      where: {
        id,
        ownerId,
      },
    });

    if (!host) {
      throw new Error('Host not found');
    }

    return host;
  }

  async confirmHost(id: string, ownerId: string) {
    const host = await this.prismaService.host.findFirst({
      where: {
        id,
        ownerId,
      },
    });

    for (const endpoint of host.endpoints) {
      dns.resolveTxt(endpoint, (err, addresses) => {
        console.log(JSON.stringify(addresses));
      });
    }
  }
}
