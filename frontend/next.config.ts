import type { NextConfig } from "next";

// Bypass SSL check for self-signed certificates in development
if (process.env.NODE_ENV !== 'production') {
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
}

const nextConfig: NextConfig = {
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'https://localhost:5000/api/:path*',
      },
      {
        source: '/callback',
        destination: 'https://localhost:5000/callback',
      },
    ];
  },
};

export default nextConfig;
