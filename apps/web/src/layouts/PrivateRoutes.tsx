import { AuthStore } from "@stores/auth.store";
import type React from "react";

const PRIVATE_ROUTES = ["/dashboard"];

type Props = React.PropsWithChildren<{}>;

const PrivateRoutes: React.FC<Props> = ({ children }) => {
  if (
    !AuthStore.get().accessToken &&
    PRIVATE_ROUTES.includes(window.location.pathname)
  ) {
    window.location.href = "/sign";
    return null;
  }

  return <>{children}</>;
};

export default PrivateRoutes;
