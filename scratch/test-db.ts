import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function testConnection() {
  try {
    console.log('⏳ Connecting to database...');
    await prisma.$connect();
    console.log('✅ Successfully connected to the database!');
    
    const userCount = await prisma.user.count();
    console.log(`📊 Current user count: ${userCount}`);
    
    console.log('🚀 Database is working perfectly.');
  } catch (error) {
    console.error('❌ Database connection failed!');
    console.error(error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

testConnection();
