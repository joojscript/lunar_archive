/* eslint-disable @typescript-eslint/no-var-requires */
import { ISendMailOptions, MailerService } from '@nestjs-modules/mailer';
import { Injectable } from '@nestjs/common';
import { minify } from 'html-minifier';
import { createRequire } from 'module';
import { join } from 'path';
import { renderToString } from 'react-dom/server';

@Injectable()
export class HelpersService {
  constructor(private readonly mailerService: MailerService) {}

  async sendEmail(
    templateName: string,
    options: ISendMailOptions & { templateVars?: Record<string, unknown> } = {},
  ) {
    const template = require(join(
      __dirname,
      '..',
      '..',
      'templates',
      `${templateName}.js`,
    )).default;
    const reactHtmlString: string = renderToString(
      template(options.templateVars ?? {}),
    );
    const reminifiedHtmlString: string = minify(reactHtmlString, {
      maxLineLength: 255,
      keepClosingSlash: true,
    });

    console.log(reactHtmlString);

    return await this.mailerService.sendMail({
      html: reminifiedHtmlString,
      ...options,
    });
  }

  generateRandomString(length: number): string {
    let result = '';
    const characters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i++) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
  }

  readJsonFile(path: string) {
    // Needed because NestJS doesn't support modules outside of commonJS natively.

    const { readFileSync } = require('fs');
    const data = readFileSync(path, 'utf8');
    return JSON.parse(data);
  }

  getModuleDir(moduleEntry, relativeToFile = __filename) {
    const path = require('path');
    const fs = require('fs');

    const packageName = moduleEntry.includes('/')
      ? moduleEntry.startsWith('@')
        ? moduleEntry.split('/').slice(0, 2).join('/')
        : moduleEntry.split('/')[0]
      : moduleEntry;
    const _require = createRequire(relativeToFile);
    const lookupPaths = _require.resolve
      .paths(moduleEntry)
      .map((p) => path.join(p, packageName));
    return lookupPaths.find((p) => fs.existsSync(p));
  }

  async runBinary(binaryName: string, ...args: string[]) {
    const { exec } = require('child_process');
    const { promisify } = require('util');
    const path = require.resolve('@lunar/bin');
    const binaryPath = join(path, '..', binaryName);
    const command = `sh -c "${binaryPath} ${args.join(' ')}"`;

    try {
      const { stdout } = await promisify(exec)(command);
      return stdout;
    } catch (error) {
      console.error(error);
    }
  }
}
