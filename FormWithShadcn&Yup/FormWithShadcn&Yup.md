To capture user input and interactions we need to wrap up the interactive elements with form elements.
Here we are going to use Shadcn form elements and yup validations for validating fields.

## Required Packages
- ReactJS
- Shadcn
- Yup

## Steps
1. install form components from Shadcn "npx shadcn-ui@latest add form
".
2. install Yup 
3. install react-hook-form
4. create form schema
   
  const formSchema = object({
 fieldName:string().required('Required'),
  });
 (this should be created outside of the functional component)

5. create a form instance of the react-hook-form
import { useForm } from 'react-hook-form';

  const form = useForm<InferType<typeof formSchema>>({
    resolver: yupResolver(formSchema),
    defaultValues: {
      fieldName: '', }, });

6. make a submit function

     const onSubmit = form.handleSubmit((values) => {
      console.log({ data: values });
	 });

7. make the Form components with proper wrappings.

//Form should be imported from components, not from react-hook-form
     <Form {...form}>
      <form onSubmit={onSubmit} className='p-4'>   this is an html tag
      above 2 tags are wrapper tags

following is the form element component, which should wrap up an interactive elements

4 Elements are here.

# Input

<FormField
          control={form.control} //transfering form control to react hook form
          name='email'
          render={({ field }) => ( // note that this is a function
            <FormItem>
              <FormLabel className='select-none'>Email</FormLabel>
              <FormControl>
               <Input placeholder='name@email.com' {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        </form>
    </Form>

# Select (Dropdown)


# OTP Input
<FormField
          control={form.control}
          name="pin"
          render={({ field }) => (
            <FormItem>
              <FormLabel>One-Time Password</FormLabel>
              <FormControl>
                <InputOTP maxLength={6} {...field}>
                  <InputOTPGroup>
                    <InputOTPSlot index={0} />
                    <InputOTPSlot index={1} />
                    <InputOTPSlot index={2} />
                    <InputOTPSlot index={3} />
                    <InputOTPSlot index={4} />
                    <InputOTPSlot index={5} />
                  </InputOTPGroup>
                </InputOTP>
              </FormControl>
              <FormDescription>
                Please enter the one-time password sent to your phone.
              </FormDescription>
              <FormMessage />
            </FormItem>
          )}
        />
  
### finally a submit button should be there.

<Button
          loading={isLoading
          disabled={isLoading}
          type='submit' // note that this is a submit button
          className='gap-1 mt-5 select-none'
        >
          Submit
        </Button>
## sometimes another button somewhere would act as a subit button, in such instances we should provide type="button" to such button