import React from 'react';
import styles from '../styles';

type Props = React.PropsWithChildren<any>;

export const Layout: React.FC<Props> = ({ children }) => (
  <html lang="en">
    <head>
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Lunar</title>
      <style>{styles}</style>
    </head>
    <body>
      <div id="content">{children}</div>
    </body>
  </html>
);

export default Layout;
