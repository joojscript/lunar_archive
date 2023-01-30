import PowerIcon from "@assets/icons/Power";
import { AuthStore } from "@stores/auth.store";
import { DashboardStore } from "@stores/dashboard.store";
import { useCallback } from "react";
import { toast } from "react-hot-toast";
import { Icon } from "./Icon";
import { IconButton } from "./IconButton";

export const Header: React.FC = () => {
  const onSidebarHide = useCallback(() => {
    const currentValue = DashboardStore.get();
    DashboardStore.set({
      ...currentValue,
      showSidebar: !currentValue.showSidebar,
    });
  }, [DashboardStore]);

  const logout = useCallback(() => {
    const current = AuthStore.get();
    delete current.accessToken;
    AuthStore.set(current);
    window.location.href = "/sign";
    toast("You have been logged out");
  }, [AuthStore]);

  return (
    <div className="w-full sm:flex p-2 items-end sm:items-center">
      <div className="sm:flex-grow flex justify-between">
        <div className="">
          <div className="flex items-center">
            <div className="text-3xl font-bold text-white">Hello David</div>
            <div className="flex items-center p-2 bg-card ml-2 rounded-xl">
              <Icon path="res-react-dash-premium-star" />

              <div className="ml-2 font-bold text-premium-yellow text-yellow-400">
                PREMIUM
              </div>
            </div>
          </div>
          <div className="flex items-center">
            <Icon path="res-react-dash-date-indicator" className="w-3 h-3" />
            <div className="ml-2 text-white">October 26</div>
          </div>
        </div>
        <IconButton
          icon="res-react-dash-sidebar-open"
          className="block sm:hidden"
          onClick={onSidebarHide}
        />
      </div>
      <div className="w-full sm:w-56 mt-4 sm:mt-0 flex justify-center items-center ml-3">
        <Icon
          path="res-react-dash-search"
          className="w-5 h-5 search-icon left-3 absolute"
        />
        <form action="#" method="POST">
          <input
            type="text"
            name="company_website"
            id="company_website"
            className="pl-12 py-2 pr-2 block w-full rounded-lg bg-transparent border-gray-300 bg-card"
            placeholder="search"
          />
        </form>
        <div
          className="w-12 h-6 ml-3 px-2 py-5 rounded-lg cursor-pointer flex justify-center items-center hover:bg-gray-500 hover:bg-opacity-5"
          onClick={logout}
        >
          <PowerIcon className="fill-gray-500 h-5 w-5" />
        </div>
      </div>
    </div>
  );
};

export default Header;
