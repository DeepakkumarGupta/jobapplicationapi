#!/bin/bash

# Job Application API - Curl Test Examples
# Copy and paste these commands to test all endpoints

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           JOB APPLICATION API - CURL TEST EXAMPLES            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

API_URL="http://localhost:3000"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Prerequisites:${NC}"
echo "1. Make sure the server is running: npm run dev"
echo "2. MongoDB is running: mongod"
echo "3. PDF files exist: resume1.pdf, resume2.pdf, resume3.pdf"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Test 1: Health Check
echo -e "${GREEN}1. HEALTH CHECK${NC}"
echo "curl $API_URL/health"
echo ""

# Test 2: Get API Documentation
echo -e "${GREEN}2. GET API DOCUMENTATION${NC}"
echo "curl $API_URL/"
echo ""

# Test 3: Create First Application
echo -e "${GREEN}3. CREATE FIRST APPLICATION (John Doe)${NC}"
echo "curl -X POST $API_URL/api/applications \\"
echo "  -F 'name=John Doe' \\"
echo "  -F 'email=john.doe@example.com' \\"
echo "  -F 'resume=@resume1.pdf'"
echo ""
echo "Save the _id from response for later use. Example: app_id=507f1f77bcf86cd799439011"
echo ""

# Test 4: Create Second Application
echo -e "${GREEN}4. CREATE SECOND APPLICATION (Jane Smith)${NC}"
echo "curl -X POST $API_URL/api/applications \\"
echo "  -F 'name=Jane Smith' \\"
echo "  -F 'email=jane.smith@example.com' \\"
echo "  -F 'resume=@resume2.pdf'"
echo ""

# Test 5: Create Third Application
echo -e "${GREEN}5. CREATE THIRD APPLICATION (Bob Johnson)${NC}"
echo "curl -X POST $API_URL/api/applications \\"
echo "  -F 'name=Bob Johnson' \\"
echo "  -F 'email=bob.johnson@example.com' \\"
echo "  -F 'resume=@resume3.pdf'"
echo ""

# Test 6: Get All Applications
echo -e "${GREEN}6. GET ALL APPLICATIONS${NC}"
echo "curl $API_URL/api/applications"
echo ""
echo "Pretty print with jq:"
echo "curl $API_URL/api/applications | jq"
echo ""

# Test 7: Get Single Application
echo -e "${GREEN}7. GET SINGLE APPLICATION${NC}"
echo "Replace app_id with actual ID from step 3"
echo "curl $API_URL/api/applications/app_id"
echo ""
echo "Example:"
echo "curl $API_URL/api/applications/507f1f77bcf86cd799439011 | jq"
echo ""

# Test 8: Download Resume
echo -e "${GREEN}8. DOWNLOAD RESUME${NC}"
echo "Replace app_id with actual ID from step 3"
echo "curl -O $API_URL/api/applications/app_id/resume"
echo ""
echo "Example (saves as resume):"
echo "curl -O $API_URL/api/applications/507f1f77bcf86cd799439011/resume"
echo ""
echo "Example (save with custom name):"
echo "curl -o downloaded_resume.pdf $API_URL/api/applications/507f1f77bcf86cd799439011/resume"
echo ""

# Test 9: Update Application (Name and Email)
echo -e "${GREEN}9. UPDATE APPLICATION - NAME AND EMAIL${NC}"
echo "Replace app_id with actual ID from step 3"
echo "curl -X PUT $API_URL/api/applications/app_id \\"
echo "  -F 'name=John Doe Updated' \\"
echo "  -F 'email=john.updated@example.com'"
echo ""
echo "Example:"
echo "curl -X PUT $API_URL/api/applications/507f1f77bcf86cd799439011 \\"
echo "  -F 'name=John Doe Updated' \\"
echo "  -F 'email=john.updated@example.com' | jq"
echo ""

# Test 10: Update Application (Resume Only)
echo -e "${GREEN}10. UPDATE APPLICATION - RESUME ONLY${NC}"
echo "Replace app_id with actual ID from step 3"
echo "curl -X PUT $API_URL/api/applications/app_id \\"
echo "  -F 'resume=@resume1.pdf'"
echo ""

# Test 11: Delete Application
echo -e "${GREEN}11. DELETE APPLICATION${NC}"
echo "Replace app_id with actual ID (recommend using the 3rd one)"
echo "curl -X DELETE $API_URL/api/applications/app_id"
echo ""
echo "Example:"
echo "curl -X DELETE $API_URL/api/applications/507f1f77bcf86cd799439011 | jq"
echo ""

# Error Cases
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}ERROR TEST CASES${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo -e "${GREEN}1. MISSING NAME (Should return 400 error)${NC}"
echo "curl -X POST $API_URL/api/applications \\"
echo "  -F 'email=test@example.com' \\"
echo "  -F 'resume=@resume1.pdf'"
echo ""

echo -e "${GREEN}2. MISSING EMAIL (Should return 400 error)${NC}"
echo "curl -X POST $API_URL/api/applications \\"
echo "  -F 'name=Test User' \\"
echo "  -F 'resume=@resume1.pdf'"
echo ""

echo -e "${GREEN}3. INVALID EMAIL FORMAT (Should return 400 error)${NC}"
echo "curl -X POST $API_URL/api/applications \\"
echo "  -F 'name=Test User' \\"
echo "  -F 'email=invalid-email' \\"
echo "  -F 'resume=@resume1.pdf'"
echo ""

echo -e "${GREEN}4. INVALID APPLICATION ID (Should return 404 error)${NC}"
echo "curl $API_URL/api/applications/invalid-id-123456"
echo ""

echo -e "${GREEN}5. DELETE NON-EXISTENT APPLICATION (Should return 404 error)${NC}"
echo "curl -X DELETE $API_URL/api/applications/invalid-id-123456"
echo ""

# Batch operations
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}BATCH OPERATIONS (Copy to a .sh file and execute)${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cat << 'EOF'
#!/bin/bash

API_URL="http://localhost:3000"

echo "Creating 3 applications..."

# Create Application 1
APP1=$(curl -s -X POST $API_URL/api/applications \
  -F 'name=John Doe' \
  -F 'email=john.doe@example.com' \
  -F 'resume=@resume1.pdf')
APP1_ID=$(echo $APP1 | jq -r '.data._id')
echo "✓ Created: John Doe (ID: $APP1_ID)"

# Create Application 2
APP2=$(curl -s -X POST $API_URL/api/applications \
  -F 'name=Jane Smith' \
  -F 'email=jane.smith@example.com' \
  -F 'resume=@resume2.pdf')
APP2_ID=$(echo $APP2 | jq -r '.data._id')
echo "✓ Created: Jane Smith (ID: $APP2_ID)"

# Create Application 3
APP3=$(curl -s -X POST $API_URL/api/applications \
  -F 'name=Bob Johnson' \
  -F 'email=bob.johnson@example.com' \
  -F 'resume=@resume3.pdf')
APP3_ID=$(echo $APP3 | jq -r '.data._id')
echo "✓ Created: Bob Johnson (ID: $APP3_ID)"

echo ""
echo "Getting all applications..."
curl -s $API_URL/api/applications | jq '.data | length'
echo "applications found"

echo ""
echo "Updating first application..."
curl -s -X PUT $API_URL/api/applications/$APP1_ID \
  -F 'name=John Doe Updated' \
  -F 'email=john.updated@example.com' | jq '.message'

echo ""
echo "Deleting second application..."
curl -s -X DELETE $API_URL/api/applications/$APP2_ID | jq '.message'

echo ""
echo "Final count:"
curl -s $API_URL/api/applications | jq '.count'

EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}USING JQ FOR JSON FORMATTING${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Pretty print response:"
echo "curl $API_URL/api/applications | jq"
echo ""

echo "Extract specific field:"
echo "curl $API_URL/api/applications | jq '.data[0].name'"
echo ""

echo "Get application count:"
echo "curl $API_URL/api/applications | jq '.count'"
echo ""

echo "Get all emails:"
echo "curl $API_URL/api/applications | jq '.data[].email'"
echo ""

echo "Get IDs only:"
echo "curl $API_URL/api/applications | jq '.data[].id'"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ All curl examples ready to use!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
