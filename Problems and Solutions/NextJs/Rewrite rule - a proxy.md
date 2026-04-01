Here’s a concise explanation you can save for your notes:

---

### What does the Next.js rewrite rule do?

A rewrite rule in Next.js (like the one in `next.config.ts`) acts as a server-side proxy. It intercepts requests from the browser to certain paths (e.g., `/api/*`) and transparently forwards them to another server (like your standalone API server), without changing the URL in the browser.

#### Why use a rewrite rule for API requests?

- **Avoid CORS issues:** The browser thinks it’s talking to the same origin (e.g., `localhost:3000`), so it doesn’t trigger CORS checks.
- **Seamless development:** You can run your frontend and backend on different ports or even different servers, but your frontend code always calls `/api/*`.
- **Cleaner URLs:** The browser URL stays the same, and users never see the real API server address.

#### How does it work?

- The browser sends a request to `/api/xyz` on the web server (port 3000).
- Next.js receives the request and, using the rewrite rule, forwards it to the API server (e.g., `http://localhost:3001/api/xyz`).
- The API server responds, and Next.js passes the response back to the browser.
- The browser never knows the request was handled by a different server.

#### Example

```js
// next.config.js
async rewrites() {
  return [
    {
      source: "/api/:path((?!docs-search$).*)",
      destination: `${process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:3001"}/api/:path*`,
    },
  ];
}
```

**Summary:**  
Rewrite rules let you proxy API requests through your web app, making development easier and avoiding CORS problems, while keeping your API server’s details hidden from the browser.