make yarn as the engine

make following changes in the scripts:

	"env:copy:dev": "cp .env.development .env.local",
    "dev": "yarn env:copy:dev && next dev",
    "build": "yarn env:copy:dev && next build",
    "lint:fix": "eslint . --fix",
    "format": "prettier --check .",
	"format:fix": "prettier --write .",

add the following additionally (engine configuration)

	 "engines": {
    "npm": "Unsupported. Use Yarn instead.",
    "yarn": ">= 1.22.00",
    "node": ">= 18.17.0" }