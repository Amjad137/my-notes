@echo off
echo Starting git update process...
echo.

echo Adding all changes...
git add .

echo.
echo Committing changes with message "notes updated"...
git commit -m "notes updated"

echo.
echo Pushing to remote repository...
git push

echo.
echo Git update completed!
pause
