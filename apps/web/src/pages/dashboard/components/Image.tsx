type Props = {
  path?: string;
  className?: string;
};

export const Image: React.FC<Props> = ({
  path = "1",
  className = "w-4 h-4",
}) => {
  return (
    <img
      src={`https://assets.codepen.io/3685267/${path}.jpg`}
      alt=""
      className={`${className} rounded-full`}
    />
  );
};
