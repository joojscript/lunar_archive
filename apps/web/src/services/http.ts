import { AuthStore } from "@stores/auth.store";

export const makeRequest = async (path: string, options: RequestInit) => {
  const subPath = path.startsWith("/") ? path.slice(1) : path;
  const result = await fetch(
    `${import.meta.env.PUBLIC_SERVER_URL}/${subPath}`,
    {
      ...options,
      headers: { ...options.headers, "Content-Type": "application/json" },
    }
  );
  if (result.status == 403) {
    // Remove authentication, redirect, and re-throw the error:
    AuthStore.set({
      ...AuthStore.get(),
      session_id: undefined,
    });
    window.location.href = "/sign";
  }
  return result;
};
