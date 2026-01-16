# 🔧 Hostinger Configuration - 403 Error Fix

## Problem: 403 Forbidden Error

Your deployment shows "Completed" but the API is returning **403 Forbidden**. This means:
- ✗ Application isn't starting properly
- ✗ TypeScript isn't being compiled on the server
- ✗ dist/ folder is empty or missing

## Root Cause

Hostinger's deployment process:
1. Clones your GitHub repository
2. Runs `npm install`
3. Runs your build command
4. Runs your start command

**Our fix ensures this happens correctly.**

## Changes Made ✅

### 1. Updated package.json Scripts
```json
"scripts": {
  "postinstall": "npm run build || true",  // NEW: Auto-build after install
  "build": "tsc",
  "start": "node dist/index.js"
}
```

### 2. Created start.js
- Checks if dist/ folder exists
- If missing, compiles TypeScript automatically
- Starts the Express server

### 3. Updated Procfile
```
web: node start.js
```

## How to Fix on Hostinger

### Step 1: Configure Build Settings

In Hostinger Deployments → Settings and redeploy:

1. **Build Output Directory:** `dist`
2. **Root Directory:** `jobapplicationapi-main`
3. **Build Command:** `npm install && npm run build`
4. **Start Command:** `node start.js`

Or use custom settings if available:

| Setting | Value |
|---------|-------|
| Build Command | `npm install && npm run build` |
| Start Command | `node start.js` |
| Node Version | 18.x or later |

### Step 2: Push Latest Changes

```bash
git add .
git commit -m "Fix: Add startup script and postinstall hook for Hostinger"
git push origin main
```

### Step 3: Redeploy on Hostinger

1. Go to **Deployments** page
2. Click **Redeploy** button
3. Wait for build to complete
4. Monitor build logs for:
   - ✅ `npm install` completes
   - ✅ `postinstall` hook runs `tsc`
   - ✅ `dist/` created with compiled files
   - ✅ Start command runs: `node start.js`

## Verify It Works

After redeployment, test:

```bash
# Health check
curl https://jobsapi.clicktrick.in/health

# Should return:
# {"status":"OK","message":"Server is running"}

# Get API info
curl https://jobsapi.clicktrick.in/

# Should return endpoints list
```

## If Still Getting 403

### Check These:

1. **Build logs in Hostinger**
   - Look for compilation errors
   - Check if `dist/` was created

2. **Environment variables set?**
   - Go to Hosting Plan → Environment Variables
   - Ensure `MONGODB_URI` is set
   - Ensure `NODE_ENV` is set to `production`

3. **Port configuration**
   - Hostinger assigns PORT via environment variable
   - Our code reads `process.env.PORT` correctly
   - Default: 3000

4. **MongoDB connection**
   - If db fails, server won't start
   - Check `MONGODB_URI` format
   - Verify MongoDB Atlas IP whitelist

### Common Errors in Build Logs:

| Error | Solution |
|-------|----------|
| `tsc: command not found` | TypeScript not in dependencies (should be fixed) |
| `MONGODB_URI undefined` | Set env var in Hostinger settings |
| `Cannot find module` | Missing packages - check package.json |
| `ENOENT: no such file` | dist/ not being created - check build command |

## File Structure Deployed

Hostinger should deploy:
```
jobapplicationapi/
├── src/                (TypeScript source)
├── dist/               (Compiled JavaScript) ← Created during build
│   ├── index.js
│   ├── config.js
│   ├── database.js
│   ├── models/
│   └── routes/
├── package.json
├── tsconfig.json
├── Procfile            (web: node start.js)
├── start.js           (Startup script)
├── .env.example       (Reference only)
└── README.md
```

## Environment Variables Required

In Hostinger Hosting Plan settings, add:

```
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/job-applications?retryWrites=true&w=majority
NODE_ENV=production
PORT=3000 (optional - Hostinger provides this)
```

## Verification Checklist

- [ ] `package.json` has `postinstall` script
- [ ] `Procfile` contains `web: node start.js`
- [ ] `start.js` exists in root directory
- [ ] TypeScript in `dependencies` (not devDependencies)
- [ ] Changes pushed to GitHub
- [ ] Redeployed on Hostinger
- [ ] Build logs show no errors
- [ ] `dist/` folder created
- [ ] Environment variables set
- [ ] MongoDB connection works

## Next Steps

1. **Push changes:**
   ```bash
   git add package.json Procfile start.js
   git commit -m "Fix: Hostinger deployment configuration"
   git push origin main
   ```

2. **In Hostinger Dashboard:**
   - Go to Deployments
   - Click "Settings and redeploy"
   - Verify build/start commands
   - Click Redeploy

3. **Monitor the build:**
   - Watch build logs
   - Wait for "Deployment completed"
   - Verify no 403 error on root URL

4. **Test the API:**
   ```bash
   curl https://jobsapi.clicktrick.in/health
   ```

---

**Expected outcome:** Your API will be live and responding to requests! 🚀
