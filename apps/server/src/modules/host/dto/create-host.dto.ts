import { IsValidHostname } from '@base/src/validators/isHostname.validator';
import { Type } from 'class-transformer';
import { IsArray, IsNotEmpty, IsOptional, IsUUID } from 'class-validator';

export class CreateHostDto {
  @IsNotEmpty({ message: 'Host endpoint is required' })
  @IsArray({ message: 'Host endpoint must be an array' })
  @Type(() => Array.of<string>)
  @IsValidHostname('endpoint', { message: 'Host endpoint is not valid' })
  endpoints: string[];

  @IsOptional()
  @IsUUID('4', { message: 'Invalid Owner ID' })
  ownerId: string;
}
