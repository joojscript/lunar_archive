/**
 * This file is used to initiate all stores and subscribe to them
 * so that we can persist the state in IndexedDB
 */

import localforage from "localforage";
import { AuthStore } from "./auth.store";
import { DashboardStore } from "./dashboard.store";

const STORES = { DashboardStore, AuthStore };

const initiateStores = () => {
  for (const [storeName, store] of Object.entries(STORES)) {
    // Re-populate with already existent data:
    (async () => {
      if (typeof window == "undefined") return;
      try {
        const state = await localforage.getItem(storeName);
        if (state) store.set(state as any);
      } catch (err) {
        console.log(err);
      }
    })();

    // Subscribe to the store and persist the state in IndexedDB:
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
