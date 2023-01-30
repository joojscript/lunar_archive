import type React from "react";
import { Toaster } from "react-hot-toast";

type Props = React.PropsWithChildren<{}>;

const ReactLayout: React.FC<Props> = ({ children }) => {
  return (
    <>
      <Toaster
        toastOptions={{
          style: {
            background: "#363636",
            boxShadow: "-2px -2px 40px 2px red, 2px 2px 40px 2px blue",
            color: "white",
          },
        }}
      />
      {children}
    </>
  );
};

export default ReactLayout;
