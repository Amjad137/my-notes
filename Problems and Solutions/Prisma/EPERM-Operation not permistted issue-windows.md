This is the same Windows file locking issue with Prisma. You need to kill all Node processes before running the dev server: 

```Bash
taskkill //F //IM node.exe
```
