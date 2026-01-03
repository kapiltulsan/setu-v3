import type { NextConfig } from "next";

// Bypass SSL check for self-signed certificates (Required for local proxy to Flask)
process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'http://localhost:5000/api/:path*',
      },
      {
        source: '/callback',
        destination: 'http://localhost:5000/callback',
      },
      {
        source: '/login/:path*',
        destination: 'http://localhost:5000/login/:path*',
      },
      {
        source: '/login_angel/:path*',
        destination: 'http://localhost:5000/login_angel/:path*',
      },
      {
        source: '/callback_angel',
        destination: 'http://localhost:5000/callback_angel',
      },
    ];
  },
};

export default nextConfig;
