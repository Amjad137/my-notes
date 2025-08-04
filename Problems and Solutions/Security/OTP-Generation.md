```typescript

import { IOneTimeCode, OneTimeCode, OneTimeCodeModel } from '@/models/one-time-code.model';

import otpGenerator from 'otp-generator';

import { CommonDatabaseService } from './common.database.service';

  

class OneTimeCodeService extends CommonDatabaseService<IOneTimeCode, OneTimeCodeModel> {

  constructor() {

    super(OneTimeCode);

  }

  

  public generateOtp = ({

    length = 6,

    includeDigits = true,

    includeLowerCaseAlphabets = false,

    includeSpecialChars = false,

    includeUpperCaseAlphabets = true

  }: {

    length?: number;

    includeDigits?: boolean;

    includeLowerCaseAlphabets?: boolean;

    includeSpecialChars?: boolean;

    includeUpperCaseAlphabets?: boolean;

  } = {}) => {

    return otpGenerator.generate(length, {

      digits: includeDigits,

      lowerCaseAlphabets: includeLowerCaseAlphabets,

      specialChars: includeSpecialChars,

      upperCaseAlphabets: includeUpperCaseAlphabets

    });

  };

}

  

export default new OneTimeCodeService();


```
