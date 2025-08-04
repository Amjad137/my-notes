To fix this type of issue we will have to edit the .bashrc file which lies on "\\wsl.localhost\Ubuntu-20.04\mnt\wslg\distro\home\amjadh"
open the file using a notepad and add the line as follows at last:

export PATH=$PATH:/usr/local/bin
nvm use |version|  (eg: nvm use 18.20.3)

So in this way we give a solution to the wsl which is confused on using which version of nodejs.
But we have to ensure the following line exist in the .bashrc file:

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

Finally we will have to delete node_modules, all the temporary and build files and reinstall and build the project.


