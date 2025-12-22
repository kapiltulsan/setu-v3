process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
const https = require('https');

console.log("Testing connection to https://127.0.0.1:5000/api/portfolio/summary");

const req = https.get('https://127.0.0.1:5000/api/portfolio/summary', (res) => {
    console.log('statusCode:', res.statusCode);

    let data = '';
    res.on('data', (d) => {
        data += d;
    });

    res.on('end', () => {
        console.log("Body length:", data.length);
        console.log("Success!");
    });
});

req.on('error', (e) => {
    console.error("Connection Error:", e);
});
