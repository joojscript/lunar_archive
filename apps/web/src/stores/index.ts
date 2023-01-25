/**
 * This file is used to initiate all stores and subscribe to them
 * so that we can persist the state in IndexedDB
 */

import localforage from "localforage";
import { DashboardStore } from "./dashboard.store";

const STORES = { DashboardStore };

const initiateStores = () => {
  for (const [storeName, store] of Object.entries(STORES)) {
    store.subscribe(async (state) => {
      if (typeof window == "undefined") return;
      try {
        await localforage.setItem(storeName, state);
      } catch (err) {
        console.log(err);
      }
    });
  }
};

initiateStores();
