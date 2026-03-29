# Development Setup Guide

Complete instructions for getting Moolah Minds running locally.

## Prerequisites

- **Node.js**: 18.0.0 or higher
- **npm**: 9.0.0 or higher  
- **Docker & Docker Compose**: For PostgreSQL database
- **Git**: Version control (optional but recommended)

## Step 1: Clone Repository

```bash
cd moolah-minds
npm install
```

## Step 2: Environment Setup

Copy the example environment file:

```bash
cp .env.example .env.local
```

Edit `.env.local` with your values:

```env
# Database
DATABASE_URL="postgresql://moolah_user:moolah_password@localhost:5432/moolah_minds"

# Backend
NODE_ENV=development
PORT=3000
JWT_SECRET="your-secret-key-here-change-in-production"

# Frontend
VITE_API_BASE_URL=http://localhost:3000/api
```

## Step 3: Start PostgreSQL

```bash
# Start with Docker Compose
docker-compose up -d

# Verify it's running
docker ps
```

PostgreSQL will be available at `localhost:5432`.

## Step 4: Initialize Database

Run migrations to create tables:

```bash
npm run db:migrate:dev
```

This creates the database schema from `prisma/schema.prisma`.

**Optional: Seed initial data**

```bash
npm run db:seed
```

This creates initial cohorts and macro conditions.

**Optional: Open Prisma Studio**

Visualize your database:

```bash
npm run db:studio
```

Opens http://localhost:5555

## Step 5: Start Development

Run both backend and frontend in development mode:

```bash
npm run dev
```

This starts:
- **Backend API**: http://localhost:3000
  - Health check: http://localhost:3000/health
  - API: http://localhost:3000/api
- **Frontend**: http://localhost:5173
  - Hot reload enabled
  - Proxy to backend at /api

## Step 6: Verify Setup

### Backend Health Check
```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### Frontend
Open browser to http://localhost:5173

## Common Commands

```bash
# Development
npm run dev               # Start both apps
npm run dev -- --filter=backend  # Backend only
npm run dev -- --filter=frontend # Frontend only

# Building
npm run build            # Build all packages
npm run build -- --filter=backend

# Code Quality
npm run lint             # Lint all code
npm run format           # Format all code
npm run type-check       # Check TypeScript types

# Database
npm run db:migrate:dev   # Create new migration
npm run db:migrate:deploy # Apply migrations in production
npm run db:seed          # Seed initial data
npm run db:studio        # Open database UI

# Testing
npm run test             # Run all tests
npm run test -- --watch  # Watch mode
```

## Troubleshooting

### Database Connection Failed
```bash
# Check if Docker container is running
docker ps | grep moolah_minds_db

# View logs
docker logs moolah_minds_db

# Restart
docker-compose restart postgres
```

### Port Already in Use
```bash
# Backend (3000)
lsof -i :3000
kill -9 <PID>

# Frontend (5173)
lsof -i :5173
kill -9 <PID>
```

### Node Modules Issues
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install
```

### Prisma Client Error
```bash
# Regenerate Prisma client
npx prisma generate
```

## Project Structure

```
moolah-minds/
├── apps/
│   ├── backend/
│   │   ├── src/
│   │   │   ├── server.ts        # Entry point
│   │   │   ├── middleware/
│   │   │   ├── routes/
│   │   │   ├── services/
│   │   │   └── db/
│   │   ├── package.json
│   │   └── tsconfig.json
│   └── frontend/
│       ├── src/
│       │   ├── App.tsx
│       │   ├── pages/
│       │   ├── components/
│       │   └── hooks/
│       ├── vite.config.ts
│       └── package.json
├── packages/
│   └── shared/
│       └── src/
│           └── types.ts         # Shared TypeScript types
├── prisma/
│   ├── schema.prisma            # Database schema
│   └── seed.ts                  # Seed data
├── package.json                 # Root workspace
└── README.md
```

## Next Steps

1. Read [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) for system design
2. Check [docs/API.md](../docs/API.md) for API documentation
3. Review [docs/GAME_MECHANICS.md](../docs/GAME_MECHANICS.md) for gameplay

## IDE Setup

### VS Code Extensions (Recommended)
- Prisma (prisma.prisma)
- ES7+ React/Redux snippets
- Thunder Client / REST Client for API testing

### Import Aliases
TypeScript path aliases are pre-configured:
```typescript
import { User } from '@shared/types';  // From packages/shared/src/types.ts
```

## Contributing

Please follow the established patterns:
- TypeScript strict mode enabled
- ESLint/Prettier for code style
- Test critical business logic
- Document complex functions

See [CONTRIBUTING.md](../CONTRIBUTING.md) for details.
