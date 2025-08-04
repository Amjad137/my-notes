name: 🐋 Build and Push Docker Image to Naver Cloud Registry

on:
  push:
    branches: [main]
  pull_request:
    branches: [main, feat/docker]

env:
  REGISTRY: ${{ secrets.REGISTRY_URL }}
  IMAGE_NAME: dq/next

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
      - name: 🔖Checkout code
        uses: actions/checkout@v4

      - name: 📦Cache pnpm store
        uses: actions/cache@v4
        with:
          path: ~/.pnpm-store
          key: ${{ runner.os }}-pnpm-store-${{ hashFiles('pnpm-lock.yaml') }}
          restore-keys: |
            ${{ runner.os }}-pnpm-store-
      - name: 🔧Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: 🔑Log in to Naver Cloud Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ secrets.NCLOUD_ACCESS_KEY_ID }}
          password: ${{ secrets.NCLOUD_SECRET_ACCESS_KEY }}

      - name: 🏗️Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
          cache-from: type=registry,ref=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache
          cache-to: type=registry,ref=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:buildcache,mode=max
          build-args: |
            DATABASE_URL=${{ secrets.DATABASE_URL }}
            BETTER_AUTH_SECRET=${{ secrets.BETTER_AUTH_SECRET }}
            RESEND_API_KEY=${{ secrets.RESEND_API_KEY }}
            NCLOUD_ACCESS_KEY_ID=${{ secrets.NCLOUD_ACCESS_KEY_ID }}
            NCLOUD_SECRET_ACCESS_KEY=${{ secrets.NCLOUD_SECRET_ACCESS_KEY }}
      - name: 📋Image digest
        run: |
          echo "Image pushed: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest"
          echo "Image digest: ${{ steps.digest.outputs.digest }}"