Following code wait until the user being fetched from firebase
```typescript
import axios, { InternalAxiosRequestConfig } from 'axios';
import { environment } from './env.config';
import { firebaseAuth } from './firebase.config';

interface CustomAxiosRequestConfig extends InternalAxiosRequestConfig {
  skipAuth?: boolean;
}

const Axios = axios.create({
  baseURL: environment.apiURL,
  headers: { 'Content-Type': 'application/json' },
  withCredentials: true,
});

Axios.interceptors.request.use(
  async (config: CustomAxiosRequestConfig) => {
    if (config.skipAuth) {
      return config;
    }

    try {
      await new Promise((resolve) => {
        const unsubscribe = firebaseAuth.onAuthStateChanged((user) => {
          resolve(user);
          unsubscribe();
        });
      });

      const user = firebaseAuth.currentUser;
      if (user) {
        const token = await user.getIdToken();
        console.log('Interceptor running. Token:', token);

        config.headers.Authorization = `Bearer ${token}`;
      }
    } catch (error) {
      console.error('Token retrieval error:', error);
    }

    return config;
  },
  (error) => Promise.reject(error),
);

export default Axios;

```