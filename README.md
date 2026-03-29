# Moolah Minds - Financial Literacy Simulator

![Status](https://img.shields.io/badge/status-in--development-yellow)
![License](https://img.shields.io/badge/license-MIT-blue)

A gamified financial literacy web application where players simulate financial decisions from age 22 to 60 in a time-compressed format.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- npm 9+
- Docker & Docker Compose (for database)

### Setup

1. **Clone and install**
```bash
npm install
```

2. **Configure environment**
```bash
cp .env.example .env.local
```
Edit `.env.local` with your settings.

3. **Start database**
```bash
docker-compose up -d
```

4. **Setup database**
```bash
npm run db:migrate:dev
npm run db:seed
```

5. **Run development**
```bash
npm run dev
```

This starts:
- Backend: http://localhost:3000
- Frontend: http://localhost:5173

## 📁 Project Structure

```
moolah-minds/
├── apps/
│   ├── backend/          # Express.js REST API
│   │   └── src/
│   │       ├── server.ts
│   │       ├── routes/   # API endpoints
│   │       ├── services/ # Business logic
│   │       └── db/       # Database layer
│   └── frontend/         # React 18 + Vite
│       └── src/
│           ├── App.tsx
│           ├── pages/
│           ├── components/
│           └── hooks/
├── packages/
│   └── shared/           # Shared types & utilities
└── prisma/
    └── schema.prisma     # Database schema
```

## 🎮 Core Features

- **Time-compressed gameplay**: 1 real week = 1 game month over 38 years
- **Financial decisions**: Spending, investing, career, self-care
- **Metrics tracking**: Net worth, credit score, social status, well-being
- **Career progression**: 4 paths with automatic advancement
- **Random events**: Probabilistic life events affecting gameplay
- **Cohort system**: Rolling weekly game groups with shared conditions
- **Leaderboards**: Cohort-based rankings

## 🛠 Tech Stack

- **Backend**: Express.js + TypeScript + Prisma ORM
- **Frontend**: React 18 + TypeScript + Vite
- **Database**: PostgreSQL with SCD Type 2 for historical tracking
- **Tools**: Turbo, ESLint, Prettier, Jest, Vitest
- **Deployment**: Docker + Managed PostgreSQL

