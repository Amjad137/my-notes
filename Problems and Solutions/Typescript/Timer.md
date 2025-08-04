   const [sessionTimer, setSessionTimer] = useState(environment.loginSessionTimeout);
  const sessionTimerRef = useRef(sessionTimer);
  console.log('🚀 ~ AuthProvider ~ sessionTimerRef:', sessionTimerRef);
  const animationFrameId = useRef<number | null>(null);
 
 const updateTimer = useCallback(() => {
    const startTime = Date.now();
    const initialTime = sessionTimerRef.current * 1000;

    const timer = () => {
      const elapsed = Date.now() - startTime;
      const remaining = Math.max(0, initialTime - elapsed);
      const newTime = Math.ceil(remaining / 1000);

      if (newTime !== sessionTimerRef.current) {
        sessionTimerRef.current = newTime;
        setSessionTimer(newTime);
      }

      if (remaining > 0 && user?.contactNumberVerified && user?.emailVerified) {
        animationFrameId.current = requestAnimationFrame(timer);
      } else if (
        user?.contactNumberVerified &&
        user?.emailVerified &&
        sessionTimerRef.current !== environment.loginSessionTimeout
      ) {
        sessionTimerRef.current = 0;
        setSessionTimer(0);
        setShowSessionExpiredDialog(true);
      }
    };

    animationFrameId.current = requestAnimationFrame(timer);
  }, [user?.contactNumberVerified, user?.emailVerified]);

  useEffect(() => {
    updateTimer();

    return () => {
      if (animationFrameId.current !== null) {
        cancelAnimationFrame(animationFrameId.current);
      }
    };
  }, [updateTimer]);


```typescript
/* eslint-disable react-hooks/exhaustive-deps */
'use client';

import { AxiosError } from 'axios';
import { usePathname, useRouter } from 'next/navigation';
import { Fragment, useCallback, useEffect, useMemo, useRef, useState } from 'react';
import SessionTimeoutDialog from '../components/pages/auth/session-timeout-dialog';
import PageLoader from '../components/shared/page-loader';
import Axios from '../config/api.config';
import { environment } from '../config/env.config';
import { ERROR_MESSAGES } from '../constants/error.constants';
import { ROUTES } from '../constants/routes.constants';
import { useLogout } from '../hooks/use-logout';
import { toast } from '../hooks/use-toast';
import useAuthStore from '../stores/auth.store';
import { useLoadingStore } from '../stores/loading.store';
import { ICommonResponseDTO } from '../types/common.type';
import { AuthResponseDTO } from '../types/user.type';
import ErrorHandler from '../utils/error-handler';

type Props = {
  children: React.ReactNode;
};

const AuthProvider = (props: Props) => {
  const [sessionTimer, setSessionTimer] = useState(environment.loginSessionTimeout);

  const sessionTimerRef = useRef(sessionTimer);

  const [showSessionExpiredDialog, setShowSessionExpiredDialog] = useState(false);

  const animationFrameId = useRef<number | null>(null);
  const idleAnimationFrameId = useRef<number | null>(null);

  const idleDuration = environment.idleTimeout * 1000;
  const lastActivityTime = useRef(Date.now());
  const isIdle = useRef(false);

  const [resetTimer, setResetTimer] = useState(false);

  const { user, setUser, clearUser, accessToken, clearAccessToken, rehydrated, sessionInfo } =
    useAuthStore((state) => ({
      user: state.user,
      setUser: state.setUser,
      clearUser: state.clearUser,
      accessToken: state.accessToken,
      rehydrated: state.rehydrated,
      clearAccessToken: state.clearAccessToken,
      sessionInfo: state.sessionInfo,
    }));

  const { isLoading, setIsLoading } = useLoadingStore((state) => ({
    isLoading: state.isLoading,
    setIsLoading: state.setIsLoading,
  }));

  const pathname = usePathname();
  const router = useRouter();

  const logout = useLogout();

  const publicRoutes = useMemo(
    () => [
      ROUTES.SIGN_IN,
      ROUTES.SIGN_UP,
      ROUTES.EMAIL_VERIFICATION,
      ROUTES.MOBILE_VERIFICATION,
      ROUTES.FORGOT_PASSWORD_EMAIL,
      ROUTES.FORGOT_PASSWORD_EMAIL_VERIFICATION,
      ROUTES.FORGOT_PASSWORD_MOBILE,
      ROUTES.FORGOT_PASSWORD_MOBILE_VERIFICATION,
      ROUTES.FORGOT_PASSWORD_RESET,
      ROUTES.TEST_PAGE,
      '/example',
    ],
    [],
  );

  useEffect(() => {
    if (publicRoutes.some((route) => pathname.startsWith(route))) {
      setIsLoading(false);
    } else if (rehydrated && !accessToken) {
      logout();
    }
  }, [accessToken, clearUser, pathname, publicRoutes, rehydrated, router, setIsLoading]);

  useEffect(() => {
    if (accessToken && !user) {
      const getUser = async () => {
        return await Axios.get<ICommonResponseDTO<AuthResponseDTO>>('/v1/client/oauth/me', {
          headers: {
            Authorization: `Bearer ${accessToken}`,
          },
        }).then((res) => res.data.data);
      };

      getUser()
        .then((data) =>
          setUser({
            ...data.user,
          }),
        )
        .catch((err) => {
          setIsLoading(false);

          if (err instanceof AxiosError) {
            const { errorMessage } = ErrorHandler(err);

            if (errorMessage === ERROR_MESSAGES.TOKEN_EXPIRED) {
              toast({
                title: 'Error',
                description: 'Session expired. Please login again.',
                variant: 'destructive',
              });
            } else if (errorMessage === ERROR_MESSAGES.INVALID_TOKEN) {
              toast({
                title: 'Error',
                description: 'Failed to find user. Please login again.',
                variant: 'destructive',
              });
            }
          } else {
            toast({
              title: 'Error',
              description: ERROR_MESSAGES.UNKNOWN_ERR,
              variant: 'destructive',
            });
          }

          logout();
        });
    }
  }, [accessToken, clearAccessToken, clearUser, router, setIsLoading, setUser, user]);

  useEffect(() => {
    if (accessToken) {
      if (sessionInfo) {
        if (user?.isNewUser) {
          router.replace(ROUTES.CODES);
        }

        if (sessionInfo.expired) {
          setSessionTimer(0);
          sessionTimerRef.current = 0;
        } else {
          setSessionTimer(sessionInfo.duration);
          sessionTimerRef.current = sessionInfo.duration;
        }
      } else {
        toast({
          title: 'Error',
          description: 'Failed to find user session. Please login again.',
          variant: 'destructive',
        });

        logout();
      }

      setIsLoading(false);
    }
  }, [clearAccessToken, clearUser, router, setIsLoading, user]);

  const updateTimer = useCallback(() => {
    const startTime = Date.now();
    const initialTime = sessionTimerRef.current * 1000;

    const timer = () => {
      if (resetTimer) {
        setResetTimer(false);
        isIdle.current = false;
        sessionTimerRef.current = environment.loginSessionTimeout;
        setSessionTimer(environment.loginSessionTimeout);
        return;
      }

      const elapsed = Date.now() - startTime;
      const remaining = Math.max(0, initialTime - elapsed);
      const newTime = Math.ceil(remaining / 1000);

      if (newTime !== sessionTimerRef.current && isIdle.current) {
        sessionTimerRef.current = newTime;
        setSessionTimer(newTime);
      }

      if (remaining > 0 && accessToken) {
        animationFrameId.current = requestAnimationFrame(timer);
      } else if (accessToken && sessionTimerRef.current !== environment.loginSessionTimeout) {
        sessionTimerRef.current = 0;
        setSessionTimer(0);
        setShowSessionExpiredDialog(true);
      }
    };

    animationFrameId.current = requestAnimationFrame(timer);
  }, [resetTimer, accessToken]);

  const trackIdleTime = () => {
    const elapsedTime = Date.now() - lastActivityTime.current;

    if (elapsedTime >= idleDuration) {
      isIdle.current = true;
    } else {
      isIdle.current = false;
    }

    idleAnimationFrameId.current = requestAnimationFrame(trackIdleTime);
  };

  useEffect(() => {
    trackIdleTime();
    updateTimer();

    return () => {
      cleanup();
    };
  }, [trackIdleTime, updateTimer]);

  const handleUserActivity = () => {
    if (sessionTimerRef.current > environment.sessionAlertTimeout) {
      lastActivityTime.current = Date.now();

      if (isIdle.current) {
        if (idleAnimationFrameId.current !== null) {
          cancelAnimationFrame(idleAnimationFrameId.current);
        }
        isIdle.current = false;
        setSessionTimer(environment.loginSessionTimeout);
        sessionTimerRef.current = environment.loginSessionTimeout;
      }
    }
  };

  const cleanup = () => {
    if (idleAnimationFrameId.current !== null) {
      cancelAnimationFrame(idleAnimationFrameId.current);
    }
    if (animationFrameId.current !== null) {
      cancelAnimationFrame(animationFrameId.current);
    }

    document.removeEventListener('mousemove', handleUserActivity);
    document.removeEventListener('keypress', handleUserActivity);
    document.removeEventListener('scroll', handleUserActivity);
    document.removeEventListener('click', handleUserActivity);
  };

  useEffect(() => {
    document.addEventListener('mousemove', handleUserActivity);
    document.addEventListener('keypress', handleUserActivity);
    document.addEventListener('scroll', handleUserActivity);
    document.addEventListener('click', handleUserActivity);

    return () => {
      cleanup();
    };
  }, [handleUserActivity]);

  useEffect(() => {
    if (!isLoading && sessionTimer <= environment.sessionAlertTimeout) {
      isIdle.current = true;
      setShowSessionExpiredDialog(true);
    } else {
      setShowSessionExpiredDialog(false);
    }
  }, [isLoading, sessionTimer, user]);

  if (isLoading) {
    return <PageLoader />;
  }

  return (
    <Fragment>
      {props.children}
      <SessionTimeoutDialog
        open={showSessionExpiredDialog}
        setOpen={setShowSessionExpiredDialog}
        timer={sessionTimer === environment.loginSessionTimeout ? 0 : sessionTimer}
        setResetTimer={setResetTimer}
        cleanup={cleanup}
      />
    </Fragment>
  );
};

export default AuthProvider;

```


```typescript
import { AlertCircle } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { Dispatch, SetStateAction, useState } from 'react';
import Axios from '../../../config/api.config';
import { ROUTES } from '../../../constants/routes.constants';
import { useLogout } from '../../../hooks/use-logout';
import { toast } from '../../../hooks/use-toast';
import useAccessTokenStore from '../../../stores/access-token.store';
import { Button } from '../../ui/button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '../../ui/dialog';

type Props = {
  open: boolean;
  setOpen: (open: boolean) => void;
  timer: number;
  setResetTimer: Dispatch<SetStateAction<boolean>>;
  cleanup: () => void;
};

const SessionTimeoutDialog = ({ open, setOpen, timer, setResetTimer, cleanup }: Props) => {
  const [loading, setLoading] = useState(false);

  const setAccessToken = useAccessTokenStore((state) => state.setAccessToken);

  const router = useRouter();

  const logout = useLogout();

  const handleLogout = async () => {
    await logout();
    setOpen(false);
    cleanup();
    router.replace(ROUTES.SIGN_IN);
  };

  const handleTokenRefresh = async () => {
    setLoading(true);
    try {
      const res = await Axios.post('/v1/client/oauth/refresh-token').then((res) => {
        return res.data.data;
      });
      setAccessToken(res.accessToken);
      cleanup();
      setOpen(false);
      setResetTimer(true);
    } catch (error) {
      toast({
        title: 'Error',
        description: 'Failed to refresh token. Please try again or login again.',
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent
        onInteractOutside={(e) => {
          e.preventDefault();
        }}
        onEscapeKeyDown={(e) => {
          e.preventDefault();
        }}
        showClose={false}
      >
        <DialogHeader className='flex-col items-center justify-center w-full py-5 space-y-5'>
          <AlertCircle size={48} className='text-warning' />
          <DialogTitle className='text-center'>Session Expire Warning</DialogTitle>
          {timer > 0 ? (
            <DialogDescription className='w-4/5 text-center'>
              Your session will expire in <strong>{timer} seconds.</strong> To continue your
              session, select “Stay Logged In”.
            </DialogDescription>
          ) : (
            <DialogDescription className='w-4/5 text-center'>
              Your session is expired. Please login again.
            </DialogDescription>
          )}
          <div className='flex gap-4 pt-1'>
            <Button variant={'outline'} onClick={handleLogout} disabled={loading}>
              Logout
            </Button>
            {timer > 0 && (
              <Button onClick={handleTokenRefresh} loading={loading} disabled={loading}>
                Stay Logged In
              </Button>
            )}
          </div>
        </DialogHeader>
      </DialogContent>
    </Dialog>
  );
};

export default SessionTimeoutDialog;
```