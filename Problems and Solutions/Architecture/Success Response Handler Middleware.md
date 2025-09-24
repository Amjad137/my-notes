## Basic Idea:  Check if the response is json by getting its Content-Type header, If it's json,
We return the response having five keys:
1. error: boolean
2. message: string
3. data: Object
4. status: number
5. headers: HTTP headers

*error* : So first we get the status, if the status lies between 200-400, then its success status, we create a variable isError and use it for the error variable mentioned above.

*message* : Then we have to set message variable, for this, we use getReasonPhrase() from http-status-codes library.

*data* : for this, we will use the response json as await response.json()

then we manually override the status and headers of the response.

*status* : response.status

*headers* : {
'Content-Type': 'application/json'
}

example:
## Hono
```typescript
import { createMiddleware } from 'hono/factory';
import { getReasonPhrase } from 'http-status-codes';

export const successResponseHandler = createMiddleware(async (c, next) => {
  await next();
  if (c.res.headers.get('Content-Type')?.toString().includes('application/json')) {
    const bodyText = await c.res.json();
    const isError = c.res.status < 200 || c.res.status >= 400;
    const modifiedBody = {
      error: isError,
      message: getReasonPhrase(c.res.status),
      data: bodyText
    };

    c.res = new Response(JSON.stringify(modifiedBody), {
      status: c.res.status,
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
});

```

## Express
```typescript
import { NextFunction, Request, Response } from 'express';
import { getReasonPhrase } from 'http-status-codes';

// Middleware function to intercept success responses
const SuccessResponseHandler = (req: Request, res: Response, next: NextFunction) => {
  // Save the original send function
  const originalSend = res.send;

  // Replace the send function with a custom implementation
  res.send = function (body: string) {
    // Check if the response has a success status code (2xx range)

    if (
      res.statusCode >= 200 &&
      res.statusCode < 300 &&
      res.getHeader('Content-Type')?.toString().includes('application/json') &&
      !res.locals.skipResponseMiddleware
    ) {
      // Modify the response body here
      // For example, add a custom property to the response body
      const modifiedBody = {
        error: false,
        message: getReasonPhrase(res.statusCode),
        data: JSON.parse(body),
      };

      // Call the original send function with the modified body
      return originalSend.call(res, JSON.stringify(modifiedBody));
    } else {
      // For error responses, call the original send function without modification
      return originalSend.call(res, body);
    }
  };

  // Move to the next middleware or route handler
  next();
};

export default SuccessResponseHandler;

```