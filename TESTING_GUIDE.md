# 🧪 API Testing Guide with Dummy Data

## ✅ Setup Complete

All dummy data files and test scripts are ready!

### Files Created:
- ✓ `resume1.pdf` - John Doe's resume
- ✓ `resume2.pdf` - Jane Smith's resume
- ✓ `resume3.pdf` - Bob Johnson's resume
- ✓ `resume_updated.pdf` - Updated resume
- ✓ `test-api.sh` - Complete test script with documentation
- ✓ `curl-examples.sh` - All curl examples
- ✓ `test-data.json` - Test data reference in JSON format

## 🚀 Quick Start Testing

### Step 1: Start the Server (Terminal 1)
```bash
npm run dev
```

You should see:
```
✓ MongoDB connected: localhost
✓ Server running on http://localhost:3000
✓ Environment: development
```

### Step 2: Run Tests (Terminal 2)

#### Option A: View all test examples
```bash
bash curl-examples.sh
```

#### Option B: Run complete test sequence
```bash
bash test-api.sh
```

## 📋 Dummy Data Reference

### Candidate 1:
- **Name:** John Doe
- **Email:** john.doe@example.com
- **Resume:** resume1.pdf

### Candidate 2:
- **Name:** Jane Smith
- **Email:** jane.smith@example.com
- **Resume:** resume2.pdf

### Candidate 3:
- **Name:** Bob Johnson
- **Email:** bob.johnson@example.com
- **Resume:** resume3.pdf

## 🧬 Testing All Endpoints

### 1️⃣ Health Check
```bash
curl http://localhost:3000/health
```
**Expected:** 200 OK with status message

---

### 2️⃣ Create Application
```bash
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john.doe@example.com" \
  -F "resume=@resume1.pdf"
```
**Expected:** 201 Created with application data including `_id`

**Save the ID:**
```bash
RESPONSE=$(curl -s -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john.doe@example.com" \
  -F "resume=@resume1.pdf")

APP_ID=$(echo $RESPONSE | jq -r '.data._id')
echo "App ID: $APP_ID"
```

---

### 3️⃣ Get All Applications
```bash
curl http://localhost:3000/api/applications | jq
```
**Expected:** 200 OK with array of applications

---

### 4️⃣ Get Single Application
```bash
curl http://localhost:3000/api/applications/$APP_ID | jq
```
**Expected:** 200 OK with single application data

---

### 5️⃣ Download Resume
```bash
curl -O http://localhost:3000/api/applications/$APP_ID/resume
```
**Expected:** PDF file downloaded

Download with custom name:
```bash
curl -o my_resume.pdf http://localhost:3000/api/applications/$APP_ID/resume
```

---

### 6️⃣ Update Application (Name & Email)
```bash
curl -X PUT http://localhost:3000/api/applications/$APP_ID \
  -F "name=John Doe Updated" \
  -F "email=john.updated@example.com" | jq
```
**Expected:** 200 OK with updated application

---

### 7️⃣ Update Application (Resume Only)
```bash
curl -X PUT http://localhost:3000/api/applications/$APP_ID \
  -F "resume=@resume_updated.pdf" | jq
```
**Expected:** 200 OK with updated resume

---

### 8️⃣ Delete Application
```bash
curl -X DELETE http://localhost:3000/api/applications/$APP_ID | jq
```
**Expected:** 200 OK with deleted application data

---

## 🔴 Error Testing

### Missing Name
```bash
curl -X POST http://localhost:3000/api/applications \
  -F "email=test@example.com" \
  -F "resume=@resume1.pdf"
```
**Expected:** 400 Bad Request with error message

### Missing Email
```bash
curl -X POST http://localhost:3000/api/applications \
  -F "name=Test User" \
  -F "resume=@resume1.pdf"
```
**Expected:** 400 Bad Request

### Invalid Email Format
```bash
curl -X POST http://localhost:3000/api/applications \
  -F "name=Test User" \
  -F "email=invalid-email" \
  -F "resume=@resume1.pdf"
```
**Expected:** 400 Bad Request with email validation error

### Non-existent Application
```bash
curl http://localhost:3000/api/applications/invalid-id-12345
```
**Expected:** 404 Not Found

### Delete Non-existent
```bash
curl -X DELETE http://localhost:3000/api/applications/invalid-id-12345
```
**Expected:** 404 Not Found

---

## 🔄 Complete Test Sequence (Batch)

Save this as `batch-test.sh`:

```bash
#!/bin/bash

API_URL="http://localhost:3000"

echo "1. Health Check"
curl -s $API_URL/health | jq

echo ""
echo "2. Create Application 1"
APP1=$(curl -s -X POST $API_URL/api/applications \
  -F 'name=John Doe' \
  -F 'email=john.doe@example.com' \
  -F 'resume=@resume1.pdf')
APP1_ID=$(echo $APP1 | jq -r '.data._id')
echo "Created: $APP1_ID"

echo ""
echo "3. Create Application 2"
APP2=$(curl -s -X POST $API_URL/api/applications \
  -F 'name=Jane Smith' \
  -F 'email=jane.smith@example.com' \
  -F 'resume=@resume2.pdf')
APP2_ID=$(echo $APP2 | jq -r '.data._id')
echo "Created: $APP2_ID"

echo ""
echo "4. Get All Applications"
curl -s $API_URL/api/applications | jq '.count'

echo ""
echo "5. Update Application 1"
curl -s -X PUT $API_URL/api/applications/$APP1_ID \
  -F 'name=John Doe Updated' | jq '.message'

echo ""
echo "6. Delete Application 2"
curl -s -X DELETE $API_URL/api/applications/$APP2_ID | jq '.message'

echo ""
echo "7. Final Count"
curl -s $API_URL/api/applications | jq '.count'
```

Run it:
```bash
bash batch-test.sh
```

---

## 📊 Using jq for JSON Formatting

Pretty print:
```bash
curl http://localhost:3000/api/applications | jq
```

Extract specific field:
```bash
curl http://localhost:3000/api/applications | jq '.data[0].name'
```

Get all names:
```bash
curl http://localhost:3000/api/applications | jq '.data[].name'
```

Get application count:
```bash
curl http://localhost:3000/api/applications | jq '.count'
```

Get all IDs:
```bash
curl http://localhost:3000/api/applications | jq '.data[]._id'
```

---

## 🛠️ Advanced Testing with Postman

### Import Collection

1. Open Postman
2. File → Import → Select `api-examples.json`
3. All endpoints will be imported

### Create Environment

1. Create new Environment
2. Add variable: `BASE_URL` = `http://localhost:3000`
3. Add variable: `APP_ID` = (leave empty, fill after creating app)
4. Use `{{BASE_URL}}` and `{{APP_ID}}` in requests

---

## 📁 Test Data Structure

See `test-data.json` for comprehensive test scenarios including:
- ✓ 5 dummy candidates with different profiles
- ✓ Update scenarios
- ✓ Test sequences (basic flow, multiple applications)
- ✓ Error test cases with expected responses

---

## ✨ Summary

Everything is set up and ready to test:

| Component | Status | Details |
|-----------|--------|---------|
| API Server | ✅ Ready | `npm run dev` |
| MongoDB | ✅ Connected | MongoDB Atlas or local |
| Test Files | ✅ Created | resume1.pdf - resume_updated.pdf |
| Test Scripts | ✅ Ready | test-api.sh, curl-examples.sh |
| Test Data | ✅ Available | test-data.json, this guide |
| Dummy PDFs | ✅ Valid | All are working PDF files |

---

## 🚀 Next Steps

1. Start server: `npm run dev`
2. View test examples: `bash curl-examples.sh`
3. Run batch tests: Create `batch-test.sh` and run it
4. Test in Postman: Import `api-examples.json`
5. Verify all endpoints work with dummy data

Happy testing! 🎉
