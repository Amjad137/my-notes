export const Schema: ObjectSchema = object({
  type: mixed<CODE_TYPE>().oneOf(Object.values(CODE_TYPE)).required(),
 
  email: string().when('type', {
    is: `${CODE_TYPE.EMAIL}`,
    then: (email) => email.required(),
  }),
  phoneNumber: string().when('type', {
    is: `${CODE_TYPE.CONTACT_NUMBER}`,
    then: (phoneNumber) => phoneNumber.required(),
  }),
  countryCode: string().when('type', {
    is: `${CODE_TYPE.CONTACT_NUMBER}`,
    then: (countryCode) => countryCode.required(),
  }),
});

check email field here,
An importan rule here is, this will check for certain value only
i.e: the condition will be like if type===email then....

