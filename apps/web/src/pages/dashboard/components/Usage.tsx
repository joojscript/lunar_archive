import { useSpring, animated, config } from "@react-spring/web";

import usageSVG from "../../../assets/images/usage-background.svg";

export const Usage: React.FC = () => {
  const { dashOffset, indicatorWidth, precentage } = useSpring({
    dashOffset: 26.015,
    indicatorWidth: 70,
    precentage: 77,
    from: { dashOffset: 113.113, indicatorWidth: 0, precentage: 0 },
    config: config.molasses,
  });

  return (
    <div
      className="rounded-xl w-full h-full px-3 sm:px-0 xl:px-3 overflow-hidden"
      style={{
        backgroundImage: `url(${usageSVG})`,
      }}
    >
      <div className="block sm:hidden xl:block pt-3">
        <div className="font-bold text-gray-300 text-sm">Used Space</div>
        <div className="text-gray-500 text-xs">
          Admin updated 09:12 am November 08,2020
        </div>
        <animated.div className="text-right text-gray-400 text-xs">
          {precentage.interpolate((i) => `${Math.round(i)}%`)}
        </animated.div>
        <div className="w-full text-gray-300">
          <svg
            viewBox="0 0 100 11"
            fill="none"
            xmlns="http://www.w3.org/2000/svg"
          >
            <line
              x1="5"
              y1="5.25"
              x2="95"
              y2="5.25"
              stroke="#3C3C3C"
              strokeWidth="5"
              strokeLinecap="round"
            ></line>
            <animated.line
              x1="5"
              y1="5.25"
              x2={indicatorWidth}
              y2="5.25"
              stroke="currentColor"
              strokeWidth="5"
              strokeLinecap="round"
            />
          </svg>
        </div>
      </div>

      <div className="hidden sm:block xl:hidden">
        <svg
          width="56"
          height="56"
          viewBox="0 0 56 56"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <rect width="56" height="56" fill="#2C2C2D"></rect>
          <path
            d="M 28 28 m 0, -18 a 18 18 0 0 1 0 36 a 18 18 0 0 1 0 -36"
            stroke="#3C3C3C"
            strokeWidth="6"
          ></path>
          <animated.path
            d="M 28 28 m 0, -18 a 18 18 0 0 1 0 36 a 18 18 0 0 1 0 -36"
            stroke="#fff"
            strokeLinecap="round"
            strokeDasharray="113.113"
            strokeDashoffset={dashOffset}
            strokeWidth="6"
          />
        </svg>
      </div>
    </div>
  );
};

export default Usage;
