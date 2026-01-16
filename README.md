# Job Application API

A robust Express.js TypeScript API for managing job applications with resume uploads to MongoDB using Mongoose.

## Features

- ✓ Create job applications with candidate name, email, and PDF resume upload
- ✓ Retrieve all applications or a specific application
- ✓ Download resumes
- ✓ Update application details and resumes
- ✓ Delete applications
- ✓ Input validation and error handling
- ✓ File size and type restrictions (PDF only, max 5MB)
- ✓ MongoDB with Mongoose ODM
- ✓ TypeScript for type safety
- ✓ CORS enabled

## Prerequisites

- Node.js (v16+)
- npm or yarn
- MongoDB (local or Atlas)

## Installation

1. **Clone/Download the project** and navigate to the directory:
```bash
cd job-application-api
```

2. **Install dependencies**:
```bash
npm install
```

3. **Set up environment variables**:
```bash
cp .env.example .env
```

4. **Configure `.env`** file with your settings:
```env
MONGODB_URI=mongodb://localhost:27017/job-applications
PORT=3000
NODE_ENV=development
```

For MongoDB Atlas, use:
```env
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/job-applications?retryWrites=true&w=majority
```

## Development

### Build TypeScript:
```bash
npm run build
```

### Run in development mode (with auto-reload):
```bash
npm run dev
```

### Watch TypeScript changes:
```bash
npm run watch
```

### Run in production:
```bash
npm start
```

## API Endpoints

### Health Check
```
GET /health
```
Returns server status.

### Get API Info
```
GET /
```
Returns API documentation and available endpoints.

### Create Application
```
POST /api/applications
Content-Type: multipart/form-data

Fields:
- name (string, required): Candidate's full name
- email (string, required): Candidate's email address
- resume (file, required): PDF resume file (max 5MB)
```

**Example using curl**:
```bash
curl -X POST http://localhost:3000/api/applications \
  -F "name=John Doe" \
  -F "email=john@example.com" \
  -F "resume=@/path/to/resume.pdf"
```

**Response (201 Created)**:
```json
{
  "message": "Application submitted successfully",
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com",
    "resumeFileName": "1697000000000-123456789.pdf",
    "resumePath": "uploads/1697000000000-123456789.pdf",
    "createdAt": "2023-10-10T12:00:00.000Z",
    "updatedAt": "2023-10-10T12:00:00.000Z"
  }
}
```

### Get All Applications
```
GET /api/applications
```

**Response (200 OK)**:
```json
{
  "message": "Applications retrieved successfully",
  "data": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "name": "John Doe",
      "email": "john@example.com",
      "resumeFileName": "1697000000000-123456789.pdf",
      "resumePath": "uploads/1697000000000-123456789.pdf",
      "createdAt": "2023-10-10T12:00:00.000Z",
      "updatedAt": "2023-10-10T12:00:00.000Z"
    }
  ],
  "count": 1
}
```

### Get Single Application
```
GET /api/applications/:id
```

**Response (200 OK)**:
```json
{
  "message": "Application retrieved successfully",
  "data": {
    "_id": "507f1f77bcf86cd799439011",
    "name": "John Doe",
    "email": "john@example.com",
    "resumeFileName": "1697000000000-123456789.pdf",
    "resumePath": "uploads/1697000000000-123456789.pdf",
    "createdAt": "2023-10-10T12:00:00.000Z",
    "updatedAt": "2023-10-10T12:00:00.000Z"
  }
}
```

### Download Resume
```
GET /api/applications/:id/resume
```
Downloads the resume PDF file.

### Update Application
```
PUT /api/applications/:id
Content-Type: multipart/form-data

Fields (all optional):
- name (string): Updated candidate name
- email (string): Updated email
- resume (file): New resume file (PDF, max 5MB)
```

**Response (200 OK)**:
```json
{
  "message": "Application updated successfully",
  "data": { ... }
}
```

### Delete Application
```
DELETE /api/applications/:id
```

**Response (200 OK)**:
```json
{
  "message": "Application deleted successfully",
  "data": { ... }
}
```

## Error Handling

The API returns appropriate HTTP status codes and error messages:

- **400 Bad Request**: Missing required fields, invalid file type, or validation errors
- **404 Not Found**: Application or resume file not found
- **500 Internal Server Error**: Server-side errors

**Error Response Example**:
```json
{
  "error": "Only PDF files are allowed"
}
```

## File Structure

```
job-application-api/
├── src/
│   ├── index.ts              # Main application file
│   ├── config.ts             # Configuration from environment variables
│   ├── database.ts           # MongoDB connection setup
│   ├── models/
│   │   └── Application.ts    # Mongoose schema and model
│   └── routes/
│       └── applications.ts   # API endpoints
├── dist/                     # Compiled JavaScript (generated)
├── uploads/                  # Uploaded resume files
├── package.json
├── tsconfig.json
├── .env.example
├── .gitignore
└── README.md
```

## Data Validation

- **Name**: Required, 2+ characters
- **Email**: Required, valid email format
- **Resume**: Required, PDF only, max 5MB

## Security Considerations

- Only PDF files are accepted for uploads
- File size limited to 5MB to prevent abuse
- Email validation to ensure valid format
- CORS enabled for cross-origin requests
- Environment variables for sensitive configuration

## MongoDB Connection

### Local MongoDB
Ensure MongoDB is running on your machine:
```bash
mongod
```

### MongoDB Atlas (Cloud)
Use the connection string provided by MongoDB Atlas in your `.env` file.

## Troubleshooting

1. **MongoDB Connection Error**: Verify MongoDB is running and the connection URI is correct.
2. **File Upload Error**: Ensure the file is a PDF and under 5MB.
3. **Port Already in Use**: Change the PORT in `.env` or kill the process using the port.
4. **Missing Dependencies**: Run `npm install` again.

## Development Tips

- Use MongoDB Compass to visualize your database
- Use Postman or Thunder Client to test API endpoints
- Check the console logs for detailed error messages
- The `uploads` folder will be created automatically on first file upload

## License

ISC
