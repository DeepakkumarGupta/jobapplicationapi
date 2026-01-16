# 🔧 Hostinger 503 Service Unavailable - Fix

## Problem: 503 Error (Service Unavailable)

Your API was hanging and timing out with 503 errors. This happened because:
- ❌ MongoDB connection was blocking the server startup
- ❌ Server couldn't start without database connection
- ❌ Hostinger killed the process after timeout

## Root Cause

The application was **waiting indefinitely** for MongoDB to connect before starting the server. If MongoDB Atlas wasn't accessible or MONGODB_URI was missing, the entire server would hang and eventually timeout.

## Solution Implemented ✅

### 1. **Non-blocking Startup**
- Server now starts **even if MongoDB is unavailable**
- Database connection errors are logged but non-fatal
- Added connection timeout: 5 seconds max wait

### 2. **Database Check Middleware**
- Added `checkDB` middleware to all API routes
- Routes check if database is connected before processing
- Return clear error if database isn't available
- Health check endpoint (`/health`) works without database

### 3. **Better Error Messages**
- 503 error with helpful hint if DB is unavailable
- Tells user to set MONGODB_URI environment variable
- Server starts anyway for testing purposes

### 4. **Improved Logging**
- Better startup messages showing what's happening
- Connection status clearly visible
- Port and environment logged at startup

## What Changed

### `src/database.ts`
```typescript
// OLD: Failed with process.exit(1)
// NEW: Logs error but continues
export const connectDB = async (): Promise<void> => {
  try {
    await mongoose.connect(config.mongodbUri, {
      serverSelectionTimeoutMS: 5000,  // Timeout after 5s
      connectTimeoutMS: 10000,
    });
    isConnected = true;
  } catch (error) {
    console.error('⚠️ MongoDB connection failed');
    isConnected = false;  // Server continues running
  }
};
```

### `src/routes/applications.ts`
```typescript
// Added database check middleware
const checkDB = (req: Request, res: Response, next: Function) => {
  if (!isDBConnected()) {
    return res.status(503).json({ 
      error: 'Database connection not available',
      hint: 'Set MONGODB_URI in environment variables'
    });
  }
  next();
};

// Applied to all data routes
router.get('/applications', checkDB, async ...)
router.post('/applications', checkDB, async ...)
```

### `src/index.ts`
```typescript
// Server starts with or without database
const startServer = async () => {
  console.log('🚀 Starting Job Application API...');
  
  await connectDB();  // Try to connect, but don't fail
  
  const server = app.listen(config.port, () => {
    console.log(`✅ Server running on http://localhost:${config.port}`);
  });
};
```

## How to Deploy the Fix

### Step 1: Verify MONGODB_URI is Set

In Hostinger Dashboard:
1. Go to **Hosting Plan → Environment Variables**
2. Check that `MONGODB_URI` is set correctly
3. Format should be: `mongodb+srv://username:password@cluster.mongodb.net/job-applications`

### Step 2: Redeploy

1. Go to **Deployments**
2. Click **Redeploy** button
3. Wait for build (2-5 minutes)
4. Check build logs

### Step 3: Test the API

```bash
# Test 1: Health check (no database needed)
curl https://jobsapi.clicktrick.in/health
# Expected: {"status":"OK","message":"Server is running"}

# Test 2: If database is connected
curl https://jobsapi.clicktrick.in/api/applications
# Expected: {"message":"Applications retrieved successfully","data":[],"count":0}

# Test 3: If database NOT connected
curl https://jobsapi.clicktrick.in/api/applications
# Expected: {"error":"Database connection not available","hint":"Set MONGODB_URI..."}
```

## Deployment Sequence

### Scenario A: MONGODB_URI Set Correctly
1. ✅ Server starts
2. ✅ Connects to MongoDB within 5 seconds
3. ✅ All endpoints work normally
4. ✅ No 503 errors

### Scenario B: MONGODB_URI Missing or Invalid
1. ✅ Server starts anyway
2. ⚠️ Database connection fails (logged)
3. ✅ Health check works
4. ⚠️ Data endpoints return 503 with helpful message
5. ✅ No server crash/timeout

## Expected Behavior After Fix

### Working Endpoints:

```bash
# Always works (no DB needed)
GET /health                    → 200 OK

# Works if DB connected
GET /api/applications          → 200 OK (with data)
POST /api/applications         → 201 Created
GET /api/applications/:id      → 200 OK
GET /api/applications/:id/resume → 200 OK + file
PUT /api/applications/:id      → 200 OK
DELETE /api/applications/:id   → 200 OK

# If DB not connected
GET /api/applications          → 503 Service Unavailable (with hint)
```

## Troubleshooting

### Still Getting 503?

**Check 1: Is MONGODB_URI set?**
```bash
# In Hostinger dashboard, verify environment variable exists
# Format: mongodb+srv://username:password@cluster.mongodb.net/...
```

**Check 2: Is MongoDB Atlas accessible?**
```bash
# In MongoDB Atlas dashboard:
# - Go to Network Access
# - Add Hostinger IP to whitelist
# - Or allow all IPs (0.0.0.0/0) for testing
```

**Check 3: Connection string valid?**
```bash
# Test locally with same connection string
# Replace <password> with actual password
# Remove angle brackets
```

**Check 4: Database cluster running?**
```bash
# In MongoDB Atlas:
# - Go to Deployments
# - Verify cluster status is "Active" (green)
```

## Files Changed

✅ `src/database.ts` - Non-blocking connection, timeouts
✅ `src/index.ts` - Improved startup logging
✅ `src/routes/applications.ts` - Added checkDB middleware
✅ Compiled to `dist/` successfully

## Testing on Hostinger

1. Push code: `git push origin main`
2. Redeploy on Hostinger
3. Wait 2-5 minutes
4. Test: `curl https://jobsapi.clicktrick.in/health`

## Next Steps

**If health check works but data endpoints return 503:**

The server is running! You just need to:

1. **Verify MongoDB Atlas cluster is active**
   - Go to https://cloud.mongodb.com
   - Check cluster status

2. **Whitelist Hostinger IP**
   - MongoDB Atlas → Network Access
   - Add Hostinger server IP or allow 0.0.0.0/0

3. **Redeploy again** after fixing MongoDB access

## Key Improvements

| Issue | Before | After |
|-------|--------|-------|
| Server starts | ❌ Dies if DB unavailable | ✅ Starts anyway |
| Timeout | 503 after 30s+ | ✅ Checks DB in 5s |
| Error message | Generic error | ✅ Helpful hints |
| Health check | Requires DB | ✅ Works without DB |
| Debugging | Hard to trace | ✅ Clear logging |

---

**Status:** ✅ Ready for redeployment on Hostinger

Your API can now start independently and will gracefully handle database connection issues!
