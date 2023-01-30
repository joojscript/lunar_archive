import localforage from "localforage";
import { map } from "nanostores";

type AuthStoreType = {
  accessToken?: string;
};

const initialState: AuthStoreType =
  (await localforage.getItem("AuthStore")) || {};

export const AuthStore = map<AuthStoreType>(initialState);
