# 🚀 GitHub & Deployment Setup Guide

Simple guide to push your project to GitHub and deploy to hosting platforms.

## 📝 Step 1: Initialize Git Locally

```bash
cd job-application-api

# Initialize git (if not already done)
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: Job Application API"

# Rename branch to main (if needed)
git branch -M main
```

## 🐙 Step 2: Create GitHub Repository

1. Go to https://github.com/new
2. Enter repository name: `job-application-api`
3. Choose "Public" or "Private"
4. Do NOT initialize with README (already have one)
5. Click "Create repository"

## 🔗 Step 3: Connect to GitHub

Copy the commands from GitHub and run them:

```bash
git remote add origin https://github.com/YOUR_USERNAME/job-application-api.git
git branch -M main
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

## ✅ Verify GitHub Connection

```bash
git remote -v

# Should show:
# origin  https://github.com/YOUR_USERNAME/job-application-api.git (fetch)
# origin  https://github.com/YOUR_USERNAME/job-application-api.git (push)
```

## 📤 Future Updates

After making changes:

```bash
# Stage changes
git add .

# Commit
git commit -m "Description of changes"

# Push to GitHub
git push origin main
```

## 🚀 Deploy to Hosting

### Option 1: Railway (Easiest - Recommended)

1. Go to https://railway.app
2. Sign in with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Authorize and select your repository
6. Railway auto-detects Node.js
7. Add environment variables:
   - `MONGODB_URI`: Your MongoDB connection string
   - `NODE_ENV`: `production`
8. Click "Deploy"

**That's it!** Railway auto-deploys when you push to GitHub.

### Option 2: Render

1. Go to https://render.com
2. Sign up (with GitHub recommended)
3. Click "New +" → "Web Service"
4. Select "Connect Repository"
5. Select your repository
6. Configure:
   - Name: `job-application-api`
   - Build command: `npm run build`
   - Start command: `npm start`
   - Instance type: Free
7. Add environment variables:
   - `MONGODB_URI`: Your MongoDB connection string
   - `NODE_ENV`: `production`
8. Click "Deploy"

### Option 3: Heroku

1. Create Heroku account at https://heroku.com
2. Install Heroku CLI
3. Login: `heroku login`
4. Create app: `heroku create your-app-name`
5. Set variables:
   ```bash
   heroku config:set MONGODB_URI="your_connection_string"
   heroku config:set NODE_ENV="production"
   ```
6. Deploy: `git push heroku main`

### Option 4: Vercel

1. Go to https://vercel.com
2. Sign in with GitHub
3. Click "New Project"
4. Import repository
5. Add environment variables
6. Click "Deploy"

## 🗄️ MongoDB Atlas Setup

1. Go to https://www.mongodb.com/cloud/atlas
2. Sign up (free tier available)
3. Create new project
4. Create M0 cluster (free)
5. Get connection string:
   - Cluster → Connect
   - Choose "Connect your application"
   - Copy connection string
6. Replace `<password>` with your actual password
7. Add to deployment platform environment variables

**Example connection string:**
```
mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/job-applications?retryWrites=true&w=majority
```

## 🧪 Test Your Deployment

After deployment, test the API:

```bash
# Replace with your deployed URL
API_URL="https://your-app-name.herokuapp.com"

# Health check
curl $API_URL/health

# Create application
curl -X POST $API_URL/api/applications \
  -F "name=Test User" \
  -F "email=test@example.com" \
  -F "resume=@resume.pdf"
```

## 📊 Deployment Comparison

| Platform | Free | Setup Time | Auto-Deploy | Best For |
|----------|------|-----------|-------------|----------|
| Railway | Yes ($5 credit) | 5 min | Yes | Beginners |
| Render | Limited | 10 min | Yes | Hobby projects |
| Heroku | No | 10 min | Yes | Production |
| Vercel | Yes | 5 min | Yes | Fullstack |

## 🔒 Security Checklist

- [ ] `.env` file is in `.gitignore`
- [ ] Never commit `.env` to GitHub
- [ ] Use `.env.example` for template
- [ ] All secrets in deployment platform
- [ ] MongoDB Atlas whitelist configured
- [ ] Strong MongoDB password

## 🎯 Quick Deploy Checklist

- [ ] Repository created on GitHub
- [ ] Project pushed to GitHub
- [ ] MongoDB Atlas cluster created
- [ ] Connection string obtained
- [ ] Hosting platform selected
- [ ] Repository connected to platform
- [ ] Environment variables set
- [ ] Deployment complete
- [ ] API endpoints tested

## 📞 Quick Links

- **Railway:** https://railway.app
- **Render:** https://render.com
- **Heroku:** https://heroku.com
- **Vercel:** https://vercel.com
- **MongoDB Atlas:** https://www.mongodb.com/cloud/atlas
- **GitHub:** https://github.com

## 🚀 You're Ready!

Your project is now ready for production deployment. Choose your hosting platform and deploy! 🎉
