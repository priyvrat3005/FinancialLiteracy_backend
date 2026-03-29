import { PrismaClient } from '@prisma/client';

let prisma: PrismaClient;

function getPrismaClient(): PrismaClient {
  if (!prisma) {
    prisma = new PrismaClient({
      log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
    });
  }
  return prisma;
}

export function dbClient(): PrismaClient {
  return getPrismaClient();
}

// Graceful shutdown
process.on('SIGINT', async () => {
  await prisma?.$disconnect();
  process.exit(0);
});
