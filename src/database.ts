import mongoose from 'mongoose';
import { config } from './config';

let isConnected = false;

export const connectDB = async (): Promise<void> => {
  if (isConnected) return;

  try {
    console.log('🔄 Connecting to MongoDB...');
    console.log(`📍 URI: ${config.mongodbUri.split('@')[0]}@...`);

    const conn = await mongoose.connect(config.mongodbUri, {
      serverSelectionTimeoutMS: 5000, // 5 second timeout
      connectTimeoutMS: 10000,
      socketTimeoutMS: 45000,
      family: 4, // Use IPv4
      retryWrites: true,
    });

    isConnected = true;
    console.log(`✓ MongoDB connected: ${conn.connection.host}`);
  } catch (error: any) {
    console.error('⚠️ MongoDB connection failed:', error.message);
    console.error('ℹ️ Running in limited mode without database persistence');
    // Don't exit - allow server to run without DB for testing
    isConnected = false;
  }
};

export const disconnectDB = async (): Promise<void> => {
  try {
    await mongoose.disconnect();
    isConnected = false;
    console.log('✓ MongoDB disconnected');
  } catch (error) {
    console.error('✗ MongoDB disconnection failed:', error);
  }
};

export const isDBConnected = (): boolean => isConnected;
