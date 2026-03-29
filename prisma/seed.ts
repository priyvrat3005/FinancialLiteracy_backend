// prisma/seed.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main(): Promise<void> {
  console.log('🌱 Seeding database...');

  // Seed cohorts with macro conditions
  const cohort1 = await prisma.cohort.create({
    data: {
      startWeek: new Date('2024-04-01'),
      difficulty: 'STANDARD',
      macroConditions: {
        marketVolatility: 0.15,
        inflationRate: 0.06,
        jobMarketStrength: 0.8,
      },
      status: 'ACTIVE',
    },
  });

  console.log('✅ Cohort created:', cohort1.id);
  console.log('🌱 Seeding complete!');
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
