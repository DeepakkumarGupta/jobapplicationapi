import mongoose from 'mongoose';
import { config } from './config';

export const connectDB = async (): Promise<void> => {
  try {
    const conn = await mongoose.connect(config.mongodbUri);
    console.log(`✓ MongoDB connected: ${conn.connection.host}`);
  } catch (error) {
    console.error('✗ MongoDB connection failed:', error);
    process.exit(1);
  }
};

export const disconnectDB = async (): Promise<void> => {
  try {
    await mongoose.disconnect();
    console.log('✓ MongoDB disconnected');
  } catch (error) {
    console.error('✗ MongoDB disconnection failed:', error);
    process.exit(1);
  }
};
