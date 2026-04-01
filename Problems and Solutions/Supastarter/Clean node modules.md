Remove node_modules and lock files

`Bash
rm -rf node_modules
rm -rf apps/*/node_modules
rm -rf packages/*/node_modules
`
`

# Reinstall
pnpm install