export enum ENVIRONMENTS {
  PRODUCTION = 'production',
  QA = 'qa',
  STAGING = 'staging',
  DEV = 'development',
  LOCAL = 'local',
  TEST = 'test',
}

export interface ICommonResponseDTO<T> {
  error: boolean;
  message: string;
  data: T;
}