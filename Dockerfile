# Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Copy monorepo files
COPY package*.json ./
COPY tsconfig.json ./
COPY .prettierrc ./
COPY .eslintrc.json ./
COPY turbo.json ./

# Copy app and package files
COPY apps ./apps
COPY packages ./packages
COPY prisma ./prisma

# Install dependencies
RUN npm ci

# Build
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app

ENV NODE_ENV=production

# Copy package files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/turbo.json ./
COPY --from=builder /app/prisma ./prisma

# Copy built apps
COPY --from=builder /app/apps/backend/dist ./apps/backend/dist
COPY --from=builder /app/node_modules ./node_modules

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {if (r.statusCode !== 200) throw new Error()})"

# Expose port
EXPOSE 3000

# Start backend
CMD ["node", "apps/backend/dist/server.js"]
