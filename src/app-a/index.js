const express = require('express');
const app = express();

// Parse JSON payloads
app.use(express.json());

// Basic route
app.get('/', (req, res) => {
    res.json({service: 'app-a'});
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({status: 'healthy'});
});

const port = process.env.PORT || 8080;
app.listen(port, '0.0.0.0', () => {
    console.log(`Server running at http://0.0.0.0:${port}`);
});
