defined using Yup's `string` type and chained `test` methods

## Refer [[test() in JS RegEx]] to understand the RegEx test()


{/**- If the value is `null` or `undefined` (i.e., not provided), it returns `true`, meaning this test will not trigger an error. This allows other tests to handle the `required` validation if needed.*/}

const passwordStrength = string()
  .test('password-length', 'Password must contain at least 8 characters,', value => {
    if (!value) {
      return true;
    }
    return value.length >= 8;
  })
  .test('password-uppercase', 'Password must contain at least 1 uppercase character', value => {
    if (!value) {
      return true;
    }
    return /[A-Z]/.test(value);
  })
  .test('password-lowercase', 'Password must contain at least 1 lowercase character', value => {
    if (!value) {
      return true;
    }
    return /[a-z]/.test(value);
  })
  .test('password-special', 'Password must contain at least 1 special character', value => {
    if (!value) {
      return true;
    }
    return /[!@#$%^&*(),.?":{}|<>]/.test(value);
  });


# Usage

const userCreateSchema = object({
  password: passwordStrength.required('Password is required.'),
});




