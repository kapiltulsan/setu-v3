import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'https://127.0.0.1:5000/api/:path*',
      },
      {
        source: '/callback',
        destination: 'https://127.0.0.1:5000/callback',
      },
    ];
  },
};

export default nextConfig;
