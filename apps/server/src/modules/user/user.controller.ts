import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Post,
  UseFilters,
} from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserService } from './user.service';
// import { JwtAuthGuard } from '../auth/guards/jwt.guard';
// import { Public } from '@modules/auth/decorators/public.decorator';
import { User } from '@prisma/client';
import { UserExceptionFilter } from './filters/user-exception.filter';

// @UseGuards(JwtAuthGuard)
@UseFilters(UserExceptionFilter)
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  // @Public()
  @Post()
  create(@Body() createUserDto: CreateUserDto): Promise<User> {
    return this.userService.create(createUserDto);
  }

  @Get()
  findAll() {
    return this.userService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.userService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.userService.update(id, updateUserDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.userService.remove(id);
  }
}
