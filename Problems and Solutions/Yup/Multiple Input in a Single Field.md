//schema
const formSchema = object({
  phoneNumbers: array().of(string().required('Required')),
});

const form = useForm<InferType<typeof formSchema>>({
    resolver: yupResolver(formSchema),
    defaultValues: {},
  });

  const incrementNumber = () => {
    if (count < 10) {
      setCount((prevCount) => prevCount + 1);
    }
  };

  const decrementNumber = () => {
    if (count > 1) {
      setCount((prevCount) => prevCount - 1);
    }
  };

component:

here we will loop the input element as many time as the user prefer and capture the inputs.

<div className='grid grid-rows-5 grid-flow-col w-[60%] gap-6 mt-4'>
          {Array.from({ length: count }).map((_, index) => {
            return (
              <div className={`flex flex-col gap-1 ${count <= 5 ? 'w-1/2' : ''} `} key={index}>
                <span className='text-sm text-foreground font-medium'>{`Account ${index < 9 ? '0' : ''}${index + 1}`}</span>
                <FormField
                  control={form.control}
                  name={`accounts.${index}`}
                  render={({ field }) => (
                    <FormItem>
                      <FormControl>
                        <Combobox
                          data={currencyData}
                          placeholder='Select Currency'
                          onChange={field.onChange}
                          style={{
                            border: '1px solid gray',
                            borderRadius: '10px',
                          }}
                        />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
              </div>
            );
          })}
        </div>


name={`accounts.${index}`} this should be noted which is passed to the formfield