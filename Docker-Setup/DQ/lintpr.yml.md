name: 📝 Lint PR title

on:
  pull_request:
    types: [opened, edited, reopened, synchronize]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: 🔖Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: 📦Setup PNPM
        uses: pnpm/action-setup@v4

      - name: 🌳Setup Node
        uses: actions/setup-node@v4
        with:
          node-version-file: package.json
          cache: pnpm

      - name: 🗂️ Get pnpm store directory
        shell: bash
        run: |
          echo "STORE_PATH=$(pnpm store path --silent)" >> $GITHUB_ENV
      - name: 🚀 Cache pnpm packages
        uses: actions/cache@v4
        with:
          path: ~/.pnpm-store
          key: ${{ runner.os }}-pnpm-store-${{ hashFiles('**/pnpm-lock.yaml') }}
          restore-keys: |
            ${{ runner.os }}-pnpm-store-
      - name: 🧾Print versions
        run: |
          git --version
          node --version
          pnpm --version
      - name: 🛠️Install dependencies for prlint
        run: pnpm install @commitlint/config-conventional

      - name: 📝Validate PR title with commitlint
        uses: kevintyj/prlint@v2