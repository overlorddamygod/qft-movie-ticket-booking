/** @type {import('next').NextConfig} */
const nextConfig = {
  swcMinify: true,
  reactStrictMode: true,
  images: {
    domains: ['i.imgur.com'],
  }
}

module.exports = nextConfig
