import React, { useRef } from "react";
import useResizeObserver from "@react-hook/resize-observer";

import {
  CartesianGrid,
  Line,
  LineChart,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import { graphData } from "../helpers/data";
import { Icon } from "./Icon";

const useSize = (target: any) => {
  const [size, setSize] = React.useState<
    Pick<DOMRectReadOnly, "height" | "width">
  >({
    height: 100,
    width: 700,
  });

  React.useLayoutEffect(() => {
    const { width, height } = target.current.getBoundingClientRect();
    setSize({ width: width * 0.2, height: height * 0.2 });
  }, [target]);

  useResizeObserver(target, (entry) => setSize(entry.contentRect));
  return size;
};

export const Graph: React.FC<{}> = () => {
  const containerRef = useRef<HTMLDivElement>(null);
  const size = useSize(containerRef);

  const CustomTooltip = () => (
    <div className="rounded-xl overflow-hidden tooltip-head bg-gradient-to-r from-violet-500 to-fuchsia-500">
      <div className="flex items-center justify-between p-2 text-white">
        <div className="">Revenue</div>
        <Icon path="res-react-dash-options" className="w-2 h-2" />
      </div>
      <div className="tooltip-body text-center p-3">
        <div className="text-white font-bold">$1300.50</div>
        <div className="text-white">Revenue from 230 sales</div>
      </div>
    </div>
  );
  return (
    <div className="flex p-4 h-full flex-col">
      <div className="">
        <div className="flex items-center">
          <div className="font-bold text-white">Your Work Summary</div>
          <div className="flex-grow" />

          <Icon path="res-react-dash-graph-range" className="w-4 h-4" />
          <div className="ml-2 text-white">Last 9 Months</div>
          <div className="ml-6 w-5 h-5 flex justify-center items-center rounded-full icon-background text-white">
            ?
          </div>
        </div>
        <div className="font-bold ml-5 text-white">Nov - July</div>
      </div>

      <div ref={containerRef} className="flex-grow h-full">
        <LineChart width={size.width} height={size.height} data={graphData}>
          <defs>
            <linearGradient id="paint0_linear" x1="0" y1="0" x2="1" y2="0">
              <stop stopColor="#6B8DE3" />
              <stop offset="1" stopColor="#7D1C8D" />
            </linearGradient>
          </defs>
          <CartesianGrid horizontal={false} strokeWidth="6" stroke="#252525" />
          <XAxis
            dataKey="name"
            axisLine={false}
            tickLine={false}
            tickMargin={10}
          />
          <YAxis axisLine={false} tickLine={false} tickMargin={10} />
          <Tooltip content={<CustomTooltip />} cursor={false} />
          <Line
            activeDot={false}
            type="monotone"
            dataKey="expectedRevenue"
            stroke="#242424"
            strokeWidth="3"
            dot={false}
            strokeDasharray="8 8"
          />
          <Line
            type="monotone"
            dataKey="revenue"
            stroke="url(#paint0_linear)"
            strokeWidth="4"
            dot={false}
          />
        </LineChart>
      </div>
    </div>
  );
};
