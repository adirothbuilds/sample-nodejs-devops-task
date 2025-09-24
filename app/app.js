const express = require('express');
const promClient = require('prom-client');

const app = express();
const port = process.env.PORT || 8080;

// added consts for demostation using configmap
const aboutMessage = process.env.ABOUT_MESSAGE ||
    "This is a sample Node.js application for Kubernetes deployment testing.";

// added const for demostation using secret
const secretToken = process.env.CLASSIFIED_TOKEN || "";
const secretMessage = secretToken ? 
    "Classified token is set. Welcome!" : 
    "Access denied. No classified token found.";

// Create a Registry to register the metrics
const register = new promClient.Registry();

// Enable the collection of default metrics
promClient.collectDefaultMetrics({ register });

const helloWorldCounter = new promClient.Counter({
    name: 'root_access_total',
    help: 'Total number of accesses to the root path',
});
register.registerMetric(helloWorldCounter);

// Define routes
app.get('/my-app', (req, res) => {
    helloWorldCounter.inc();
    res.send('Hello, World!');
});

// Using configmap for about message
app.get('/about', (req, res) => {
    res.send(aboutMessage);
});

app.get('/ready', (req, res) => {
    res.status(200).send('Ready');
});

app.get('/live', (req, res) => {
    res.status(200).send('Alive');
});

// Using secret for classified message and access control
app.get('/classified', (req, res) => {
    if (!secretToken) {
        res.status(403).send(secretMessage);
    } else {
        res.status(200).send(secretMessage);
    }
});

app.get('/metrics', async (req, res) => {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
