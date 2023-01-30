import type React from "react";
import "./styles.css";

type Props = {
  class?: string;
};

const SpinningCircle: React.FC<Props> = ({ class: className }) => {
  return <div className={`box ${className}`} />;
};

export default SpinningCircle;
