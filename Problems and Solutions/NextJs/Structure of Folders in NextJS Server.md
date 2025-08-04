
# Separation of Concerns in Next.js API Architecture

When structuring a Next.js application with a focus on API organization, following proper separation of concerns leads to more maintainable and scalable code. Here's a comprehensive approach:

## Project Structure Overview

```typescript
/src
  /app
    /api
      /{endpoint-group}
        /route.ts                # API route handlers
    /(site-sections)              # App router organization
  /lib
    /db                          # Database related code
      /mongodb                   # MongoDB specific code
        /client.ts               # Client configuration
        /models                  # Data models
        /schemas                 # Schema definitions
      /services                  # Service layer
        /merchantRequestService.ts
        /templateService.ts
    /config                      # Configuration files
      /constants.ts              # App constants
      /env.ts                    # Environment variable validation
    /utils                       # Utility functions
      /api-utils.ts              # API-specific utilities
      /validators.ts             # Input validation functions
    /types                       # TypeScript type definitions
      /index.ts                  # Exported types
      /merchant.ts               # Domain-specific types
    /enums                       # Enumeration values
      /status-codes.ts
      /request-types.ts
  /middleware.ts                 # Global middleware
```

## Where to Place Different File Types

### 1. Configuration Files

Place in `/src/lib/config/`:

```typescript
// src/lib/config/env.ts
export const ENV = {
  MONGODB_URI: process.env.MONGODB_URI || '',
  // Validate environment variables
  validate() {
    if (!this.MONGODB_URI) throw new Error('MONGODB_URI is required');
  }
};

// src/lib/config/constants.ts
export const DB_CONSTANTS = {
  DATABASE_NAME: 'salance',
  COLLECTIONS: {
    MERCHANT_REQUESTS: 'MerchantRequests',
    TEMPLATES: 'Templates',
  }
};
```

### 2. Utility Functions

Place in `/src/lib/utils/`:

```typescript
// src/lib/utils/api-utils.ts
import { NextResponse } from 'next/server';

export function createSuccessResponse(data: any, status = 200) {
  return NextResponse.json({ success: true, data }, { status });
}

export function createErrorResponse(message: string, status = 500) {
  return NextResponse.json({ success: false, error: message }, { status });
}

```
### 3. Enum Files

Place in `/src/lib/enums/`:

```typescript
// src/lib/enums/request-status.ts
export enum RequestStatus {
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected',
}

// src/lib/enums/user-roles.ts
export enum UserRole {
  ADMIN = 'admin',
  MERCHANT = 'merchant',
  CUSTOMER = 'customer',
}
```

### 4. Database Client

Place in `/src/lib/db/mongodb/`:

```typescript
// src/lib/db/mongodb/client.ts
import { MongoClient, ServerApiVersion } from 'mongodb';
import { ENV } from '@/lib/config/env';

const uri = ENV.MONGODB_URI;
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
});

export { client };
```

### 5. Service Files

Place in `/src/lib/db/services/`:

```typescript
// src/lib/db/services/merchantRequestService.ts
import { client } from '../mongodb/client';
import { DB_CONSTANTS } from '@/lib/config/constants';
import { ObjectId } from 'mongodb';
import { RequestStatus } from '@/lib/enums/request-status';

export const merchantRequestService = {
  async create(data: any, session: any) {
    const database = client.db(DB_CONSTANTS.DATABASE_NAME);
    const collection = database.collection(DB_CONSTANTS.COLLECTIONS.MERCHANT_REQUESTS);

    return await collection.insertOne(
      {
        ...data,
        _id: new ObjectId(),
        createdAt: new Date(),
        status: RequestStatus.PENDING,
      },
      { session },
    );
  },
  // More methods...
};
```
## Implementing in API Routes

// src/app/api/sales/route.ts

```typescript
// src/app/api/sales/route.ts
import { NextRequest } from 'next/server';
import { client } from '@/lib/db/mongodb/client';
import { merchantRequestService } from '@/lib/db/services/merchantRequestService';
import { templateService } from '@/lib/db/services/templateService';
import { createSuccessResponse, createErrorResponse } from '@/lib/utils/api-utils';
import { validateSalesRequest } from '@/lib/utils/validators';

export async function POST(request: NextRequest) {
  const session = client.startSession();

  try {
    const body = await request.json();
    const validationError = validateSalesRequest(body);
    
    if (validationError) {
      return createErrorResponse(validationError, 400);
    }

    const result = await session.withTransaction(async () => {
      let template = null;
      if (body.templateId) {
        template = await templateService.findById(body.templateId, session);
        if (!template) {
          throw new Error('Selected template not found');
        }
      }

      const merchantRequest = await merchantRequestService.create({
        businessName: body.businessName,
        email: body.email,
        address: body.address,
        templateId: body.templateId,
        businessRep: body.businessRep,
        templateDetails: template,
        source: 'sales_page',
      }, session);
      
      return {
        requestId: merchantRequest.insertedId,
      };
    });

    return createSuccessResponse({
      message: 'Merchant request submitted successfully',
      data: result
    }, 201);
    
  } catch (error: any) {
    console.error('Error submitting merchant request:', error);
    return createErrorResponse(error.message || 'Failed to submit request');
  } finally {
    await session.endSession();
    await client.close();
  }
}
```

## Benefits of This Approach

1. **Maintainability**: Each file has a single responsibility
2. **Testability**: Easier to write unit tests for isolated components
3. **Scalability**: Adding new features doesn't require modifying existing code
4. **Reusability**: Services can be used across multiple API routes
5. **Clarity**: Clear organization makes it easier for developers to find code

This structured approach will help your application stay organized as it grows, making it easier to maintain, test, and extend.


# Why We Use the `lib` Folder for Server-Related Files in Next.js

The `lib` folder is a common convention in Next.js projects for several important reasons:

## 1. Next.js App Router Architecture

In the App Router architecture of Next.js, the `/app` directory is specifically structured around routes and UI components. The [route.ts](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html) files should be kept minimal and focused on HTTP request/response handling.

## 2. Cross-Environment Accessibility

The `lib` folder can contain code that's accessible to both:

- Server-side components and API routes
- Client-side components (if not marked with "server-only")

This makes it an ideal place for shared utilities and services.

## 3. Separation of Concerns

Placing server-related functionality in `/lib` helps separate:

- **Route logic** (in [route.ts](vscode-file://vscode-app/c:/Users/moham/AppData/Local/Programs/Microsoft%20VS%20Code/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html)) - handling HTTP requests
- **Business logic** (in `/lib/services`) - core application operations
- **Data access** (in `/lib/db`) - database operations
- **Configuration** (in `/lib/config`) - system settings

## 4. Code Reusability

Services and utilities in `/lib` can be reused across:

- Multiple API routes
- Server components
- Background jobs
- Testing environments

## 5. Avoiding Route Handler Bloat

Without this separation, route handlers would contain:

- Database connection logic
- Service implementations
- Validation code
- Business rules
- Error handling

This would make them difficult to maintain and test.

## 6. Industry Standard Convention

The `/lib` folder is a widely adopted pattern in the Next.js ecosystem, similar to how Express.js apps often have `/services` or `/utils` folders.

It's not technically required (you could put everything in the route handlers), but following this convention provides better organization and maintainability as your application grows.