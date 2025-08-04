
Step 1: Type cmd in the Search box and choose the first result. Then, click Run as administrator.

Step 2: Once Command Prompt’s window opens you can put the following command and press Enter:

reg add “HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32” /f /ve

Step 3: Restart your computer.

If want to enable the “Show more options” menu in Windows 11, you can enter the following command in Command Prompt and restart your PC.

reg delete “HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}” /f​