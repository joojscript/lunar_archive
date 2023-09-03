import localforage from "localforage";
import { map } from "nanostores";

type AuthStoreType = {
  session_id?: string;
};

const initialState: AuthStoreType =
  (await localforage.getItem("AuthStore")) || {};

export const AuthStore = map<AuthStoreType>(initialState);
