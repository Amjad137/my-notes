# Class Properties in TypeScript/JavaScript

In the auth.service.ts file, `argon2Options` is defined as a class property (also called class field) directly within the `UserService` class, without using `const` or `var` keywords.

## How Class Properties Work

```typescript
export class UserService extends CommonDatabaseService<IUser, UserModel> {
  constructor() {
    super(User);
  }

  argon2Options = { // Class property/field
    memoryCost: environment.argon2MemoryCost,
    // ...other options
  };
}
```

This is a feature of modern JavaScript/TypeScript where you can define properties directly on the class without using variable declarations. When you instantiate the class:

1. The property is automatically attached to the instance (`this`)
2. It becomes accessible as `this.argon2Options` within class methods
3. The initialization happens before the constructor executes

## Equivalent Traditional Approach

The same functionality could be implemented in a more traditional way inside the constructor:

```typescript
export class UserService extends CommonDatabaseService<IUser, UserModel> {
  // Declare the property type (TypeScript only)
  private argon2Options: {
    memoryCost: number;
    timeCost: number;
    outputLen: number;
    parallelism: number;
  };

  constructor() {
    super(User);
    
    // Initialize the property
    this.argon2Options = {
      memoryCost: environment.argon2MemoryCost,
      timeCost: environment.argon2TimeCost,
      outputLen: environment.argon2OutputLength,
      parallelism: environment.argon2Parallelism
    };
  }
}
```

The class field syntax is more concise and helps separate property declarations from initialization logic.