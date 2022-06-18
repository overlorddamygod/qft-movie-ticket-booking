import axios from "axios";

const axiosClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_SERVER_URL,
});

export default axiosClient;

const isDevelopment = process.env.NODE_ENV == "development";

const ssrAxiosClient = axios.create({
  baseURL: isDevelopment
    ? process.env.NEXT_PUBLIC_SSR_SERVER_URL
    : process.env.NEXT_PUBLIC_SERVER_URL,
});

export { ssrAxiosClient };
