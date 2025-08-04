```typescript

import type {
  Document,
  FilterQuery,
  Model,
  PipelineStage,
  PopulateOptions,
  ProjectionType,
  QueryOptions,
  UpdateQuery
} from 'mongoose';
import mongoose from 'mongoose';
import type { COLLECTIONS, ENTITY_SORT } from '../constants/db.constants';
import { ENTITY_STATUS } from '../constants/db.constants';
import { BaseExtrasDTO, IBaseEntity, OmitBaseEntity } from '../dto/common.dto';

export class CommonDatabaseService<T extends IBaseEntity, U extends Model<T>> {
  protected model: U;

  constructor(model: U) {
    this.model = model;
  }

  public create = async (data: OmitBaseEntity<T>, session?: mongoose.ClientSession) => {
    if (session) {
      const document = new this.model(data);
      return document.save({ session });
    } else {
      return this.model.create(data);
    }
  };

  public createMany = async (data: OmitBaseEntity<T>[]) =>
    this.model.insertMany(data, { ordered: true, rawResult: true });

  public findAll = async (
    filters: FilterQuery<T>,
    options?: {
      sort_by?: string;
      sort_order?: ENTITY_SORT;
      limit?: number;
      skip?: number;
      search_key?: string;
      search_string?: string;
      hide_deleted?: boolean;
      lookup?: {
        from: COLLECTIONS;
        localField: keyof T extends string ? keyof T : string;
        foreignField: string;
        as: string;
      }[];
    }
  ): Promise<{
    results: (Document<unknown, unknown, T> & T & Required<{ _id: string }>)[];
    extras: BaseExtrasDTO;
  }> => {
    const searchPipelines: PipelineStage[] = [];
    const paginationPipelines: PipelineStage.FacetPipelineStage[] =
      (options?.limit ?? 0) > 0 && (options?.skip ?? 0) >= 0
        ? [{ $skip: options?.skip ?? 0 }, { $limit: options?.limit ?? 0 }]
        : [];

    if (filters) {
      if (filters.createdAt) {
        const { $gte, $lte } = filters.createdAt;

        filters.createdAt = {
          $gte: new Date($gte),
          $lt: new Date($lte)
        };
      }

      searchPipelines.push({
        $match: {
          ...filters
        }
      });
    }

    if (options?.search_key && options?.search_string) {
      const search: Record<string, object> = {};

      search[`${options.search_key}`] = {
        $regex: options.search_string,
        $options: 'i'
      };

      searchPipelines.push({
        $match: {
          $or: [{ ...search }]
        }
      });
    }

    if (options?.hide_deleted) {
      searchPipelines.push({
        $match: {
          status: { $ne: ENTITY_STATUS.DELETED }
        }
      });
    }

    if (options?.lookup?.length) {
      for (const lookup of options.lookup) {
        searchPipelines.push({
          $lookup: lookup
        });

        searchPipelines.push({
          $unwind: {
            path: `$${lookup.as}`,
            preserveNullAndEmptyArrays: true
          }
        });
      }
    }

    const aggregatedDocs = await this.model.aggregate([
      ...searchPipelines,

      {
        $facet: {
          results: [
            {
              $sort: {
                [options?.sort_by ?? 'createdAt']: options?.sort_order === 'asc' ? 1 : -1
              }
            },
            ...paginationPipelines
          ],
          extras: [
            {
              $count: 'total'
            }
          ]
        }
      },
      {
        $unwind: {
          path: '$extras',
          preserveNullAndEmptyArrays: true
        }
      },
      {
        $project: {
          results: 1,
          extras: {
            $ifNull: ['$extras', { total: 0 }]
          }
        }
      },
      {
        $addFields: {
          extras: {
            total: '$extras.total',
            limit: options?.limit,
            skip: options?.skip
          }
        }
      }
    ]);

    return Promise.resolve(aggregatedDocs[0]);
  };

  public findAllAndPopulate = async <V>(
    filters: FilterQuery<T>,
    populateOptions: PopulateOptions | (string | PopulateOptions)[],
    queryOptions?: QueryOptions<T>
  ) => {
    const result = await this.model.find(filters, {}, queryOptions).populate<V>(populateOptions);
    return result ?? undefined;
  };

  public findOne = async (
    filters: FilterQuery<T>,
    lean?: boolean,
    projection?: ProjectionType<T>
  ) => {
    if (lean) {
      const result = await this.model.findOne(filters).lean();
      return result ?? undefined;
    }
    const result = await this.model.findOne(filters, projection);
    return result ?? undefined;
  };

  public findOneAndPopulate = async <V>(
    filters: FilterQuery<T>,
    populateOptions: PopulateOptions | (string | PopulateOptions)[]
  ) => {
    const result = await this.model.findOne(filters).populate<V>(populateOptions);
    return result ?? undefined;
  };

  public findById = async (id: string) => this.model.findById(id) ?? undefined;

  public updateById = async (id: string, data: UpdateQuery<T>) =>
    this.model.findByIdAndUpdate(id, data, {
      returnDocument: 'after'
    });

  public updateOne = async (
    filters: FilterQuery<T>,
    data: UpdateQuery<T>,
    options?: QueryOptions<T>
  ) =>
    this.model.findOneAndUpdate(filters, data, {
      returnDocument: 'after',
      new: true,
      ...options
    });

  public updateMany = async (filters: FilterQuery<T>, data: UpdateQuery<T>) =>
    this.model.updateMany(filters, data, { returnDocument: 'after' });

  public deleteById = async (id: string) =>
    this.model.findByIdAndDelete(id, { returnDocument: 'after' });

  public deleteOne = async (filters: FilterQuery<T>) => this.model.deleteOne(filters);

  public deleteMany = async (filters: FilterQuery<T>) =>
    this.model.deleteMany(filters, {
      returnDocument: 'after'
    });

  public getDocumentCounts = async (
    groupByField: string,
    additionalFilters: Record<string, unknown> = {}
  ) => {
    const pipeline = [
      { $match: additionalFilters },
      {
        $group: {
          _id: `$${groupByField}`,
          count: { $sum: 1 }
        }
      },
      {
        $project: {
          _id: 0,
          [groupByField]: '$_id',
          count: 1
        }
      }
    ];

    return this.model.aggregate(pipeline);
  };
}

```