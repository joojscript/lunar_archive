import type { HTMLAttributes } from "react";

const noop = () => {};

type Props = {
  icon?: string;
  className?: string;
  class?: string;
  onclick?: () => void;
} & HTMLAttributes<HTMLButtonElement>;

export const IconButton: React.FC<Props> = ({
  onClick = () => {},
  icon = "options",
  className,
  ...props
}) => {
  return (
    <button
      role="icon-button"
      onClick={onClick || props.onclick || noop}
      type="button"
      className={className}
      {...props}
    >
      <img
        src={`https://assets.codepen.io/3685267/${icon}.svg`}
        alt=""
        className={className || props.class || "w-full h-full"}
      />
    </button>
  );
};
