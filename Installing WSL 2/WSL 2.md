Refer:[Install WSL | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/install)


1. search on windows "Turn on/off windows/feature" and click it, a window will open, tick windows subsystem for linux.
2. open terminal with administrator
3. CMD : wsl --install
4.  CMD: wsl --update (otherwise a problem will occur after the installation of ubuntu)
5. CMD: wsl --install -d <choose ubuntu 20.0 version>
6. then if ubuntu is loaded successfully, you will have to give username and password, give the username in small letters


# Install node on wsl

refer: [Set up Node.js on WSL 2 | Microsoft Learn](https://learn.microsoft.com/en-us/windows/dev-environment/javascript/nodejs-on-wsl)

# Configure git
after installing git on windows open wsl terminal  (ubuntu),

terminal : "git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe""
