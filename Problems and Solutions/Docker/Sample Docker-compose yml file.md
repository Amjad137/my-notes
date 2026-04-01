```yml
version: '3.8'

services:
  # PostgreSQL Database
  db:
    image: postgres:16-alpine
    container_name: docremark-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: Test@123
      POSTGRES_DB: docremark
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Backend API (Hono)
  api:
    build:
      context: .
      dockerfile: apps/api/Dockerfile
    container_name: docremark-api
    restart: unless-stopped
    env_file:
      - .env.local
    environment:
      # Override DATABASE_URL to use Docker network hostname
      DATABASE_URL: "postgresql://postgres:Test@123@db:5432/docremark"
      DIRECT_URL: "postgresql://postgres:Test@123@db:5432/docremark"
      # API runs on port 8000 inside container
      PORT: 8000
    ports:
      - "3001:8000"
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Frontend Web (Next.js)
  web:
    build:
      context: .
      dockerfile: apps/web/Dockerfile
    container_name: docremark-web
    restart: unless-stopped
    env_file:
      - .env.local
    environment:
      # Override DATABASE_URL to use Docker network hostname
      DATABASE_URL: "postgresql://postgres:Test@123@db:5432/docremark"
      DIRECT_URL: "postgresql://postgres:Test@123@db:5432/docremark"
      # Point to API via Docker network
      NEXT_PUBLIC_API_URL: "http://api:8000"
      # Web app base URL
      NEXT_PUBLIC_BASE_URL: "http://localhost:3000"
      # Better Auth callback URL
      BETTER_AUTH_URL: "http://localhost:3000"
    ports:
      - "3000:3000"
    depends_on:
      - api
      - db
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  postgres_data:
    driver: local

```
