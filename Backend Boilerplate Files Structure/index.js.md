`import app from './config/app.config';`
`import environment from './config/env.config';`

`app.listen(environment.port, () => {`
  `console.log(`
    `🚀 ${environment.packageName}:${environment.env} is listening on port ${environment.port},`
  `);`
`});``
`
Here only the listen command will be passed to initiate the app configs