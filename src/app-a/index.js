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

// Example route that fetches data from app-b
app.get('/data-from-b', async (req, res) => {
    try {
        const response = await fetch('http://app-b.internal');
        const data = await response.json();
        res.json({
            source: 'app-a',
            dataFromB: data
        });
    } catch (error) {
        res.status(500).json({
            error: 'Failed to fetch data from app-b',
            message: error.message
        });
    }
});

const port = process.env.PORT || 8080;
app.listen(port, '0.0.0.0', () => {
    console.log(`Server running at http://0.0.0.0:${port}`);
});
