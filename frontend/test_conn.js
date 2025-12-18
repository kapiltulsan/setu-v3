const https = require('https');

// Option 1: Native HTTPS
const options = {
    hostname: '127.0.0.1',
    port: 5000,
    path: '/api/portfolio/summary',
    method: 'GET',
    rejectUnauthorized: false
};

console.log("Testing native https request...");
const req = https.request(options, res => {
    console.log(`Native HTTPS Status: ${res.statusCode}`);
});

req.on('error', error => {
    console.error('Native HTTPS Error:', error);
});

req.end();

// Option 2: Fetch
async function testFetch() {
    console.log("Testing fetch...");
    try {
        // Native fetch in Node 20
        const res = await fetch('https://127.0.0.1:5000/api/portfolio/summary');
        console.log(`Fetch Status: ${res.status}`);
    } catch (e) {
        console.error("Fetch Error:", e);
    }
}

testFetch();
