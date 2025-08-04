If we want to create a field which is in type of an Enum but it shouldn't has a value from the particular enum:
```typescript

const UniversitySchema = new Schema<IUniversity, UniversityModel>(
  {
    name: { type: String, required: true },
    address: { type: String, required: true },
    domain: { type: String, required: true },
    status: {
      type: String,
      required: true,
      enum: Object.values(DOMAIN_STATUS).filter(
        (status) => status !== DOMAIN_STATUS.ALL
      ),
      default: DOMAIN_STATUS.PENDING,
    },
    contactNumber: { type: String, required: true },
  },
  {
    timestamps: true,
  }
);

```