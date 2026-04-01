```CMD
for /d /r "D:\Amjath\My Projects\WEB Projects" %i in (.next) do @if exist "%i" rd /s /q "%i"
```