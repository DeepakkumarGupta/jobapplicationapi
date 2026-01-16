#!/usr/bin/env node

/**
 * Application startup script for Hostinger
 * Ensures TypeScript is compiled before starting the server
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🚀 Starting Job Application API...');

// Check if dist folder exists
const distPath = path.join(__dirname, 'dist');
if (!fs.existsSync(distPath)) {
  console.log('📦 dist/ not found. Building application...');
  try {
    execSync('npm run build', { stdio: 'inherit' });
    console.log('✓ Build successful');
  } catch (error) {
    console.error('✗ Build failed:', error.message);
    process.exit(1);
  }
}

// Check if dist/index.js exists
const indexPath = path.join(distPath, 'index.js');
if (!fs.existsSync(indexPath)) {
  console.error('✗ dist/index.js not found');
  process.exit(1);
}

console.log('✓ TypeScript compilation verified');
console.log('✓ Starting Express server...');

// Start the application
require('./dist/index.js');
