#!/bin/bash

# Job Application API - Test Script with Dummy Data
# This script provides dummy data and curl commands to test all API endpoints

set -e

API_URL="http://localhost:3000"
UPLOADS_DIR="./uploads"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║          JOB APPLICATION API - TEST SCRIPT                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Create a dummy PDF file for testing
create_dummy_pdf() {
    local filename=$1
    # Create a minimal valid PDF file
    cat > "$filename" << 'EOF'
%PDF-1.4
1 0 obj
<< /Type /Catalog /Pages 2 0 R >>
endobj
2 0 obj
<< /Type /Pages /Kids [3 0 R] /Count 1 >>
endobj
3 0 obj
<< /Type /Page /Parent 2 0 R /Resources << /Font << /F1 4 0 R >> >> /MediaBox [0 0 612 792] /Contents 5 0 R >>
endobj
4 0 obj
<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>
endobj
5 0 obj
<< /Length 44 >>
stream
BT
/F1 12 Tf
100 700 Td
(Test Resume) Tj
ET
endstream
endobj
xref
0 6
0000000000 65535 f 
0000000009 00000 n 
0000000058 00000 n 
0000000115 00000 n 
0000000244 00000 n 
0000000333 00000 n 
trailer
<< /Size 6 /Root 1 0 R >>
startxref
427
%%EOF
EOF
}

echo "📋 TEST DATA SETUP"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create uploads directory if it doesn't exist
mkdir -p "$UPLOADS_DIR"

# Create dummy PDF files
echo "Creating dummy PDF files..."
create_dummy_pdf "resume1.pdf"
create_dummy_pdf "resume2.pdf"
create_dummy_pdf "resume3.pdf"
create_dummy_pdf "resume_updated.pdf"
echo "✓ PDF files created"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧪 TEST ENDPOINTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test 1: Health Check
echo "1️⃣  HEALTH CHECK"
echo "────────────────────────────────────────────────────────────────"
echo "Command:"
echo "  curl $API_URL/health"
echo ""
echo "Expected Response: { \"status\": \"OK\", \"message\": \"Server is running\" }"
echo ""
echo "To run:"
echo "  curl $API_URL/health"
echo ""
echo ""

# Test 2: Get API Info
echo "2️⃣  GET API INFO"
echo "────────────────────────────────────────────────────────────────"
echo "Command:"
echo "  curl $API_URL/"
echo ""
echo "Expected Response: API documentation with all endpoints"
echo ""
echo "To run:"
echo "  curl $API_URL/"
echo ""
echo ""

# Test 3: Create Application 1
echo "3️⃣  CREATE APPLICATION (Candidate 1)"
echo "────────────────────────────────────────────────────────────────"
echo "Candidate: John Doe"
echo "Email: john.doe@example.com"
echo ""
echo "Command:"
echo "  curl -X POST $API_URL/api/applications \\"
echo "    -F \"name=John Doe\" \\"
echo "    -F \"email=john.doe@example.com\" \\"
echo "    -F \"resume=@resume1.pdf\""
echo ""
echo "To run and save ID:"
echo "  RESPONSE1=\$(curl -s -X POST $API_URL/api/applications \\"
echo "    -F \"name=John Doe\" \\"
echo "    -F \"email=john.doe@example.com\" \\"
echo "    -F \"resume=@resume1.pdf\")"
echo "  APP_ID_1=\$(echo \$RESPONSE1 | jq -r '.data._id')"
echo "  echo \"Application ID 1: \$APP_ID_1\""
echo ""
echo "Expected Response: 201 Created with application data including _id"
echo ""
echo ""

# Test 4: Create Application 2
echo "4️⃣  CREATE APPLICATION (Candidate 2)"
echo "────────────────────────────────────────────────────────────────"
echo "Candidate: Jane Smith"
echo "Email: jane.smith@example.com"
echo ""
echo "Command:"
echo "  curl -X POST $API_URL/api/applications \\"
echo "    -F \"name=Jane Smith\" \\"
echo "    -F \"email=jane.smith@example.com\" \\"
echo "    -F \"resume=@resume2.pdf\""
echo ""
echo "To run:"
echo "  curl -X POST $API_URL/api/applications \\"
echo "    -F \"name=Jane Smith\" \\"
echo "    -F \"email=jane.smith@example.com\" \\"
echo "    -F \"resume=@resume2.pdf\""
echo ""
echo ""

# Test 5: Create Application 3
echo "5️⃣  CREATE APPLICATION (Candidate 3)"
echo "────────────────────────────────────────────────────────────────"
echo "Candidate: Bob Johnson"
echo "Email: bob.johnson@example.com"
echo ""
echo "Command:"
echo "  curl -X POST $API_URL/api/applications \\"
echo "    -F \"name=Bob Johnson\" \\"
echo "    -F \"email=bob.johnson@example.com\" \\"
echo "    -F \"resume=@resume3.pdf\""
echo ""
echo "To run:"
echo "  curl -X POST $API_URL/api/applications \\"
echo "    -F \"name=Bob Johnson\" \\"
echo "    -F \"email=bob.johnson@example.com\" \\"
echo "    -F \"resume=@resume3.pdf\""
echo ""
echo ""

# Test 6: Get All Applications
echo "6️⃣  GET ALL APPLICATIONS"
echo "────────────────────────────────────────────────────────────────"
echo "Command:"
echo "  curl $API_URL/api/applications"
echo ""
echo "Expected Response: Array of all applications with count"
echo ""
echo "To run:"
echo "  curl $API_URL/api/applications | jq"
echo ""
echo ""

# Test 7: Get Single Application
echo "7️⃣  GET SINGLE APPLICATION"
echo "────────────────────────────────────────────────────────────────"
echo "Replace {APPLICATION_ID} with actual ID from step 3"
echo ""
echo "Command:"
echo "  curl $API_URL/api/applications/{APPLICATION_ID}"
echo ""
echo "Example:"
echo "  curl $API_URL/api/applications/\$APP_ID_1 | jq"
echo ""
echo "Expected Response: Single application data"
echo ""
echo ""

# Test 8: Download Resume
echo "8️⃣  DOWNLOAD RESUME"
echo "────────────────────────────────────────────────────────────────"
echo "Replace {APPLICATION_ID} with actual ID from step 3"
echo ""
echo "Command:"
echo "  curl -O $API_URL/api/applications/{APPLICATION_ID}/resume"
echo ""
echo "Example:"
echo "  curl -O $API_URL/api/applications/\$APP_ID_1/resume"
echo ""
echo "Expected Response: PDF file downloaded"
echo ""
echo ""

# Test 9: Update Application
echo "9️⃣  UPDATE APPLICATION"
echo "────────────────────────────────────────────────────────────────"
echo "Replace {APPLICATION_ID} with actual ID from step 3"
echo "Update: Change name and email"
echo ""
echo "Command:"
echo "  curl -X PUT $API_URL/api/applications/{APPLICATION_ID} \\"
echo "    -F \"name=John Doe Updated\" \\"
echo "    -F \"email=john.updated@example.com\""
echo ""
echo "Example:"
echo "  curl -X PUT $API_URL/api/applications/\$APP_ID_1 \\"
echo "    -F \"name=John Doe Updated\" \\"
echo "    -F \"email=john.updated@example.com\" | jq"
echo ""
echo "Expected Response: Updated application data"
echo ""
echo ""

# Test 10: Update with Resume
echo "🔟 UPDATE APPLICATION WITH NEW RESUME"
echo "────────────────────────────────────────────────────────────────"
echo "Replace {APPLICATION_ID} with actual ID from step 3"
echo ""
echo "Command:"
echo "  curl -X PUT $API_URL/api/applications/{APPLICATION_ID} \\"
echo "    -F \"resume=@resume_updated.pdf\""
echo ""
echo "Example:"
echo "  curl -X PUT $API_URL/api/applications/\$APP_ID_1 \\"
echo "    -F \"resume=@resume_updated.pdf\" | jq"
echo ""
echo "Expected Response: Updated application with new resume file"
echo ""
echo ""

# Test 11: Delete Application
echo "1️⃣1️⃣  DELETE APPLICATION"
echo "────────────────────────────────────────────────────────────────"
echo "Replace {APPLICATION_ID} with actual ID (use the 3rd one to keep data)"
echo ""
echo "Command:"
echo "  curl -X DELETE $API_URL/api/applications/{APPLICATION_ID}"
echo ""
echo "Example (delete candidate 2):"
echo "  curl -X DELETE $API_URL/api/applications/\$APP_ID_2 | jq"
echo ""
echo "Expected Response: Deleted application data"
echo ""
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 DUMMY DATA REFERENCE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cat << 'EOF'
Candidate 1:
  Name: John Doe
  Email: john.doe@example.com
  Resume: resume1.pdf

Candidate 2:
  Name: Jane Smith
  Email: jane.smith@example.com
  Resume: resume2.pdf

Candidate 3:
  Name: Bob Johnson
  Email: bob.johnson@example.com
  Resume: resume3.pdf

Updated Data:
  Name: John Doe Updated
  Email: john.updated@example.com
  Resume: resume_updated.pdf

EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎯 QUICK TEST SEQUENCE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Run these commands in order (in a separate terminal):"
echo ""
echo "# Start the server (Terminal 1)"
echo "npm run dev"
echo ""
echo "# Run tests (Terminal 2)"
echo "bash test-api.sh"
echo ""
echo "# Then manually run individual curl commands:"
echo ""
echo "# 1. Health check"
echo "curl http://localhost:3000/health"
echo ""
echo "# 2. Create first application"
echo "curl -X POST http://localhost:3000/api/applications \\"
echo "  -F 'name=John Doe' \\"
echo "  -F 'email=john.doe@example.com' \\"
echo "  -F 'resume=@resume1.pdf'"
echo ""
echo "# 3. Get all applications"
echo "curl http://localhost:3000/api/applications | jq"
echo ""
echo "# 4. Get single application (replace ID)"
echo "curl http://localhost:3000/api/applications/{ID} | jq"
echo ""
echo "# 5. Update application"
echo "curl -X PUT http://localhost:3000/api/applications/{ID} \\"
echo "  -F 'name=John Doe Updated'"
echo ""
echo "# 6. Delete application"
echo "curl -X DELETE http://localhost:3000/api/applications/{ID}"
echo ""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ SETUP COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "PDF files created: resume1.pdf, resume2.pdf, resume3.pdf, resume_updated.pdf"
echo "You can now test all endpoints using the curl commands above!"
echo ""
