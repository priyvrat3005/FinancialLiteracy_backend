# Architecture

Technical architecture and design decisions for Moolah Minds.

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                          Frontend (React)                        │
│                    - Pages, Components, Hooks                    │
│                    - Vite hot-reload development                 │
└────────────────────────────┬────────────────────────────────────┘
                             │ HTTP/REST
                             │ /api prefix
┌────────────────────────────▼────────────────────────────────────┐
│                   Backend (Express.js)                           │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Routes → Middleware → Services → Database Layer          │   │
│  │ - Auth endpoints      - JWT validation                   │   │
│  │ - Game endpoints      - Error handling                   │   │
│  │ - Profile endpoints   - Request logging                  │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │ Prisma ORM
┌────────────────────────────▼────────────────────────────────────┐
│              Database (PostgreSQL)                               │
│  - 15 tables with comprehensive indexing                         │
│  - SCD Type 2 for historical tracking                            │
│  - Event sourcing for audit trails                               │
└─────────────────────────────────────────────────────────────────┘
```

## Backend Architecture

### Layer Structure

```
apps/backend/src/
├── server.ts              # Express app initialization
├── middleware/
│   ├── auth.ts           # JWT verification
│   ├── error.ts          # Error handling & async wrapper
│   └── logging.ts        # Request logging (future)
├── routes/
│   ├── health.ts         # Health checks
│   ├── auth.ts           # Authentication (future)
│   ├── profiles.ts       # Profile management (future)
│   ├── game.ts           # Game engine endpoints (future)
│   └── leaderboard.ts    # Leaderboard ranking (future)
├── services/
│   ├── AuthService.ts    # Authentication logic
│   ├── GameService.ts    # Game logic
│   ├── ProfileService.ts # Profile operations
│   └── index.ts          # Service exports
├── db/
│   ├── client.ts         # Prisma client singleton
│   └── queries/          # Reusable database queries
└── types/
    └── index.ts          # Backend-specific types
```

### Middleware Stack

```
Express App
├── helmet()              # Security headers
├── cors()                # CORS handling
├── express.json()        # Body parsing
├── authMiddleware        # JWT authentication (optional)
├── errorHandler          # Centralized error handling
└── 404 handler           # Not found responses
```

### Error Handling

All errors flow through centralized `errorHandler`:

```typescript
// ApiError for application errors
throw new ApiError(400, 'Invalid input', 'VALIDATION_ERROR');

// Automatic error catching
asyncHandler(async (req, res) => {
  // Errors thrown here are caught and passed to errorHandler
});
```

## Frontend Architecture

```
apps/frontend/src/
├── App.tsx               # Root component
├── main.tsx              # React root
├── index.css             # Global styles
├── pages/                # Page components (future)
│   ├── LoginPage.tsx
│   ├── GamePage.tsx
│   └── LeaderboardPage.tsx
├── components/           # Reusable components (future)
│   ├── Header.tsx
│   ├── GameCard.tsx
│   └── MetricsPanel.tsx
├── hooks/                # Custom React hooks (future)
│   ├── useAuth.ts
│   ├── useGame.ts
│   └── useProfile.ts
├── services/             # API clients (future)
│   └── api.ts            # Axios instance & endpoints
└── types/                # Frontend types
    └── index.ts
```

## Database Architecture

### Tables with Strategic Relationships

**Core Entities:**
- `users` - Authentication
- `cohorts` - Game groups
- `profiles` - Player games
- `balances` - SCD Type 2 history

**Game State:**
- `decisions` - Player choices
- `game_events` - Event sourcing
- `career_progression` - Career history
- `obligations` - Financial commitments

**Investments:**
- `investment_holdings` - Portfolio items
- `investment_transactions` - Buy/sell audit

**Purchases:**
- `self_investments` - Courses, books
- `consumption_items` - Gadgets, vacations

**Analytics:**
- `weekly_summaries` - Dashboard data
- `leaderboard_snapshots` - Ranked data

**Audit:**
- `audit_log` - System audit trail

### Indexing Strategy

```sql
-- Leaderboard queries (high traffic)
profiles.cohortId + netWorth DESC

-- Game tick queries
game_events.profileId + week
balances.profileId + validUntilWeek (where validUntilWeek IS NULL)

-- History queries
balances.profileId + validFromWeek
decisions.profileId + week
```

### Data Flow: Weekly Game Tick

```
1. Fetch current balances (cached with validUntilWeek = NULL)
2. Apply salary credit → Create new balance record
3. Deduct obligations → Update balance
4. Process player decisions → Create decision records
5. Trigger random events → Record in game_events
6. Recalculate metrics → Update profile denormalized cache
7. Generate weekly summary → Create weekly_summary
8. Update leaderboard snapshot → Insert leaderboard_snapshots
```

## Code Patterns

### Service Pattern (Business Logic)

```typescript
// apps/backend/src/services/GameService.ts
export class GameService {
  async advanceWeek(profileId: string): Promise<void> {
    // Complex business logic
    // Multiple database operations
    // Calculations and validations
  }
}

// Use in route
router.post('/profile/:id/tick', asyncHandler(async (req, res) => {
  const service = new GameService();
  await service.advanceWeek(req.params.id);
  res.json({ success: true });
}));
```

### Database Query Pattern

```typescript
// Reusable queries
export async function getActiveProfile(userId: string, cohortId: string) {
  return await dbClient().profile.findUnique({
    where: {
      userId_cohortId: { userId, cohortId },
    },
    include: {
      balances: {
        where: { validUntilWeek: null }, // Current only
      },
    },
  });
}
```

## Performance Considerations

### Caching Strategy

**Denormalized in Profile:**
- `netWorth` - Recalculated on decision/event
- `creditScore` - Updated with obligation payments
- `socialStatus` - Adjusted with consumption
- `wellBeing` - Affected by events

**Materialized Views:**
- `weekly_summaries` - Pre-computed dashboard
- `leaderboard_snapshots` - Weekly rankings

### Query Optimization

1. **SCD Type 2 balances**: Only fetch current records (validUntilWeek IS NULL)
2. **Composite indexes**: profileId + week for event queries
3. **Pagination**: Limit leaderboard queries with LIMIT/OFFSET
4. **Connection pooling**: Prisma handles with connection pool

## Deployment Architecture

```
┌──────────────────────────────────────┐
│      Managed PostgreSQL               │
│      - Automated backups               │
│      - Connection pooling              │
│      - Read replicas (future)         │
└──────────────────────────────────────┘
                    ↑
        ┌───────────┴───────────┐
        │                       │
┌───────▼─────────┐     ┌──────▼──────────┐
│  Backend Pod    │     │  Backend Pod    │
│  (Express API)  │     │  (Express API)  │
│  :3000          │     │  :3000          │
└────────┬────────┘     └────────┬────────┘
         │                        │
         └───────────┬────────────┘
                     │
         ┌───────────▼───────────┐
         │   Load Balancer       │
         │   (Nginx reverse      │
         │    proxy)             │
         └───────────┬───────────┘
                     │
         ┌───────────▼───────────┐
         │   CDN / Static Host   │
         │   (Frontend SPA)      │
         │   (React compiled)    │
         └───────────────────────┘
```

## Future Enhancements

- [ ] WebSocket support for real-time leaderboards
- [ ] Redis caching layer for profiles
- [ ] Read replicas for analytics
- [ ] Event streaming (Kafka/RabbitMQ)
- [ ] GraphQL layer (optional)
- [ ] Microservices decomposition
