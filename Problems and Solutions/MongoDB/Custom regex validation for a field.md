```typescript
import { IBaseEntity } from '@/constants/common.constants';
import { Model, model, Schema } from 'mongoose';
import { COLLECTIONS } from '../constants/db.constants';

export enum PERIOD_TYPE {
  REGULAR = 'REGULAR',
  BREAK = 'BREAK',
  LUNCH = 'LUNCH',
  ASSEMBLY = 'ASSEMBLY',
  STUDY_HALL = 'STUDY_HALL',
  SPORTS = 'SPORTS',
  LIBRARY = 'LIBRARY',
  EXTRA_CURRICULAR = 'EXTRA_CURRICULAR'
}

export enum DAY_OF_WEEK {
  MONDAY = 'MONDAY',
  TUESDAY = 'TUESDAY',
  WEDNESDAY = 'WEDNESDAY',
  THURSDAY = 'THURSDAY',
  FRIDAY = 'FRIDAY',
  SATURDAY = 'SATURDAY',
  SUNDAY = 'SUNDAY'
}

export interface IPeriod extends IBaseEntity {
  name: string;
  startTime: string; // Format: "HH:mm" (24-hour format)
  endTime: string; // Format: "HH:mm" (24-hour format)
  duration: number; // Duration in minutes
  dayOfWeek: DAY_OF_WEEK;
  periodOrder: number; // Order/sequence of the period in the day
  type: PERIOD_TYPE;
  isActive: boolean;
  description?: string;
}

export interface PeriodModel extends Model<IPeriod> {}

const periodSchema = new Schema<IPeriod>(
  {
    name: { type: String, required: true, trim: true },
    startTime: {
      type: String,
      required: true,
      validate: {
        validator: function (v: string) {
          return /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/.test(v);
        },
        message: 'Start time must be in HH:mm format'
      }
    },
    endTime: {
      type: String,
      required: true,
      validate: {
        validator: function (v: string) {
          return /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/.test(v);
        },
        message: 'End time must be in HH:mm format'
      }
    },
    duration: { type: Number, required: true, min: 1 },
    dayOfWeek: {
      type: String,
      enum: Object.values(DAY_OF_WEEK),
      required: true
    },
    periodOrder: { type: Number, required: true, min: 1 },
    type: {
      type: String,
      enum: Object.values(PERIOD_TYPE),
      required: true
    },
    isActive: { type: Boolean, default: true },
    description: { type: String, trim: true }
  },
  { timestamps: true }
);

// Compound index to prevent duplicate periods for same day and order
periodSchema.index({ dayOfWeek: 1, periodOrder: 1 }, { unique: true });

// Index for efficient time-based queries
periodSchema.index({ dayOfWeek: 1, startTime: 1 });
periodSchema.index({ type: 1, isActive: 1 });

// Pre-save middleware to calculate duration
periodSchema.pre('save', function () {
  if (this.startTime && this.endTime) {
    const [startHour, startMin] = this.startTime.split(':').map(Number);
    const [endHour, endMin] = this.endTime.split(':').map(Number);

    const startMinutes = startHour * 60 + startMin;
    const endMinutes = endHour * 60 + endMin;

    this.duration = endMinutes - startMinutes;
  }
});

export const Period = model<IPeriod, PeriodModel>(COLLECTIONS.PERIODS, periodSchema);

```