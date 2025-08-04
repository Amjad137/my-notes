# Getting Started[​](https://hono.dev/getting-started/basic#getting-started)

Using Hono is super easy. We can set up the project, write code, develop with a local server, and deploy quickly. The same code will work on any runtime, just with different entry points. Let's look at the basic usage of Hono.

## Starter[​](https://hono.dev/getting-started/basic#starter)

Starter templates are available for each platform. Use the following "create-hono" command.

npmyarnpnpmbundeno

txt

```
npm create hono@latest my-app
```

Then you will be asked which template you would like to use. Let's select Cloudflare Workers for this example.

```
? Which template do you want to use?
    aws-lambda
    bun
    cloudflare-pages
❯   cloudflare-workers
    deno
    fastly
    nextjs
    nodejs
    vercel
```

The template will be pulled into `my-app`, so go to it and install the dependencies.

npmyarnpnpmbun

txt

```
cd my-app
npm i
```

Once the package installation is complete, run the following command to start up a local server.

npmyarnpnpmbun

txt

```
npm run dev
```

## Hello World[​](https://hono.dev/getting-started/basic#hello-world)

You can write code in TypeScript with the Cloudflare Workers development tool "Wrangler", Deno, Bun, or others without being aware of transpiling.

Write your first application with Hono in `src/index.ts`. The example below is a starter Hono application.

The `import` and the final `export default` parts may vary from runtime to runtime, but all of the application code will run the same code everywhere.

ts

```
import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

export default app
```

Start the development server and access `http://localhost:8787` with your browser.

npmyarnpnpmbun

txt

```
npm run dev
```

## Return JSON[​](https://hono.dev/getting-started/basic#return-json)

Returning JSON is also easy. The following is an example of handling a GET Request to `/api/hello` and returning an `application/json` Response.

ts

```
app.get('/api/hello', (c) => {
  return c.json({
    ok: true,
    message: 'Hello Hono!',
  })
})
```

## Request and Response[​](https://hono.dev/getting-started/basic#request-and-response)

Getting a path parameter, URL query value, and appending a Response header is written as follows.

ts

```
app.get('/posts/:id', (c) => {
  const page = c.req.query('page')
  const id = c.req.param('id')
  c.header('X-Message', 'Hi!')
  return c.text(`You want see ${page} of ${id}`)
})
```

We can easily handle POST, PUT, and DELETE not only GET.

ts

```
app.post('/posts', (c) => c.text('Created!', 201))
app.delete('/posts/:id', (c) => c.text(`${c.req.param('id')} is deleted!`))
```

## Return HTML[​](https://hono.dev/getting-started/basic#return-html)

Hono is also suitable for returning a little HTML. Rename the file to `src/index.tsx` and configure it to use JSX (check with each runtime as it is different). You don't need to use a huge front-end framework.

tsx

```
const View = () => {
  return (
    <html>
      <body>
        <h1>Hello Hono!</h1>
      </body>
    </html>
  )
}

app.get('/page', (c) => {
  return c.html(<View />)
})
```

## Return raw Response[​](https://hono.dev/getting-started/basic#return-raw-response)

You can also return the raw [Response](https://developer.mozilla.org/en-US/docs/Web/API/Response).

ts

```
app.get('/', (c) => {
  return new Response('Good morning!')
})
```

## Using Middleware[​](https://hono.dev/getting-started/basic#using-middleware)

Middleware can do the hard work for you. For example, add in Basic Authentication.

ts

```
import { basicAuth } from 'hono/basic-auth'

// ...

app.use(
  '/admin/*',
  basicAuth({
    username: 'admin',
    password: 'secret',
  })
)

app.get('/admin', (c) => {
  return c.text('You are authorized!')
})
```

There are useful built-in middleware including Bearer and authentication using JWT, CORS and ETag. Hono also provides third-party middleware using external libraries such as GraphQL Server and Firebase Auth. And, you can make your own middleware.

## Adapter[​](https://hono.dev/getting-started/basic#adapter)

There are Adapters for platform-dependent functions, e.g., handling static files. For example, to handle static files in Cloudflare Workers, import `hono/cloudflare-workers`.

ts

```
import { serveStatic } from 'hono/cloudflare-workers'

app.get('/static/*', serveStatic({ root: './' }))
```

