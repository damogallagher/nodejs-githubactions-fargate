const http = require('http');
const jokes = [
  "Why did the scarecrow win an award? Because he was outstanding in his field!",
  "What do you call a fish with no eyes? Fsh!",
  "I'm reading a book on anti-gravity. It's impossible to put down!",
  "Why don't scientists trust atoms? Because they make up everything!",
  "Parallel lines have so much in common. It's a shame they'll never meet.",
];

const server = http.createServer((req, res) => {
  if (req.url === '/') {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    const randomJoke = jokes[Math.floor(Math.random() * jokes.length)];
    res.end(`
      <html>
        <body>
          <h1>Random Joke Generator</h1>
          <p>${randomJoke}</p>
        </body>
      </html>
    `);
  } else {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Page not found');
  }
});

const port = 5000;
server.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});