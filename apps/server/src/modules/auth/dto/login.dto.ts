import { IsEmail, IsNotEmpty } from 'class-validator';

export class LoginDto {
  @IsNotEmpty({ message: 'E-mail is required' })
  @IsEmail({}, { message: 'E-mail is invalid' })
  email: string;
}
