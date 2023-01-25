import { Countrydata } from "../helpers/data";
import { Icon } from "./Icon";
import { Image } from "./Image";

export const TopCountries: React.FC<{}> = () => {
  return (
    <div className="flex p-4 flex-col h-full">
      <div className="flex justify-between items-center">
        <div className="text-white font-bold">Top Countries</div>
        <Icon path="res-react-dash-plus" className="w-5 h-5" />
      </div>
      <div className="text-white">favourites</div>
      {Countrydata.map(({ name, rise, value, id }) => (
        <div className="flex items-center mt-3" key={id}>
          <div className="text-white">{id}</div>

          <Image path={`res-react-dash-flag-${id}`} className="ml-2 w-6 h-6" />
          <div className="ml-2 text-white">{name}</div>
          <div className="flex-grow" />
          <div className="text-white">{`$${value.toLocaleString()}`}</div>
          <Icon
            path={
              rise ? "res-react-dash-country-up" : "res-react-dash-country-down"
            }
            className="w-4 h-4 mx-3"
          />
          <Icon path="res-react-dash-options" className="w-2 h-2" />
        </div>
      ))}
      <div className="flex-grow" />
      <div className="flex justify-center">
        <div className="text-white">Check All</div>
      </div>
    </div>
  );
};
