```typescript

doctorsRoutes.post('/', createUserRequestValidator, async (c) => {
  const user = c.get('user');

  if (!user) {
    throw new UnauthorizedException(ERROR_MESSAGES.UNAUTHORIZED);
  }

  const body = await c.req.json();

  const foundUser = await userService.findOne({ email: body.email });

  if (foundUser) {
    throw new ConflictException(ERROR_MESSAGES.USER_ALREADY_EXISTS);
  }

  const passwordHash = await authService.hashPassword(body.password);

  const userId = generateId(24);

  const mongooseSession = await mongoose.startSession();

  try {
    // mongooseSession.startTransaction();
    const newUser = await userService.create(
      {
        _id: userId,
        email: body.email,
        userRole: body.userRole as USER_ROLE,
        password: passwordHash,
        status: ENTITY_STATUS.ACTIVE
      },
      mongooseSession
    );

    if (body.userRole === USER_ROLE.DOCTOR) {
      await doctorService.create(
        {
          user: newUser._id,
          fullName: body.firstName,
          dateOfBirth: new Date(),
          address: body.address,
          SLMCNo: 'abc',
          phoneNumber: 'acd',
          availability: 'dfg'
        },
        mongooseSession
      );
    }

    // await mongooseSession.commitTransaction();

    const authSession = await auth.createSession(newUser._id, {});

    c.header('Set-Cookie', auth.createSessionCookie(authSession.id).serialize(), {
      append: true
    });

    return c.json(
      {
        email: newUser.email,
        userRole: newUser.userRole,
        id: newUser._id
      },
      StatusCodes.OK
    );
  } catch (error) {
    // mongooseSession.abortTransaction();
    mongooseSession.endSession();
    console.log('🚀 Transaction aborted due to error:', error);

    if (error instanceof MongooseError) {
      return c.json({ message: error.message }, StatusCodes.INTERNAL_SERVER_ERROR);
    }
    return c.json({ message: 'An error occurred' }, StatusCodes.INTERNAL_SERVER_ERROR);
  } finally {
    mongooseSession.endSession();
  }
});
```
