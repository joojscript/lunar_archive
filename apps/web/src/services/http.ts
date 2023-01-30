export const makeRequest = async (path: string, options: RequestInit) => {
  const subPath = path.startsWith("/") ? path.slice(1) : path;
  return await fetch(`${import.meta.env.PUBLIC_SERVER_URL}/${subPath}`, {
    ...options,
    headers: { ...options.headers, "Content-Type": "application/json" },
  });
};
