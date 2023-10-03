import axios from "axios";
import https from "https";

const axiosClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_SERVER_URL,
  httpsAgent: new https.Agent({
    rejectUnauthorized: false
  })
});

axiosClient.interceptors.request.use(function (config) {
  config.headers = {
    ...config.headers,
    "Authorization": `${localStorage.getItem("accessToken")}`
  }
  // Do something before request is sent
  return config;
}, function (error) {
  // Do something with request error
  return Promise.reject(error);
});

export default axiosClient;

const isDevelopment = process.env.NODE_ENV == "development";

const ssrAxiosClient = axios.create({
  baseURL: isDevelopment
    ? process.env.NEXT_PUBLIC_SSR_SERVER_URL
    : process.env.NEXT_PUBLIC_SSR_SERVER_URL,
    httpsAgent: new https.Agent({
      rejectUnauthorized: false
    })
});

export { ssrAxiosClient };
