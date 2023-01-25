import { Icon } from "./Icon";

export const AddComponent = () => {
  return (
    <div>
      <div className="w-full h-20 add-component-head" />
      <div
        className="flex flex-col items-center"
        style={{
          transform: "translate(0, -40px)",
        }}
      >
        <div
          className=""
          style={{
            background: "#414455",
            width: "80px",
            height: "80px",
            borderRadius: "999px",
          }}
        >
          <img
            src="https://assets.codepen.io/3685267/res-react-dash-rocket.svg"
            alt=""
            className="w-full h-full"
          />
        </div>
        <div className="text-white font-bold mt-3">
          No Components Created Yet
        </div>
        <div className="mt-2 text-white">
          Simply create your first component
        </div>
        <div className="mt-1 text-white">Just click on the button</div>
        <div className="flex items-center p-3 mt-3 bg-[#2f49d1] rounded-[15px] padding-[8px 16px] justify-center text-white">
          <Icon path="res-react-dash-add-component" className="w-5 h-5" />
          <div className="ml-2">Add Component</div>
          <div className="ml-2 bg-[#4964ed] rounded-[15px] pt-1 pb-1 pl-2 pr-2">
            129
          </div>
        </div>
      </div>
    </div>
  );
};
