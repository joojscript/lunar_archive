type Props = {
  path?: string;
  className?: string;
  class?: string;
};

export const Icon: React.FC<Props> = ({
  path = "options",
  className,
  ...props
}) => {
  return (
    <img
      src={`https://assets.codepen.io/3685267/${path}.svg`}
      alt=""
      className={className || props.class || "w-4 h-4"}
    />
  );
};
