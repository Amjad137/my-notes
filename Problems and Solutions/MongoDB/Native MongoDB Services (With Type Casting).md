```typescript

import { IBaseEntity, OmitBaseEntity } from '@/lib/constants/db.constants';
import {
  Collection,
  Document,
  Filter,
  FindOptions,
  MongoClient,
  ObjectId,
  OptionalUnlessRequiredId,
  ServerApiVersion,
  Sort,
  UpdateFilter,
  WithId,
} from 'mongodb';

// MongoDB connection configuration
const uri = process.env.MONGODB_URI as string;
const clientOptions = {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
};

// Configuration for the database service
export interface DatabaseServiceConfig<T> {
  // Required configuration
  collectionName: string;

  // Optional configuration with sensible defaults
  validator?: (data: Partial<T>) => { valid: boolean; errors: string[] };
  documentCreator?: (data: Partial<T>) => T & IBaseEntity;
  formatter?: (document: WithId<T>) => T & IBaseEntity;
}

// Query options type
export interface QueryOptions {
  limit?: number;
  skip?: number;
  sort?: Sort;
  projection?: Document;
}

export class DatabaseService<T> {
  private readonly collectionName: string;
  private readonly validator: (data: Partial<T>) => {
    valid: boolean;
    errors: string[];
  };
  private readonly documentCreator: (data: T) => T & IBaseEntity;
  private readonly formatter: (document: WithId<T>) => T & IBaseEntity;

  constructor(config: DatabaseServiceConfig<T>) {
    this.collectionName = config.collectionName;

    // Set default validator if not provided
    this.validator =
      config.validator ||
      ((data: Partial<T>) => {
        return { valid: true, errors: [] };
      });

    // Set default document creator if not provided
    this.documentCreator =
      config.documentCreator ||
      ((data: Partial<T>) => {
        return {
          ...(data as object),
          _id: new ObjectId(),
          createdAt: new Date(),
        } as T & IBaseEntity;
      });

    // Set default formatter if not provided
    this.formatter =
      config.formatter ||
      ((document: WithId<T>) => {
        const formatted = { ...document, _id: document._id?.toString() };
        return formatted as T & IBaseEntity;
      });
  }

  // Get MongoDB collection
  protected getCollection(client: MongoClient): Collection<WithId<T>> {
    return client.db().collection<WithId<T>>(this.collectionName);
  }

  // Connect to MongoDB
  protected async getClient(): Promise<MongoClient> {
    const client = new MongoClient(uri, clientOptions);
    await client.connect();
    return client;
  }

  // Create a new document
  async createOne(
    data: T,
  ): Promise<{ success: boolean; _id?: string | ObjectId; document?: Record<string, any> }> {
    const client = await this.getClient();
    const session = client.startSession();

    try {
      // Validate data
      const validation = this.validator(data);
      if (!validation.valid) {
        throw new Error(validation.errors.join(', '));
      }

      const result = await session.withTransaction(async () => {
        // Create document
        const document = this.documentCreator(data);

        // Insert to MongoDB
        const collection = this.getCollection(client);
        const insertResult = await collection.insertOne(
          document as OptionalUnlessRequiredId<WithId<T>>,
        );

        return {
          success: true,
          _id: insertResult.insertedId,
          document: this.formatter(document as WithId<T>),
        };
      });

      return result;
    } catch (error: any) {
      console.error('Create operation failed:', error);
      throw error;
    } finally {
      await session.endSession();
      await client.close();
    }
  }

  // Create multiple documents
  async createMany(dataArray: T[]): Promise<{ success: boolean; count: number; ids?: ObjectId[] }> {
    const client = await this.getClient();
    const session = client.startSession();

    try {
      const result = await session.withTransaction(async () => {
        // Validate all documents
        for (const data of dataArray) {
          const validation = this.validator(data);
          if (!validation.valid) {
            throw new Error(`Validation failed: ${validation.errors.join(', ')}`);
          }
        }

        // Create documents
        const documents = dataArray.map((data) => this.documentCreator(data));

        // Insert to MongoDB
        const collection = this.getCollection(client);
        const insertResult = await collection.insertMany(
          documents as OptionalUnlessRequiredId<WithId<T>>[],
          { session },
        );

        return {
          success: true,
          count: insertResult.insertedCount,
          ids: Object.values(insertResult.insertedIds),
        };
      });

      return result;
    } catch (error: any) {
      console.error('Create many operation failed:', error);
      throw error;
    } finally {
      await session.endSession();
      await client.close();
    }
  }

  // Find document by ID
  async findById(id: string | ObjectId): Promise<Record<string, any> | null> {
    const client = await this.getClient();

    try {
      const collection = this.getCollection(client);
      const objId = typeof id === 'string' ? new ObjectId(id) : id;
      const document = await collection.findOne({ _id: objId } as Filter<WithId<T>>);

      return document ? this.formatter(document as WithId<T>) : null;
    } catch (error: any) {
      console.error(`Error finding document by ID ${id}:`, error);
      throw error;
    } finally {
      await client.close();
    }
  }

  // Find one document with filter
  async findOne(filter: Filter<T> = {}): Promise<Record<string, any> | null> {
    const client = await this.getClient();

    try {
      const collection = this.getCollection(client);
      const document = await collection.findOne(filter as Filter<WithId<T>>);

      return document ? this.formatter(document as WithId<T>) : null;
    } catch (error: any) {
      console.error('Error finding document:', error);
      throw error;
    } finally {
      await client.close();
    }
  }

  // Find documents with filters
  async findAll(
    filter: Filter<T> = {},
    options: QueryOptions = {},
  ): Promise<Record<string, any>[]> {
    const client = await this.getClient();

    try {
      const collection = this.getCollection(client);

      const findOptions: FindOptions<T & Document> = {};
      if (options.projection) findOptions.projection = options.projection;

      const cursor = collection.find(filter as Filter<WithId<T>>, findOptions);

      if (options.sort) cursor.sort(options.sort);
      if (options.skip) cursor.skip(options.skip);
      if (options.limit) cursor.limit(options.limit);

      const documents = await cursor.toArray();
      return documents.map((doc) => this.formatter(doc as WithId<T>));
    } catch (error: any) {
      console.error('Error finding documents:', error);
      throw error;
    } finally {
      await client.close();
    }
  }

  // Count documents
  async count(filter: Filter<WithId<T>> = {}): Promise<number> {
    const client = await this.getClient();

    try {
      const collection = this.getCollection(client);
      return await collection.countDocuments(filter);
    } catch (error: any) {
      console.error('Error counting documents:', error);
      throw error;
    } finally {
      await client.close();
    }
  }

  // Update document
  async updateOne(
    id: string | ObjectId,
    updates: Partial<T>,
  ): Promise<{ success: boolean; modifiedCount: number; document?: Record<string, any> }> {
    const client = await this.getClient();
    const session = client.startSession();

    try {
      const objId = typeof id === 'string' ? new ObjectId(id) : id;

      // Don't allow updating _id, createdAt
      const { _id, createdAt, ...safeUpdates } = updates as any;

      const result = await session.withTransaction(async () => {
        const collection = this.getCollection(client);

        const updateResult = await collection.findOneAndUpdate(
          { _id: objId } as Filter<WithId<T>>,
          {
            $set: {
              ...safeUpdates,
              updatedAt: new Date(),
            },
          },
          { session, returnDocument: 'after' },
        );

        return {
          success: !!updateResult?._id,
          modifiedCount: updateResult?._id ? 1 : 0,
          document: updateResult ? this.formatter(updateResult as WithId<T>) : undefined,
        };
      });

      return result;
    } catch (error: any) {
      console.error(`Error updating document ${id}:`, error);
      throw error;
    } finally {
      await session.endSession();
      await client.close();
    }
  }

  // Update many documents
  async updateMany(
    filter: Filter<WithId<T>>,
    updates: UpdateFilter<WithId<T>>,
  ): Promise<{ success: boolean; modifiedCount: number }> {
    const client = await this.getClient();
    const session = client.startSession();

    try {
      const result = await session.withTransaction(async () => {
        const collection = this.getCollection(client);

        // Add updatedAt to the update operation
        if (!updates.$set) updates.$set = {} as Partial<WithId<T>>;
        (updates.$set as any).updatedAt = new Date();

        const updateResult = await collection.updateMany(filter, updates, { session });

        return {
          success: updateResult.matchedCount > 0,
          modifiedCount: updateResult.modifiedCount,
        };
      });

      return result;
    } catch (error: any) {
      console.error('Error updating documents:', error);
      throw error;
    } finally {
      await session.endSession();
      await client.close();
    }
  }

  // Delete document
  async deleteOne(id: string | ObjectId): Promise<{ success: boolean }> {
    const client = await this.getClient();
    const session = client.startSession();

    try {
      const objId = typeof id === 'string' ? new ObjectId(id) : id;

      const result = await session.withTransaction(async () => {
        const collection = this.getCollection(client);
        const deleteResult = await collection.deleteOne({ _id: objId } as Filter<WithId<T>>, {
          session,
        });

        return {
          success: deleteResult.deletedCount > 0,
        };
      });

      return result;
    } catch (error: any) {
      console.error(`Error deleting document ${id}:`, error);
      throw error;
    } finally {
      await session.endSession();
      await client.close();
    }
  }

  // Delete many documents
  async deleteMany(filter: Filter<T>): Promise<{ success: boolean; deletedCount: number }> {
    const client = await this.getClient();
    const session = client.startSession();

    try {
      const result = await session.withTransaction(async () => {
        const collection = this.getCollection(client);
        const deleteResult = await collection.deleteMany(filter as Filter<WithId<T>>, { session });

        return {
          success: true,
          deletedCount: deleteResult.deletedCount || 0,
        };
      });

      return result;
    } catch (error: any) {
      console.error('Error deleting documents:', error);
      throw error;
    } finally {
      await session.endSession();
      await client.close();
    }
  }

  // Setup indexes for collection
  async setupIndexes(indexes: Record<string, number>[]): Promise<void> {
    const client = await this.getClient();

    try {
      const collection = this.getCollection(client);

      // Create default indexes
      await collection.createIndex({ createdAt: -1 });

      // Create custom indexes
      for (const index of indexes) {
        await collection.createIndex(index);
      }
    } catch (error: any) {
      console.error('Error setting up indexes:', error);
      throw error;
    } finally {
      await client.close();
    }
  }
}

// Factory function to create a database service for a specific collection
export function createDatabaseService<T extends IBaseEntity>(
  config: DatabaseServiceConfig<T>,
): DatabaseService<T> {
  return new DatabaseService<T>(config);
}

```

# Usage:

Checkout [[]]