# 🔧 Fix: "Unexpected field" Error on Resume Upload

## Problem
You're getting: `MulterError: Unexpected field` with `code: 'LIMIT_UNEXPECTED_FILE'`

## Root Cause
The form-data field name doesn't match what the API expects. The API expects the field to be named **`resume`**, but you might be sending it with a different name like `file`, `pdf`, `attachment`, etc.

## Solution

### ✅ CORRECT Usage
```bash
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john@example.com" \
  -F "resume=@resume1.pdf"
```

### ❌ WRONG Usage (These will fail)
```bash
# Wrong field name 'file'
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john@example.com" \
  -F "file=@resume1.pdf"          # ❌ WRONG - causes the error

# Wrong field name 'pdf'
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john@example.com" \
  -F "pdf=@resume1.pdf"           # ❌ WRONG - causes the error

# Wrong field name 'attachment'
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john@example.com" \
  -F "attachment=@resume1.pdf"    # ❌ WRONG - causes the error
```

## For Postman Users

1. Open Postman
2. Create POST request to: `http://localhost:3000/api/applications`
3. Go to **Body** tab
4. Select **form-data**
5. Add fields:
   - Key: `name`, Value: `John Doe`, Type: `text`
   - Key: `email`, Value: `john@example.com`, Type: `text`
   - Key: `resume`, Value: (select file), Type: `file`  ⚠️ **KEY NAME MUST BE "resume"**

![Postman Form Data Example](./postman-example.txt)
```
name      | John Doe           | text
email     | john@example.com   | text
resume    | [SELECT FILE]      | file  ← Make sure key is "resume"
```

## For Thunder Client Users

1. Method: POST
2. URL: `http://localhost:3000/api/applications`
3. Go to **Body** tab
4. Select **form**
5. Add:
   - name=John Doe
   - email=john@example.com
   - resume=[select file]  ← Make sure key is "resume"

## Testing the Fix

Run the test script:
```bash
bash test-upload.sh
```

This will test the upload with the correct field name.

## API Documentation Update

The expected field name is **`resume`** for both:
- **POST** `/api/applications` - Create application
- **PUT** `/api/applications/{id}` - Update application

### Example Request:
```http
POST /api/applications HTTP/1.1
Host: localhost:3000
Content-Type: multipart/form-data; boundary=----FormBoundary

------FormBoundary
Content-Disposition: form-data; name="name"

John Doe
------FormBoundary
Content-Disposition: form-data; name="email"

john@example.com
------FormBoundary
Content-Disposition: form-data; name="resume"; filename="resume.pdf"
Content-Type: application/pdf

[PDF BINARY DATA]
------FormBoundary--
```

## If You're Still Getting the Error

1. **Double-check the field name** - Must be exactly `resume` (case-sensitive)
2. **Check file format** - Should be a PDF file
3. **Check file size** - Must be under 5MB
4. **Restart the server** - Run `npm run dev` again
5. **Verify the code was updated** - Check that `dist/routes/applications.js` has the error handling

## Better Error Messages

With the latest fix, you'll now get clearer error messages:

| Error | Message |
|-------|---------|
| Wrong field name | `"Unexpected field. Use field name 'resume' for file upload"` |
| File too large | `"File size exceeds 5MB limit"` |
| Invalid PDF | `"Only PDF files are allowed"` |

## Complete Working Example

```bash
#!/bin/bash

# Make sure server is running: npm run dev

# Create test PDF if needed
if [ ! -f "test.pdf" ]; then
  cat > test.pdf << 'EOF'
%PDF-1.4
1 0 obj
<< /Type /Catalog /Pages 2 0 R >>
endobj
2 0 obj
<< /Type /Pages /Kids [3 0 R] /Count 1 >>
endobj
3 0 obj
<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Contents 4 0 R >>
endobj
4 0 obj
<< /Length 44 >>
stream
BT
/F1 12 Tf
100 700 Td
(Test) Tj
ET
endstream
endobj
xref
0 5
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000201 00000 n 
trailer
<< /Size 5 /Root 1 0 R >>
startxref
295
%%EOF
fi

# Upload with CORRECT field name 'resume'
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john@example.com" \
  -F "resume=@test.pdf" | jq
```

## Key Takeaway

**The field name MUST be `resume`** - Not `file`, `pdf`, `attachment`, or anything else.

If you see the error again, check your curl command or Postman form-data setup to ensure the file field is named exactly `resume`.
