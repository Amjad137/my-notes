
```typescript
'use client';

import Axios from '@/config/api.config';
import { firebaseAuth } from '@/config/firebase.config';
import { ROUTES } from '@/constants/routes.constants';
import { toast } from '@/hooks/use-toast';
import { useProfileStore } from '@/stores/profile.store';
import { onAuthStateChanged, User } from 'firebase/auth';
import { useRouter } from 'next/navigation';
import React, { createContext, useContext, useEffect, useState } from 'react';

interface AuthContextProps {
  currentUser: User | null;
  token: string | null;
  signOut: () => void;
}

const AuthContext = createContext<AuthContextProps | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export const signOut = async () => {
  try {
    await firebaseAuth.signOut();
    toast({ title: 'Signed out successfully!' });
  } catch (error) {
    console.error('Error signing out:', error);
    toast({ title: 'Error signing out!', variant: 'destructive' });
  }
};

const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const router = useRouter();
  const [currentUser, setCurrentUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const { setFirebaseUid } = useProfileStore();

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(firebaseAuth, async (user) => {
      if (!user) {
        toast({
          title: 'Sign in to Continue!',
          variant: 'destructive',
        });
        setToken(null);
        router.push(ROUTES.SIGN_IN);
        return;
      }

      try {
        const userToken = await user.getIdToken();
        setCurrentUser(user);
        setToken(userToken);
        setFirebaseUid(user.uid);

        // Fetch profile only after token is set
        await Axios.get('/v1/profile/me');
      } catch (error) {
        console.error('Authentication error:', error);
        toast({
          title: 'Authentication failed!',
          variant: 'destructive',
        });
      }
    });

    return () => unsubscribe();
  }, [router, setFirebaseUid]);

  return (
    <AuthContext.Provider value={{ currentUser, token, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};

export default AuthProvider;

```