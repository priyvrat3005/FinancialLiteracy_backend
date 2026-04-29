-- CreateEnum
CREATE TYPE "CohortDifficulty" AS ENUM ('BEGINNER', 'STANDARD', 'HARD');

-- CreateEnum
CREATE TYPE "CohortStatus" AS ENUM ('ACTIVE', 'CLOSED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "CareerPath" AS ENUM ('TECH', 'FINANCE', 'CREATIVE', 'HEALTHCARE');

-- CreateEnum
CREATE TYPE "GameStatus" AS ENUM ('ACTIVE', 'BANKRUPT', 'RETIRED');

-- CreateEnum
CREATE TYPE "BalanceType" AS ENUM ('CASH', 'SAVINGS_ACCOUNT', 'FIXED_DEPOSIT', 'MUTUAL_FUND_EQUITY', 'MUTUAL_FUND_DEBT', 'STOCKS_LARGE_CAP', 'STOCKS_MID_CAP', 'REAL_ESTATE', 'GOLD', 'DEBT_CREDIT_CARD', 'DEBT_PERSONAL_LOAN', 'DEBT_EDUCATION_LOAN', 'DEBT_HOME_LOAN');

-- CreateEnum
CREATE TYPE "DecisionType" AS ENUM ('CONSUMPTION', 'INVESTMENT', 'SELF_INVESTMENT', 'OBLIGATION_PAYMENT', 'EMERGENCY_FUND');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('SALARY_CREDIT', 'PROMOTION', 'JOB_LOSS', 'SALARY_FREEZE', 'MARKET_CRASH', 'MARKET_BOOM', 'INFLATION_SPIKE', 'ILLNESS', 'MEDICAL_EMERGENCY', 'PEER_PRESSURE_PURCHASE', 'WINDFALL_INHERITANCE', 'DECISION_EXECUTED', 'OBLIGATION_PAID');

-- CreateEnum
CREATE TYPE "EventCategory" AS ENUM ('CAREER', 'HEALTH', 'MARKET', 'SOCIAL', 'SYSTEM');

-- CreateEnum
CREATE TYPE "EventSeverity" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "PromotionType" AS ENUM ('REGULAR', 'MERIT_BASED', 'SELF_INVESTMENT_BOOST');

-- CreateEnum
CREATE TYPE "ObligationType" AS ENUM ('RENT', 'EMI', 'INSURANCE_HEALTH', 'INSURANCE_LIFE', 'SUBSCRIPTION');

-- CreateEnum
CREATE TYPE "ObligationStatus" AS ENUM ('ACTIVE', 'PAID_OFF', 'DEFAULTED');

-- CreateEnum
CREATE TYPE "ProductCategory" AS ENUM ('FD', 'MF_EQUITY', 'MF_DEBT', 'STOCKS', 'REAL_ESTATE', 'GOLD');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('BUY', 'SELL', 'DIVIDEND', 'INTEREST');

-- CreateEnum
CREATE TYPE "SelfInvestmentType" AS ENUM ('COURSE', 'BOOK', 'CERTIFICATION', 'WORKSHOP');

-- CreateEnum
CREATE TYPE "SelfInvestmentStatus" AS ENUM ('IN_PROGRESS', 'COMPLETED', 'ABANDONED');

-- CreateEnum
CREATE TYPE "ItemCategory" AS ENUM ('ELECTRONICS', 'VEHICLE', 'VACATION', 'FASHION', 'DINING');

-- CreateEnum
CREATE TYPE "AuditAction" AS ENUM ('INSERT', 'UPDATE', 'DELETE');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "passwordHash" VARCHAR(255) NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "lastLoginAt" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cohorts" (
    "id" UUID NOT NULL,
    "startWeek" DATE NOT NULL,
    "difficulty" "CohortDifficulty" NOT NULL,
    "macroConditions" JSONB NOT NULL,
    "status" "CohortStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cohorts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profiles" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "cohortId" UUID NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "careerPath" "CareerPath" NOT NULL,
    "currentWeek" INTEGER NOT NULL DEFAULT 0,
    "gameStatus" "GameStatus" NOT NULL,
    "netWorth" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "creditScore" INTEGER NOT NULL DEFAULT 650,
    "socialStatus" INTEGER NOT NULL DEFAULT 50,
    "wellBeing" INTEGER NOT NULL DEFAULT 70,
    "careerLevel" INTEGER NOT NULL DEFAULT 1,
    "baseSalary" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "skillPoints" INTEGER NOT NULL DEFAULT 0,
    "bankruptcyWeek" INTEGER,
    "retirementWeek" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "profiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "balances" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "balanceType" "BalanceType" NOT NULL,
    "amount" DECIMAL(15,2) NOT NULL,
    "costBasis" DECIMAL(15,2),
    "metadata" JSONB NOT NULL,
    "validFromWeek" INTEGER NOT NULL,
    "validUntilWeek" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "balances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "decisions" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "week" INTEGER NOT NULL,
    "decisionType" "DecisionType" NOT NULL,
    "amount" DECIMAL(15,2) NOT NULL,
    "target" VARCHAR(255) NOT NULL,
    "targetDetails" JSONB NOT NULL,
    "expectedOutcome" JSONB NOT NULL,
    "actualOutcome" JSONB,
    "executedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sequenceOrder" INTEGER NOT NULL,

    CONSTRAINT "decisions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_events" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "week" INTEGER NOT NULL,
    "eventType" "EventType" NOT NULL,
    "eventCategory" "EventCategory" NOT NULL,
    "severity" "EventSeverity" NOT NULL,
    "description" VARCHAR(1023) NOT NULL,
    "impactSnapshot" JSONB NOT NULL,
    "decisionsSnapshot" JSONB NOT NULL,
    "randomSeedUsed" VARCHAR(64) NOT NULL,
    "probabilityRolled" DECIMAL(5,4) NOT NULL,
    "probabilityThreshold" DECIMAL(5,4) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "career_progression" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "decisionId" UUID,
    "week" INTEGER NOT NULL,
    "previousLevel" INTEGER NOT NULL,
    "newLevel" INTEGER NOT NULL,
    "previousSalary" DECIMAL(12,2) NOT NULL,
    "newSalary" DECIMAL(12,2) NOT NULL,
    "promotionType" "PromotionType" NOT NULL,
    "wellBeingFactor" DECIMAL(3,2) NOT NULL,

    CONSTRAINT "career_progression_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "obligations" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "decisionId" UUID,
    "obligationType" "ObligationType" NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "totalAmount" DECIMAL(15,2) NOT NULL,
    "currentBalance" DECIMAL(15,2) NOT NULL,
    "weeklyPayment" DECIMAL(12,2) NOT NULL,
    "interestRate" DECIMAL(5,4),
    "startedWeek" INTEGER NOT NULL,
    "remainingWeeks" INTEGER,
    "status" "ObligationStatus" NOT NULL,

    CONSTRAINT "obligations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "investment_holdings" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "productCode" VARCHAR(100) NOT NULL,
    "productCategory" "ProductCategory" NOT NULL,
    "units" DECIMAL(15,6) NOT NULL,
    "averageCostBasis" DECIMAL(15,4) NOT NULL,
    "currentNAV" DECIMAL(15,4) NOT NULL,
    "totalInvested" DECIMAL(15,2) NOT NULL,
    "currentValue" DECIMAL(15,2) NOT NULL,
    "unrealizedPnL" DECIMAL(15,2) NOT NULL,
    "startedWeek" INTEGER NOT NULL,
    "lastValuationWeek" INTEGER NOT NULL,
    "metadata" JSONB NOT NULL,

    CONSTRAINT "investment_holdings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "investment_transactions" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "holdingId" UUID NOT NULL,
    "decisionId" UUID,
    "week" INTEGER NOT NULL,
    "transactionType" "TransactionType" NOT NULL,
    "units" DECIMAL(15,6) NOT NULL,
    "pricePerUnit" DECIMAL(15,4) NOT NULL,
    "totalAmount" DECIMAL(15,2) NOT NULL,
    "fees" DECIMAL(12,2) NOT NULL,
    "taxes" DECIMAL(12,2) NOT NULL,
    "marketConditions" JSONB NOT NULL,

    CONSTRAINT "investment_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "self_investments" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "decisionId" UUID NOT NULL,
    "investmentType" "SelfInvestmentType" NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "cost" DECIMAL(12,2) NOT NULL,
    "purchasedWeek" INTEGER NOT NULL,
    "completionWeek" INTEGER,
    "careerBoostExpected" INTEGER NOT NULL,
    "careerBoostActual" INTEGER,
    "wellBeingImpact" INTEGER NOT NULL,
    "status" "SelfInvestmentStatus" NOT NULL,

    CONSTRAINT "self_investments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "consumption_items" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "decisionId" UUID NOT NULL,
    "itemCategory" "ItemCategory" NOT NULL,
    "itemName" VARCHAR(255) NOT NULL,
    "cost" DECIMAL(12,2) NOT NULL,
    "purchasedWeek" INTEGER NOT NULL,
    "socialStatusBoost" INTEGER NOT NULL,
    "wellBeingBoost" INTEGER NOT NULL,
    "depreciationModel" JSONB NOT NULL,

    CONSTRAINT "consumption_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "weekly_summaries" (
    "id" UUID NOT NULL,
    "profileId" UUID NOT NULL,
    "week" INTEGER NOT NULL,
    "openingMetrics" JSONB NOT NULL,
    "closingMetrics" JSONB NOT NULL,
    "decisionsMade" INTEGER NOT NULL,
    "eventsOccurred" INTEGER NOT NULL,
    "salaryCredited" DECIMAL(12,2) NOT NULL,
    "obligationsPaid" DECIMAL(15,2) NOT NULL,
    "discretionarySpent" DECIMAL(15,2) NOT NULL,
    "investmentChange" DECIMAL(15,2) NOT NULL,
    "keyHighlights" JSONB NOT NULL,
    "causalExplanation" VARCHAR(1023) NOT NULL,

    CONSTRAINT "weekly_summaries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaderboard_snapshots" (
    "id" UUID NOT NULL,
    "cohortId" UUID NOT NULL,
    "week" INTEGER NOT NULL,
    "profileId" UUID NOT NULL,
    "rank" INTEGER NOT NULL,
    "netWorth" DECIMAL(15,2) NOT NULL,
    "creditScore" INTEGER NOT NULL,
    "weeksSurvived" INTEGER NOT NULL,
    "isBankrupt" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "leaderboard_snapshots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_log" (
    "id" BIGSERIAL NOT NULL,
    "tableName" VARCHAR(100) NOT NULL,
    "recordId" UUID NOT NULL,
    "action" "AuditAction" NOT NULL,
    "oldData" JSONB,
    "newData" JSONB,
    "changedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "changedBy" UUID,
    "sessionId" VARCHAR(100) NOT NULL,

    CONSTRAINT "audit_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_createdAt_idx" ON "users"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "cohorts_startWeek_key" ON "cohorts"("startWeek");

-- CreateIndex
CREATE INDEX "cohorts_startWeek_idx" ON "cohorts"("startWeek");

-- CreateIndex
CREATE INDEX "cohorts_difficulty_status_idx" ON "cohorts"("difficulty", "status");

-- CreateIndex
CREATE INDEX "profiles_userId_idx" ON "profiles"("userId");

-- CreateIndex
CREATE INDEX "profiles_cohortId_idx" ON "profiles"("cohortId");

-- CreateIndex
CREATE INDEX "profiles_cohortId_netWorth_idx" ON "profiles"("cohortId", "netWorth");

-- CreateIndex
CREATE UNIQUE INDEX "profiles_userId_cohortId_key" ON "profiles"("userId", "cohortId");

-- CreateIndex
CREATE INDEX "balances_profileId_balanceType_validUntilWeek_idx" ON "balances"("profileId", "balanceType", "validUntilWeek");

-- CreateIndex
CREATE INDEX "balances_profileId_validFromWeek_idx" ON "balances"("profileId", "validFromWeek");

-- CreateIndex
CREATE INDEX "decisions_profileId_week_idx" ON "decisions"("profileId", "week");

-- CreateIndex
CREATE INDEX "decisions_profileId_decisionType_idx" ON "decisions"("profileId", "decisionType");

-- CreateIndex
CREATE INDEX "game_events_profileId_week_idx" ON "game_events"("profileId", "week");

-- CreateIndex
CREATE INDEX "game_events_profileId_eventCategory_idx" ON "game_events"("profileId", "eventCategory");

-- CreateIndex
CREATE INDEX "game_events_eventType_week_idx" ON "game_events"("eventType", "week");

-- CreateIndex
CREATE INDEX "career_progression_profileId_week_idx" ON "career_progression"("profileId", "week");

-- CreateIndex
CREATE INDEX "obligations_profileId_status_idx" ON "obligations"("profileId", "status");

-- CreateIndex
CREATE INDEX "obligations_profileId_obligationType_idx" ON "obligations"("profileId", "obligationType");

-- CreateIndex
CREATE INDEX "investment_holdings_profileId_productCategory_idx" ON "investment_holdings"("profileId", "productCategory");

-- CreateIndex
CREATE INDEX "investment_holdings_profileId_productCode_idx" ON "investment_holdings"("profileId", "productCode");

-- CreateIndex
CREATE INDEX "investment_transactions_profileId_week_idx" ON "investment_transactions"("profileId", "week");

-- CreateIndex
CREATE INDEX "investment_transactions_holdingId_idx" ON "investment_transactions"("holdingId");

-- CreateIndex
CREATE UNIQUE INDEX "self_investments_decisionId_key" ON "self_investments"("decisionId");

-- CreateIndex
CREATE INDEX "self_investments_profileId_status_idx" ON "self_investments"("profileId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "consumption_items_decisionId_key" ON "consumption_items"("decisionId");

-- CreateIndex
CREATE INDEX "consumption_items_profileId_itemCategory_idx" ON "consumption_items"("profileId", "itemCategory");

-- CreateIndex
CREATE INDEX "weekly_summaries_profileId_idx" ON "weekly_summaries"("profileId");

-- CreateIndex
CREATE UNIQUE INDEX "weekly_summaries_profileId_week_key" ON "weekly_summaries"("profileId", "week");

-- CreateIndex
CREATE INDEX "leaderboard_snapshots_cohortId_week_rank_idx" ON "leaderboard_snapshots"("cohortId", "week", "rank");

-- CreateIndex
CREATE INDEX "leaderboard_snapshots_profileId_idx" ON "leaderboard_snapshots"("profileId");

-- CreateIndex
CREATE INDEX "audit_log_tableName_recordId_idx" ON "audit_log"("tableName", "recordId");

-- CreateIndex
CREATE INDEX "audit_log_changedAt_idx" ON "audit_log"("changedAt");

-- AddForeignKey
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profiles" ADD CONSTRAINT "profiles_cohortId_fkey" FOREIGN KEY ("cohortId") REFERENCES "cohorts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "balances" ADD CONSTRAINT "balances_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "decisions" ADD CONSTRAINT "decisions_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "decisions" ADD CONSTRAINT "decisions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_events" ADD CONSTRAINT "game_events_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "career_progression" ADD CONSTRAINT "career_progression_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "career_progression" ADD CONSTRAINT "career_progression_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "career_progression" ADD CONSTRAINT "career_progression_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "decisions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "obligations" ADD CONSTRAINT "obligations_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "obligations" ADD CONSTRAINT "obligations_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "decisions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "investment_holdings" ADD CONSTRAINT "investment_holdings_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "investment_transactions" ADD CONSTRAINT "investment_transactions_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "investment_transactions" ADD CONSTRAINT "investment_transactions_holdingId_fkey" FOREIGN KEY ("holdingId") REFERENCES "investment_holdings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "investment_transactions" ADD CONSTRAINT "investment_transactions_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "decisions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "self_investments" ADD CONSTRAINT "self_investments_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "self_investments" ADD CONSTRAINT "self_investments_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "decisions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "consumption_items" ADD CONSTRAINT "consumption_items_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "consumption_items" ADD CONSTRAINT "consumption_items_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES "decisions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "weekly_summaries" ADD CONSTRAINT "weekly_summaries_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaderboard_snapshots" ADD CONSTRAINT "leaderboard_snapshots_cohortId_fkey" FOREIGN KEY ("cohortId") REFERENCES "cohorts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaderboard_snapshots" ADD CONSTRAINT "leaderboard_snapshots_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_log" ADD CONSTRAINT "audit_log_changedBy_fkey" FOREIGN KEY ("changedBy") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
