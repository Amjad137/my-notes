is useful when we want to validate a schema based on a variable value.
### Triggers the error when it receive *false*
Example:

const personalInformation = useOnboardingIndividualAccountStore.getState().personalInformation;
const isAdvisorRequested: boolean = personalInformation?.isAdvisorRequested;

const formSchema = object({
  contracts: fileValidation(true).test(
    'conditional-required', //name
    'This Field is Required', //message
    function (value) { 
      if (isAdvisorRequested) {
        return true;
      } else {
        return !!value;
      }
    },
  ),

Documentation:

## `Schema.test(name: string, message: string | function | any, test: function): Schema`[​](https://yup-docs.vercel.app/docs/Api/schema#schematestname-string-message-string--function--any-test-function-schema "Direct link to heading")

Adds a test function to the validation chain. Tests are run after any object is cast. Many types have some tests built in, but you can create custom ones easily. In order to allow asynchronous custom validations _all_ (or no) tests are run asynchronously. A consequence of this is that test execution order cannot be guaranteed.

All tests must provide a `name`, an error `message` and a ==validation function that must return `true` when the current `value` is valid== and `false` or a `ValidationError` otherwise. To make a test async return a promise that resolves `true` or `false` or a `ValidationError`.

For the `message` argument you can provide a string which will interpolate certain values if specified using the `${param}` syntax. By default all test messages are passed a `path` value which is valuable in nested schemas.
