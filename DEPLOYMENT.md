# Deployment Guide

This guide covers deploying the Job Application API to various production hosting platforms.

## Prerequisites

- GitHub account
- Node.js 18+ project (included)
- MongoDB Atlas account (for cloud database)
- Hosting platform account

## 🚀 GitHub Setup

### 1. Initialize Git Repository
```bash
git init
git add .
git commit -m "Initial commit: Job Application API"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/job-application-api.git
git push -u origin main
```

### 2. Create .gitignore (Already included)
```
.env
node_modules/
dist/
uploads/
*.log
.DS_Store
```

### 3. Verify GitHub Secrets Setup
For deployment platforms that support GitHub integration.

---

## 🏢 Deployment Options

### Option 1: Heroku (Recommended for Beginners)

**Steps:**

1. Install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli
2. Login:
   ```bash
   heroku login
   ```

3. Create app:
   ```bash
   heroku create your-app-name
   ```

4. Add MongoDB Atlas connection:
   ```bash
   heroku config:set MONGODB_URI="mongodb+srv://user:password@cluster.mongodb.net/job-applications?retryWrites=true&w=majority"
   heroku config:set NODE_ENV=production
   ```

5. Deploy:
   ```bash
   git push heroku main
   ```

6. Check logs:
   ```bash
   heroku logs --tail
   ```

**Procfile (automatic, if needed manually):**
```
web: npm start
```

---

### Option 2: Railway (Modern & Easy)

**Steps:**

1. Go to https://railway.app
2. Click "Create Project"
3. Select "Deploy from GitHub repo"
4. Authorize and select your repository
5. Add environment variables:
   - `MONGODB_URI`: Your MongoDB connection string
   - `NODE_ENV`: `production`
   - `PORT`: `3000`
6. Railway auto-detects Node.js and deploys

**Deploy Info:**
- Build command: `npm run build`
- Start command: `npm start`

---

### Option 3: Render (Easy & Affordable)

**Steps:**

1. Go to https://render.com
2. Click "New +" → "Web Service"
3. Connect GitHub account
4. Select your repository
5. Configure:
   - **Name:** job-application-api
   - **Environment:** Node
   - **Build Command:** `npm run build`
   - **Start Command:** `npm start`
6. Add environment variables in dashboard:
   - `MONGODB_URI`
   - `NODE_ENV=production`
7. Click "Deploy"

**Free tier available** but limited.

---

### Option 4: AWS Elastic Beanstalk

**Steps:**

1. Install EB CLI: `pip install awsebcli`
2. Configure AWS credentials
3. Initialize EB:
   ```bash
   eb init -p node.js-18 job-application-api --region us-east-1
   ```
4. Create environment:
   ```bash
   eb create production-env
   ```
5. Set environment variables:
   ```bash
   eb setenv MONGODB_URI="..." NODE_ENV=production
   ```
6. Deploy:
   ```bash
   eb deploy
   ```

**Requires AWS account** with some setup.

---

### Option 5: DigitalOcean App Platform

**Steps:**

1. Go to https://www.digitalocean.com/products/app-platform
2. Click "Create App"
3. Connect GitHub repository
4. Select branch (main)
5. Configure:
   - **Resource type:** Web Service
   - **Build command:** `npm run build`
   - **Run command:** `npm start`
   - **HTTP port:** 3000
6. Add environment variables
7. Deploy

---

### Option 6: Azure App Service

**Steps:**

1. Go to Azure Portal
2. Create "App Service"
3. Select Node.js runtime
4. Connect to GitHub
5. Configure deployment
6. Add Application settings (environment variables)
7. Deploy

---

## 🗄️ MongoDB Atlas Setup (Recommended)

### 1. Create Cluster
- Go to https://www.mongodb.com/cloud/atlas
- Sign up free
- Create new project
- Create M0 (Free) cluster

### 2. Get Connection String
- Click "Connect"
- Select "Connect your application"
- Copy connection string
- Replace `<password>` with your password

### 3. Update .env
```env
MONGODB_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/job-applications?retryWrites=true&w=majority
```

### 4. Network Access
- Go to "Network Access"
- Add IP Address: `0.0.0.0/0` (allow all, or specific IP)

---

## 🔧 Environment Variables for Production

**Required for all platforms:**

```env
# MongoDB
MONGODB_URI=mongodb+srv://user:password@cluster.mongodb.net/db?retryWrites=true&w=majority

# Server
PORT=3000
NODE_ENV=production
```

**Set via platform UI or CLI**

---

## 📋 Pre-Deployment Checklist

- [ ] GitHub repository created and pushed
- [ ] `.env.example` contains all required variables
- [ ] `.gitignore` excludes `.env` (don't commit secrets)
- [ ] MongoDB Atlas cluster created
- [ ] MongoDB connection string tested locally
- [ ] `npm run build` compiles without errors
- [ ] `npm start` runs successfully
- [ ] All endpoints tested locally
- [ ] `uploads/` directory exists (create if needed)

---

## 🧪 Testing After Deployment

After deployment, test endpoints:

```bash
# Health check
curl https://your-deployed-app.com/health

# Create application
curl -X POST https://your-deployed-app.com/api/applications \
  -F "name=Test User" \
  -F "email=test@example.com" \
  -F "resume=@resume.pdf"

# Get all applications
curl https://your-deployed-app.com/api/applications
```

---

## 🐛 Troubleshooting

### Build Fails
- Verify Node.js version matches package.json
- Check for `npm install` errors
- Ensure all dependencies are listed in package.json

### MongoDB Connection Error
- Verify connection string is correct
- Check MongoDB Atlas network access whitelist
- Ensure credentials are correct

### Port Issues
- Make sure platform uses PORT environment variable
- Default should be 3000

### File Upload Issues
- Verify `uploads/` directory exists
- Check file permissions
- Ensure Multer field name is correct

### Application Crashes
- Check deployment logs
- Verify environment variables are set
- Check MongoDB connection

---

## 🚀 Quick Deploy Examples

### Deploy to Heroku
```bash
heroku login
heroku create my-app
heroku config:set MONGODB_URI="..."
git push heroku main
```

### Deploy to Railway
1. Connect GitHub repo
2. Railway auto-detects and deploys
3. Add environment variables in dashboard

### Deploy to Render
1. Create web service from GitHub
2. Set build and start commands
3. Add environment variables
4. Deploy

---

## 📈 Performance Tips

- Use MongoDB Atlas for better performance
- Enable connection pooling
- Add indexes on frequently queried fields
- Monitor application logs
- Use CDN for static files if needed
- Set up uptime monitoring

---

## 🔐 Security Checklist

- [ ] `.env` not committed to Git
- [ ] MongoDB password is strong
- [ ] MongoDB Atlas IP whitelist configured
- [ ] HTTPS enabled on hosting platform
- [ ] CORS configured correctly
- [ ] Input validation active
- [ ] Error messages don't expose sensitive info
- [ ] File uploads restricted to PDF only

---

## 🔄 Continuous Deployment

Most platforms auto-deploy when you push to main branch:

```bash
# Make changes
git add .
git commit -m "Update feature"
git push origin main

# Automatic deployment starts
```

---

## 📊 Monitoring & Logging

### Heroku
```bash
heroku logs --tail
```

### Railway
Dashboard → Logs

### Render
Dashboard → Logs

### AWS
CloudWatch Logs

---

## 💰 Cost Estimation

| Platform | Free Tier | Paid Starting |
|----------|-----------|---------------|
| Heroku | No | $7/month |
| Railway | $5 credit/month | $5/month |
| Render | Limited | $7/month |
| AWS | 12 months free | Variable |
| DigitalOcean | No | $5/month |

**MongoDB Atlas:** Free tier available (512MB storage)

---

## 🆘 Support

For deployment issues:
1. Check platform documentation
2. Review application logs
3. Verify environment variables
4. Test locally first
5. Check GitHub issues/discussions

---

**Ready to deploy!** 🚀
