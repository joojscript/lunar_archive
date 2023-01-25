import localforage from "localforage";
import { map } from "nanostores";

type DashboardStoreType = {
  showSidebar: boolean;
};

const initialState: DashboardStoreType = (await localforage.getItem(
  "DashboardStore"
)) || {
  showSidebar: false,
};

export const DashboardStore = map<DashboardStoreType>(initialState);
