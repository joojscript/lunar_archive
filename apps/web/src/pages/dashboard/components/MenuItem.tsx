import type React from "react";
import { SidebarIcons } from "./SidebarIcons";

type Props = {
  item: {
    id: string;
    title: string;
    notifications?: boolean | number;
  };
  onClick: (id: string) => void;
  selected: string;
  key?: string;
};

export const MenuItem: React.FC<Props> = ({
  item: { id, title, notifications },
  onClick,
  selected,
}) => {
  return (
    <div
      className={`w-full mt-6 flex items-center px-3 sm:px-0 xl:px-3 justify-start sm:justify-center xl:justify-start sm:mt-6 xl:mt-3 cursor-pointer ${
        selected === id ? "sidebar-item-selected" : "sidebar-item"
      }`}
      onClick={() => onClick(id)}
    >
      <SidebarIcons id={Number(id)} />
      <div className="block sm:hidden xl:block ml-2 text-white">{title}</div>
      <div className="block sm:hidden xl:block flex-grow" />
      {notifications && (
        <div className="flex sm:hidden xl:flex bg-pink-600  w-5 h-5 items-center justify-center rounded-full mr-2">
          <div className="text-white text-sm">{notifications}</div>
        </div>
      )}
    </div>
  );
};
