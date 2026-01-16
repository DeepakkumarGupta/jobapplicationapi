# Production Build & Deployment Guide

This guide walks through building and deploying the Job Application API to production.

## 📦 Build Process

### Local Build
```bash
# Install dependencies
npm install

# Build TypeScript to JavaScript
npm run build

# Start production server
npm start
```

### Verify Build
```bash
# Check dist folder was created
ls -la dist/

# All these files should exist:
# - dist/index.js
# - dist/config.js
# - dist/database.js
# - dist/models/Application.js
# - dist/routes/applications.js
```

## 🚀 Deployment via GitHub

### Step 1: Push to GitHub
```bash
git add .
git commit -m "Production ready: Job Application API"
git push origin main
```

### Step 2: Select Hosting Platform

#### **Recommended: Railway.app**
1. Go to https://railway.app
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Authorize Railway with GitHub
5. Select your repository
6. Railway auto-detects Node.js
7. Add variables:
   - `MONGODB_URI`: Your MongoDB Atlas connection string
   - `NODE_ENV`: `production`
8. Deploy!

**Railway auto-deploys** on every push to main.

#### **Alternative: Render**
1. Go to https://render.com
2. Create "New Web Service"
3. Connect GitHub repository
4. Build command: `npm run build`
5. Start command: `npm start`
6. Add environment variables
7. Deploy!

#### **Alternative: Heroku**
```bash
heroku login
heroku create your-app-name
heroku config:set MONGODB_URI="..."
git push heroku main
```

### Step 3: Verify Deployment
```bash
# Test health endpoint
curl https://your-app.herokuapp.com/health

# Should return: { "status": "OK", "message": "Server is running" }
```

## 🔐 Environment Variables Setup

### For Railway
Dashboard → Variables:
```
MONGODB_URI = mongodb+srv://user:pass@cluster.mongodb.net/db?retryWrites=true&w=majority
NODE_ENV = production
PORT = 3000
```

### For Render
Settings → Environment:
```
MONGODB_URI = mongodb+srv://user:pass@cluster.mongodb.net/db?retryWrites=true&w=majority
NODE_ENV = production
```

### For Heroku
```bash
heroku config:set MONGODB_URI="..."
heroku config:set NODE_ENV="production"
```

## 🗄️ MongoDB Atlas Setup

1. **Create Free Cluster:**
   - Go to https://www.mongodb.com/cloud/atlas
   - Create account (free)
   - Create M0 cluster (free tier)

2. **Get Connection String:**
   - Cluster → Connect
   - Choose "Connect your application"
   - Copy connection string
   - Replace `<password>` with actual password

3. **Example Connection String:**
   ```
   mongodb+srv://myuser:mypassword@cluster0.xxxxx.mongodb.net/job-applications?retryWrites=true&w=majority
   ```

4. **Network Access:**
   - Go to Network Access
   - Add 0.0.0.0/0 (allow all IPs)
   - Or add specific IP address

## 📋 Pre-Deployment Checklist

- [ ] Repository pushed to GitHub
- [ ] `.env` file NOT committed (check .gitignore)
- [ ] `.env.example` contains all needed variables
- [ ] `npm run build` succeeds locally
- [ ] `npm start` runs without errors locally
- [ ] All endpoints tested locally
- [ ] MongoDB Atlas cluster created
- [ ] MongoDB connection string tested
- [ ] Node.js version is 18+
- [ ] All dependencies in package.json

## 🎯 Deploy Summary

### Quick Deploy to Railway (Easiest)
```bash
# 1. Push to GitHub
git push origin main

# 2. Go to railway.app
# 3. Connect GitHub repo
# 4. Add MONGODB_URI variable
# 5. Railway auto-deploys!
```

### Quick Deploy to Render
```bash
# 1. Push to GitHub
git push origin main

# 2. Go to render.com
# 3. Create Web Service from GitHub
# 4. Build: npm run build
# 5. Start: npm start
# 6. Add environment variables
```

### Quick Deploy to Heroku
```bash
heroku login
heroku create my-app
heroku config:set MONGODB_URI="your_connection_string"
git push heroku main
```

## 📊 Available Scripts for Production

From `package.json`:
```json
{
  "scripts": {
    "build": "tsc",              // Compile TypeScript
    "start": "node dist/index.js", // Start production
    "dev": "ts-node src/index.ts",  // Development
    "watch": "tsc --watch"        // Watch mode
  }
}
```

## 🧪 Test After Deployment

```bash
# Replace with your deployed URL
API_URL="https://your-app-name.herokuapp.com"

# 1. Health check
curl $API_URL/health

# 2. Create application
curl -X POST $API_URL/api/applications \
  -F "name=Test User" \
  -F "email=test@example.com" \
  -F "resume=@resume.pdf"

# 3. Get all applications
curl $API_URL/api/applications
```

## 🐛 Deployment Troubleshooting

### Build Fails
```
Error: npm ERR! code ERESOLVE

Solution:
npm install --legacy-peer-deps
npm run build
```

### MongoDB Connection Error
```
Error: connect ECONNREFUSED

Solution:
1. Check MONGODB_URI is correct
2. Check MongoDB Atlas whitelist includes your IP
3. Verify credentials in connection string
```

### Port Error
```
Error: listen EADDRINUSE: address already in use

Solution:
Platform should use PORT environment variable
Set in deployment dashboard
```

### Application Crashes
```
Solution:
1. Check deployment logs
2. Verify environment variables are set
3. Test locally first
4. Check MongoDB connection
```

## 📈 Monitoring Deployed App

### Check Logs
**Railway:**
```
Dashboard → Deployments → Logs
```

**Render:**
```
Dashboard → Logs
```

**Heroku:**
```bash
heroku logs --tail
```

### Monitor Performance
- Check response times
- Monitor error rates
- Watch database connections
- Track file uploads

## 🔄 Updates & Redeployment

Simple! Just push to main:
```bash
# Make changes
npm run build

# Commit and push
git add .
git commit -m "Feature: Add new endpoint"
git push origin main

# Auto-deploys on Railway/Render
# Or use: git push heroku main (for Heroku)
```

## 💾 Backup Data

### MongoDB Backup
```bash
# Using mongodump
mongodump --uri "mongodb+srv://user:pass@cluster.mongodb.net/job-applications"

# Using MongoDB Atlas backup
Go to: Clusters → Backup → Restore
```

---

**You're ready to deploy!** 🚀
