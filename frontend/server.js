const { createServer } = require('https');
const { parse } = require('url');
const next = require('next');
const fs = require('fs');
const path = require('path');
const dev = process.env.NODE_ENV !== 'production';
const app = next({ dev });
const handle = app.getRequestHandler();
const httpsOptions = {
    key: fs.readFileSync(path.join(__dirname, '../key.pem')),
    cert: fs.readFileSync(path.join(__dirname, '../cert.pem')),
};
const httpProxy = require('http-proxy');

const proxy = httpProxy.createProxyServer({
    target: 'http://127.0.0.1:5000',
    secure: false, // Verify SSL Cert but ignore self-signed errors (or just ignore validation entirely)
    changeOrigin: true
});

proxy.on('error', (err, req, res) => {
    console.error('Proxy Error:', err);
    res.writeHead(500, { 'Content-Type': 'text/plain' });
    res.end('Something went wrong. And we are reporting a custom error message.');
});

app.prepare().then(() => {
    createServer(httpsOptions, (req, res) => {
        const parsedUrl = parse(req.url, true);
        const { pathname } = parsedUrl;

        if (pathname.startsWith('/api') || pathname.startsWith('/callback')) {
            proxy.web(req, res);
        } else {
            handle(req, res, parsedUrl);
        }
    }).listen(3000, '0.0.0.0', (err) => {
        if (err) throw err;
        console.log('> Ready on https://localhost:3000');
    });
});