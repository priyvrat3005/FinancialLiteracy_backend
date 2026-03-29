# Quick Reference

Fast lookup for common tasks and commands for Moolah Minds development.

## Quick Start (5 minutes)

```bash
# 1. Install dependencies
npm install

# 2. Configure database
cp .env.example .env.local

# 3. Start PostgreSQL
docker-compose up -d

# 4. Initialize database
npm run db:migrate:dev

# 5. Run development servers
npm run dev
```

Open http://localhost:5173 (frontend)

## Common Commands

```bash
# Development
npm run dev                    # Both apps with hot reload
npm run dev -- --filter=backend
npm run dev -- --filter=frontend

# Building & Testing
npm run build                  # Build all
npm run test                   # Run tests
npm run lint                   # Lint all
npm run format                 # Format all
npm run type-check             # Type checking

# Database
npm run db:migrate:dev         # Create migration
npm run db:migrate:deploy      # Apply in production
npm run db:seed                # Seed data
npm run db:studio              # GUI at localhost:5555

# Debugging
npm run db:studio              # Browse database
npx prisma generate           # Regenerate types if broken
```

## Project Navigation

| Path | Purpose |
|------|---------|
| `apps/backend/src/` | Express API code |
| `apps/frontend/src/` | React app code |
| `packages/shared/src/` | Shared TypeScript types |
| `prisma/schema.prisma` | Database schema |
| `prisma/seed.ts` | Initial data |
| `docs/` | Documentation |
| `docker-compose.yml` | PostgreSQL container config |

## API Endpoints (Current)

| Method | Path | Status |
|--------|------|--------|
| GET | `/health` | ✅ Working |
| GET | `/api` | ✅ Working |
| POST | `/api/auth/register` | 🚧 To build |
| POST | `/api/auth/login` | 🚧 To build |
| GET | `/api/profiles` | 🚧 To build |
| POST | `/api/profiles` | 🚧 To build |
| POST | `/api/profiles/:id/tick` | 🚧 To build |

## Frontend Pages (Current)

| Route | Component | Status |
|-------|-----------|--------|
| `/` | Home/Dashboard | 🚧 To build |
| `/login` | Login | 🚧 To build |
| `/game` | Game | 🚧 To build |
| `/leaderboard` | Leaderboard | 🚧 To build |

## Troubleshooting

### "Cannot find module" errors
```bash
npx prisma generate
```

### Database connection failed
```bash
docker ps
docker logs moolah_minds_db
docker-compose restart postgres
```

### Port already in use
```bash
# macOS/Linux
lsof -i :3000
kill -9 <PID>

# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### TypeScript errors not going away
```bash
npm run type-check
```

## File Templates

### New Service (Business Logic)

```typescript
// apps/backend/src/services/YourService.ts
export class YourService {
  async doSomething(): Promise<void> {
    // Logic here
  }
}
```

### New Route

```typescript
// apps/backend/src/routes/your-routes.ts
import { Router } from 'express';
import { asyncHandler } from '@backend/middleware/error';

const router = Router();

router.get('/', asyncHandler(async (req, res) => {
  res.json({ message: 'Your response' });
}));

export default router;
```

### New Component (React)

```typescript
// apps/frontend/src/components/YourComponent.tsx
import React from 'react';

interface Props {
  title: string;
}

export const YourComponent: React.FC<Props> = ({ title }) => {
  return <div>{title}</div>;
};
```

## Environment Variables

Key variables in `.env.local`:

```env
DATABASE_URL              # PostgreSQL connection string
NODE_ENV                  # development | production
PORT                      # Backend port (default: 3000)
JWT_SECRET                # Secret for signing JWTs
VITE_API_BASE_URL         # Frontend API URL
```

## Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature

# Make changes, commit
git add .
git commit -m "feat: description"

# Push and create PR
git push origin feature/your-feature
```

Commit types: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`

## Key Architecture Files

- [docs/SETUP.md](./docs/SETUP.md) - Setup instructions
- [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) - System design
- [CONTRIBUTING.md](./CONTRIBUTING.md) - Development guidelines
- [prisma/schema.prisma](./prisma/schema.prisma) - Database
- [turbo.json](./turbo.json) - Monorepo configuration

## Learning Resources

- **TypeScript**: https://www.typescriptlang.org/docs/
- **Express.js**: https://expressjs.com/
- **React**: https://react.dev/
- **Prisma**: https://www.prisma.io/docs/
- **PostgreSQL**: https://www.postgresql.org/docs/
- **Vite**: https://vitejs.dev/

## Getting Help

1. Check documentation in `docs/`
2. Look at existing code patterns
3. Read CONTRIBUTING.md
4. Create a GitHub issue
5. Ask in pull request comments
