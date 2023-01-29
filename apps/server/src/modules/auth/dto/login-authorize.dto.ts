import { IsEmail, IsNotEmpty } from 'class-validator';

export class LoginAuthorizeDto {
  @IsNotEmpty({ message: 'E-mail is required' })
  @IsEmail({}, { message: 'E-mail is invalid' })
  email: string;

  @IsNotEmpty({ message: 'Code is required' })
  code: string;
}
