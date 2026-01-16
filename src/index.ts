import express from 'express';
import cors from 'cors';
import { config } from './config';
import { connectDB } from './database';
import applicationRoutes from './routes/applications';

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api', applicationRoutes);

// Health check endpoint
app.get('/health', (_req, res) => {
  res.json({ status: 'OK', message: 'Server is running' });
});

// Root endpoint
app.get('/', (_req, res) => {
  res.json({
    message: 'Job Application API',
    version: '1.0.0',
    endpoints: {
      health: 'GET /health',
      applications: {
        create: 'POST /api/applications (multipart form-data)',
        list: 'GET /api/applications',
        getOne: 'GET /api/applications/:id',
        downloadResume: 'GET /api/applications/:id/resume',
        update: 'PUT /api/applications/:id (multipart form-data)',
        delete: 'DELETE /api/applications/:id',
      },
    },
  });
});

// Error handling middleware
app.use((_err: any, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
  console.error(_err);
  res.status(500).json({ error: 'Internal server error' });
});

// Start server
const startServer = async () => {
  try {
    console.log('🚀 Starting Job Application API...');
    console.log(`📝 Environment: ${config.nodeEnv}`);
    console.log(`📍 Port: ${config.port}`);

    // Connect to database with timeout
    await connectDB();

    const server = app.listen(config.port, () => {
      console.log(`✅ Server running on http://localhost:${config.port}`);
      console.log(`🏥 Health check: http://localhost:${config.port}/health`);
    });

    // Graceful shutdown
    process.on('SIGTERM', async () => {
      console.log('\n📴 Shutting down gracefully...');
      server.close(() => {
        console.log('✓ Server closed');
        process.exit(0);
      });
    });

  } catch (error) {
    console.error('❌ Failed to start server:', error);
    console.error('ℹ️ The server will still try to run without database');
    // Don't exit - let it continue
    const server = app.listen(config.port, () => {
      console.log(`✅ Server running (without database) on http://localhost:${config.port}`);
    });
  }
};

startServer();

export default app;
