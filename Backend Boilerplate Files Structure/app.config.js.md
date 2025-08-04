`import rTracer from 'cls-rtracer';`
`import compression from 'compression';`
`import cookieParser from 'cookie-parser';`
`import cors from 'cors';`
`import express, { Request, json, urlencoded } from 'express';`
`import bearerToken from 'express-bearer-token';`
`import { queryParser } from 'express-query-parser';`
`import helmet from 'helmet';`
`import swaggerUi from 'swagger-ui-express';`
==`import DeserializeUserMiddleware from '../middleware/deserialize-user.middleware';`==
==`import GlobalErrorHandler from '../middleware/global-error-handler.middleware';`==
==`import SuccessResponseHandler from '../middleware/success-response-handler.middleware';`==
`import commonRoutes from '../routes/common.routes';`
`import routesV1 from '../routes/v1';`
`import { httpLogger } from '../utils/logger.utils';`
`import { corsOptions } from './cors.config';`
`import swaggerDocument from './swagger-output.json';`

  

`const app = express();`

`app.use(`
  `json({`
    `verify: (req: Request, res, buf: Buffer) => {`
      `req.rawBody = buf;`
    `},`
  `}),`
`);`

`app.use(`
  `queryParser({`
    `parseNull: true,`
    `parseUndefined: true,`
    `parseBoolean: true,`
    `parseNumber: true,`
  `}),`
`);`

`app.use(cookieParser());`

`app.use(urlencoded({ extended: false }));`

`app.use(bearerToken());`

`app.use(cors(corsOptions));` 

`app.use(helmet());`
  
`app.use(compression());`

`app.use(rTracer.expressMiddleware());`

`app.use(SuccessResponseHandler);`

`app.use(httpLogger);`

`// add custom middleware`

`app.use((req, res, next) => {`
  `// if request comes with the '/api' prefix, then have to remove it.`
  `if (req.url.startsWith('/api')) {`
    `req.url = req.url.substring(4);`
  `}`
  `next();`
`});`

`// eslint-disable-next-line etc/no-commented-out-code`
`app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));`

==`app.use(DeserializeUserMiddleware);`==

`// configure routes`
`app.use(routesV1);`

`app.use(commonRoutes);`

`// global error handler to handle any unhandled errors`
`app.use(GlobalErrorHandler);`

`export default app;`