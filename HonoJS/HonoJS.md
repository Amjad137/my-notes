Hono - _**[炎] means flame🔥 in Japanese**_ - is a small, simple, and ultrafast web framework for the Edges. It works on any JavaScript runtime: Cloudflare Workers, Fastly Compute, Deno, Bun, Vercel, Netlify, AWS Lambda, Lambda@Edge, and Node.js.

## Use-cases[​](https://hono.dev/top#use-cases)

Hono is a simple web application framework similar to Express, without a frontend. But it runs on CDN Edges and allows you to construct larger applications when combined with middleware. Here are some examples of use-cases.

- Building Web APIs
- Proxy of backend servers
- Front of CDN
- Edge application
- Base server for a library
- Full-stack application

## Multiple routers[​](https://hono.dev/top#multiple-routers)

**Hono has multiple routers**.

**RegExpRouter** is the fastest router in the JavaScript world. It matches the route using a single large Regex created before dispatch. With **SmartRouter**, it supports all route patterns.

**LinearRouter** registers the routes very quickly, so it's suitable for an environment that initializes applications every time. **PatternRouter** simply adds and matches the pattern, making it small.

See [more information about routes](https://hono.dev/concepts/routers).


## Middleware & Helpers[​](https://hono.dev/top#middleware-helpers)

**Hono has many middleware and helpers**. These makes "Write Less, do more" a reality.

Out of the box, Hono provides middleware and helpers for:

- [Basic Authentication](https://hono.dev/middleware/builtin/basic-auth)
- [Bearer Authentication](https://hono.dev/middleware/builtin/bearer-auth)
- [Body Limit](https://hono.dev/middleware/builtin/body-limit)
- [Cache](https://hono.dev/middleware/builtin/cache)
- [Compress](https://hono.dev/middleware/builtin/compress)
- [Cookie](https://hono.dev/helpers/cookie)
- [CORS](https://hono.dev/middleware/builtin/cors)
- [ETag](https://hono.dev/middleware/builtin/etag)
- [html](https://hono.dev/helpers/html)
- [JSX](https://hono.dev/guides/jsx)
- [JWT Authentication](https://hono.dev/middleware/builtin/jwt)
- [Logger](https://hono.dev/middleware/builtin/logger)
- [Pretty JSON](https://hono.dev/middleware/builtin/pretty-json)
- [Secure Headers](https://hono.dev/middleware/builtin/secure-headers)
- [SSG](https://hono.dev/helpers/ssg)
- [Streaming](https://hono.dev/helpers/streaming)
- [GraphQL Server](https://github.com/honojs/middleware/tree/main/packages/graphql-server)
- [Firebase Authentication](https://github.com/honojs/middleware/tree/main/packages/firebase-auth)
- [Sentry](https://github.com/honojs/middleware/tree/main/packages/sentry)
- Others!

For example, adding ETag and request logging only takes a few lines of code with Hono:


```
import { Hono } from 'hono'
import { etag } from 'hono/etag'
import { logger } from 'hono/logger'

const app = new Hono()
app.use(etag(), logger())
```

See [more information about Middleware](https://hono.dev/concepts/middleware).