import { ENVIRONMENTS } from '../constants/common.constants';
import { VERSION } from '../version';

export const environment = {
  isDebugMode:
    process.env.NODE_ENV === ENVIRONMENTS.DEV || process.env.NODE_ENV === ENVIRONMENTS.TEST,
  env: process.env.NODE_ENV as ENVIRONMENTS,
  packageName: process.env.PACKAGE_NAME as string,
  packageVersion: VERSION,
  siteURL: process.env.NEXT_PUBLIC_SITE_URL as string,
  apiURL: process.env.NEXT_PUBLIC_API_URL as string,
};
