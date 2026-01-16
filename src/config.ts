import dotenv from 'dotenv';

dotenv.config();

export const config = {
  port: process.env.PORT || 3000,
  mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/job-applications',
  nodeEnv: process.env.NODE_ENV || 'development',
  uploadDir: process.env.UPLOAD_DIR || 'uploads',
};
