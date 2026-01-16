#!/bin/bash

# Test script to verify the fix is working

API_URL="http://localhost:3000"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║           TESTING MULTER FIX - RESUME UPLOAD                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Make sure we have a PDF file
if [ ! -f "resume1.pdf" ]; then
    echo "Creating test PDF..."
    cat > resume1.pdf << 'EOF'
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
fi

echo "Testing upload with correct field name 'resume':"
echo ""
echo "Command:"
echo "curl -X POST $API_URL/api/applications \\"
echo "  -F 'name=Test User' \\"
echo "  -F 'email=test@example.com' \\"
echo "  -F 'resume=@resume1.pdf'"
echo ""

curl -X POST "$API_URL/api/applications" \
  -F "name=Test User" \
  -F "email=test@example.com" \
  -F "resume=@resume1.pdf" | jq

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ If you see application data above, the fix is working!"
echo ""
echo "⚠️  IMPORTANT: Make sure you use the field name 'resume' (not 'file', 'pdf', etc)"
echo ""
echo "CORRECT:"
echo "  -F 'resume=@resume1.pdf'"
echo ""
echo "WRONG:"
echo "  -F 'file=@resume1.pdf'       ❌"
echo "  -F 'pdf=@resume1.pdf'        ❌"
echo "  -F 'attachment=@resume1.pdf' ❌"
echo ""
