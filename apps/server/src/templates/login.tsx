import React from 'react';
import { Layout } from './components/layout';

type Props = {
  code: string;
};

const LoginEmail: React.FC<Props> = ({ code }) => {
  return (
    <Layout>
      <div className="container">
        <h1>
          You're trying to login into{' '}
          <strong>
            <em>Lunar</em>
          </strong>
        </h1>
        <p>
          If you're not trying to login, please ignore this email. Otherwise,
          please click the button below to login.
          <b>{code}</b>
        </p>
      </div>
    </Layout>
  );
};

export default LoginEmail;
