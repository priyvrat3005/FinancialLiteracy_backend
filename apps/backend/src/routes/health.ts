import { Router, Request, Response } from 'express';
import { asyncHandler } from '@backend/middleware/error';

const router = Router();

// Health check endpoint
router.get('/health', (_req: Request, res: Response): void => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

export default router;
