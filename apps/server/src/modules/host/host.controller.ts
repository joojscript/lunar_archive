import { AuthGuard } from '@modules/auth/guards/auth.guard';
import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { CreateHostDto } from './dto/create-host.dto';
import { UpdateHostDto } from './dto/update-host.dto';
import { HostService } from './host.service';

@UseGuards(AuthGuard)
@Controller('hosts')
export class HostController {
  constructor(private readonly hostService: HostService) {}

  @Post()
  create(@Req() req: Request, @Body() createHostDto: CreateHostDto) {
    createHostDto['ownerId'] = req['user']?.id;
    return this.hostService.create(createHostDto);
  }

  @Get()
  findAll(@Req() req: Request) {
    return this.hostService.findAll({
      where: {
        ownerId: req['user']?.id,
      },
    });
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.hostService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateHostDto: UpdateHostDto) {
    return this.hostService.update(id, updateHostDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.hostService.remove(id);
  }
}
