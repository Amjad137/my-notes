
The same signInWithPopup() will be used for signup also.
```typescript

async function googleSignIn() {
    setGoogleAuthLoading(true);

    try {
      const provider = new GoogleAuthProvider();
      const result = await signInWithPopup(firebaseAuth, provider);

      const additionalInfo = getAdditionalUserInfo(result);
      const isNewUser = additionalInfo?.isNewUser ?? false;

      if (isNewUser) {
        await setUserRoleClaim(result.user, USER_ROLE.USER);
      }

      await postSignIn();
    } catch (error) {
      if (error instanceof FirebaseError) {
        let errorMessage = ERROR_MESSAGES.UNKNOWN_ERR;

        switch (error.code) {
          case 'auth/invalid-credential':
            errorMessage = ERROR_MESSAGES.INVALID_CREDENTIALS;
            break;
          case 'auth/popup-closed-by-user':
            errorMessage = 'Sign-in popup was closed before completing the sign-in.';
            break;
          case 'auth/cancelled-popup-request':
            errorMessage = 'Multiple sign-in popups were opened. Close extra popups and try again.';
            break;
        }

        toast({
          title: 'Error!',
          description: errorMessage,
          variant: 'destructive',
        });
      } else {
        toast({
          title: 'Error!',
          description: ERROR_MESSAGES.UNKNOWN_ERR,
          variant: 'destructive',
        });
      }
    } finally {
      setGoogleAuthLoading(false);
    }
  }
```