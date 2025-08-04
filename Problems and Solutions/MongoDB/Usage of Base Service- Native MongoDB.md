## Option 1: Inheritance (Extending the Base Service)

```typescript

import { ObjectId } from 'mongodb';
import { createDatabaseService, DatabaseService } from './base-database-service';
import { IBaseEntity } from '@/lib/constants/db.constants';

// Define merchant request interfaces
export interface IBusinessRep {
  name: string;
  phoneNumber?: string;
  email?: string;
}

// Define merchant request status enum
export enum MERCHANT_REQUEST_STATUS {
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected',
}

// Define the merchant request document interface
export interface IMerchantRequest {
  businessName: string;
  email: string;
  address?: string;
  templateId?: string;
  businessRep?: IBusinessRep;
  status: MERCHANT_REQUEST_STATUS;
}

// Create validator function for merchant requests
const validateMerchantRequest = (data: Partial<IMerchantRequest>) => {
  const errors: string[] = [];

  if (!data.businessName) {
    errors.push('Business name is required');
  }

  if (!data.email) {
    errors.push('Email is required');
  } else if (!/^\S+@\S+\.\S+$/.test(data.email)) {
    errors.push('Email format is invalid');
  }

  return {
    valid: errors.length === 0,
    errors,
  };
};

// Create the merchant request service
const merchantRequestDatabaseService = createDatabaseService<IMerchantRequest>({
  collectionName: 'merchant_requests',
  validator: validateMerchantRequest,
});

// Extend with application-specific methods
export class MerchantRequestService extends DatabaseService<IMerchantRequest> {
  constructor() {
    super({
      collectionName: 'merchant_requests',
      validator: validateMerchantRequest,
    });
  }

  // Only need to define domain-specific methods
  async updateStatus(id: string | ObjectId, status: MERCHANT_REQUEST_STATUS) {
    return this.updateOne(id, { status });
  }

  async findPendingRequests() {
    return this.findAll({ status: MERCHANT_REQUEST_STATUS.PENDING });
  }
}

// Export singleton instance
export const merchantRequestService = new MerchantRequestService();


```

## Option 2 : Composition with Method Forwarding

```typescript
export class MerchantRequestService {
  private readonly dbService: DatabaseService<IMerchantRequest>;

  constructor() {
    this.dbService = merchantRequestDatabaseService;
  }
  
  // Forward all methods from dbService without redefining them
  createOne = this.dbService.createOne.bind(this.dbService);
  findById = this.dbService.findById.bind(this.dbService);
  findAll = this.dbService.findAll.bind(this.dbService);
  updateOne = this.dbService.updateOne.bind(this.dbService);
  deleteOne = this.dbService.deleteOne.bind(this.dbService);
  
  // Just add domain-specific methods
  async updateStatus(id: string | ObjectId, status: MERCHANT_REQUEST_STATUS) {
    return this.dbService.updateOne(id, { status });
  }
  
  // Other domain-specific methods...
}
```

## Option 3: Using with Selective Exposing And Redefining

```typescript

import { ObjectId } from 'mongodb';
import { createDatabaseService, DatabaseService } from './base-database-service';
import { IBaseEntity } from '@/lib/constants/db.constants';

// Define merchant request interfaces
export interface IBusinessRep {
  name: string;
  phoneNumber?: string;
  email?: string;
}

// Define merchant request status enum
export enum MERCHANT_REQUEST_STATUS {
  PENDING = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected',
}

// Define the merchant request document interface
export interface IMerchantRequest {
  businessName: string;
  email: string;
  address?: string;
  templateId?: string;
  businessRep?: IBusinessRep;
  status: MERCHANT_REQUEST_STATUS;
}

// Create validator function for merchant requests
const validateMerchantRequest = (data: Partial<IMerchantRequest>) => {
  const errors: string[] = [];

  if (!data.businessName) {
    errors.push('Business name is required');
  }

  if (!data.email) {
    errors.push('Email is required');
  } else if (!/^\S+@\S+\.\S+$/.test(data.email)) {
    errors.push('Email format is invalid');
  }

  return {
    valid: errors.length === 0,
    errors,
  };
};

// Create the merchant request service
const merchantRequestDatabaseService = createDatabaseService<IMerchantRequest>({
  collectionName: 'merchant_requests',
  validator: validateMerchantRequest,
});

// Extend with application-specific methods
export class MerchantRequestService {
  private readonly dbService: DatabaseService<IMerchantRequest>;

  constructor() {
    this.dbService = merchantRequestDatabaseService;
  }

  // Core database operations (pass-through to database service)
  async create(data: Partial<IMerchantRequest>) {
    return this.dbService.createOne(data as IMerchantRequest);
  }

  async findById(id: string | ObjectId) {
    return this.dbService.findById(id);
  }

  async findAll(filter = {}, options = {}) {
    return this.dbService.findAll(filter, options);
  }

  async update(id: string | ObjectId, updates: Partial<IMerchantRequest>) {
    return this.dbService.updateOne(id, updates);
  }

  async delete(id: string | ObjectId) {
    return this.dbService.deleteOne(id);
  }

  // Domain-specific methods
  async updateStatus(id: string | ObjectId, status: MERCHANT_REQUEST_STATUS) {
    return this.dbService.updateOne(id, { status });
  }

  async findByStatus(status: MERCHANT_REQUEST_STATUS) {
    return this.dbService.findAll({ status });
  }

  async findPendingRequests() {
    return this.findByStatus(MERCHANT_REQUEST_STATUS.PENDING);
  }

  async findByBusinessName(name: string) {
    // Case-insensitive partial match
    return this.dbService.findAll({
      businessName: { $regex: name, $options: 'i' },
    });
  }

  async setupIndexes() {
    return this.dbService.setupIndexes([
      { businessName: 1 },
      { email: 1 },
      { status: 1 },
      { 'businessRep.name': 1 },
    ]);
  }
}

// Export singleton instance
export const merchantRequestService = new MerchantRequestService();

```


# Usage of Created Service in APIs

```typescript
import { MERCHANT_REQUEST_STATUS } from '@/lib/constants/db.constants';
import { merchantRequestService } from '@/lib/db/services/merchant-requests.service';
import { NextRequest, NextResponse } from 'next/server';

export async function POST(request: NextRequest) {
  try {
    // Parse the request body
    const body = await request.json();

    // Create a new merchant request
    const result = await merchantRequestService.createOne({
      businessName: body.businessName,
      email: body.email,
      address: body.address,
      templateId: body.templateId,
        businessRep: body.businessRep,
      status:MERCHANT_REQUEST_STATUS.PENDING,
    });

    return NextResponse.json(
      {
        success: true,
        requestId: result._id,
        message: 'Merchant request submitted successfully',
      },
      { status: 201 },
    );
  } catch (error: any) {
    console.error('Error creating merchant request:', error);

    return NextResponse.json(
      {
        success: false,
        message: error.message || 'Failed to create merchant request',
      },
      { status: 400 },
    );
  }
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const status = searchParams.get('status');

    let requests;
    if (status) {
      requests = await merchantRequestService.findByStatus(status as MERCHANT_REQUEST_STATUS);
    } else {
      requests = await merchantRequestService.findAll();
    }

    return NextResponse.json({
      success: true,
      data: requests,
    });
  } catch (error: any) {
    console.error('Error fetching merchant requests:', error);

    return NextResponse.json(
      {
        success: false,
        message: error.message || 'Failed to fetch merchant requests',
      },
      { status: 500 },
    );
  }
}

```
