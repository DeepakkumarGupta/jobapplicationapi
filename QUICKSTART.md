# Quick Start Guide

## 1. Setup Environment

```bash
# Copy the example env file
cp .env.example .env
```

Edit `.env` and set your MongoDB URI. For local development:
```
MONGODB_URI=mongodb://localhost:27017/job-applications
PORT=3000
NODE_ENV=development
```

## 2. Start MongoDB

### Option A: Local MongoDB
```bash
mongod
```

### Option B: MongoDB Atlas (Cloud)
Update `MONGODB_URI` in `.env` with your Atlas connection string.

## 3. Start the Server

```bash
# Development mode with auto-reload
npm run dev

# Or production mode
npm start
```

You should see:
```
✓ MongoDB connected: localhost
✓ Server running on http://localhost:3000
✓ Environment: development
```

## 4. Test the API

### Using curl:

**Create an application** (requires a PDF file):
```bash
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john@example.com" \
  -F "resume=@/path/to/resume.pdf"
```

**Get all applications**:
```bash
curl http://localhost:3000/api/applications
```

**Get single application** (replace with real ID):
```bash
curl http://localhost:3000/api/applications/507f1f77bcf86cd799439011
```

**Download resume**:
```bash
curl -O http://localhost:3000/api/applications/507f1f77bcf86cd799439011/resume
```

**Update application**:
```bash
curl -X PUT http://localhost:3000/api/applications/507f1f77bcf86cd799439011 \
  -F "name=Jane Doe" \
  -F "email=jane@example.com"
```

**Delete application**:
```bash
curl -X DELETE http://localhost:3000/api/applications/507f1f77bcf86cd799439011
```

## 5. Using Postman or Thunder Client

1. Import the following endpoints:
   - POST `http://localhost:3000/api/applications` (select Body → form-data)
   - GET `http://localhost:3000/api/applications`
   - GET `http://localhost:3000/api/applications/:id`
   - GET `http://localhost:3000/api/applications/:id/resume`
   - PUT `http://localhost:3000/api/applications/:id` (select Body → form-data)
   - DELETE `http://localhost:3000/api/applications/:id`

2. For POST and PUT requests, add form data:
   - Key: `name`, Value: `John Doe`
   - Key: `email`, Value: `john@example.com`
   - Key: `resume`, Type: `File`, Value: select your PDF

## 6. Monitor Database

Use MongoDB Compass to view your database:
- Connect to: `mongodb://localhost:27017`
- Database: `job-applications`
- Collection: `applications`

## Useful Commands

```bash
# Build TypeScript
npm run build

# Run in development
npm run dev

# Run production
npm start

# Watch TypeScript changes
npm run watch

# Install dependencies
npm install

# Check health
curl http://localhost:3000/health
```

## Troubleshooting

**MongoDB Connection Refused?**
- Make sure MongoDB is running: `mongod`
- Check your MONGODB_URI in .env

**Port 3000 Already in Use?**
- Change PORT in .env or kill the process:
  ```bash
  lsof -i :3000
  kill -9 <PID>
  ```

**Upload Not Working?**
- Ensure you're sending a PDF file
- File size must be under 5MB
- Check the `uploads/` directory was created

**Build Errors?**
- Delete `node_modules` and `dist` folders
- Run `npm install` again
- Then `npm run build`
