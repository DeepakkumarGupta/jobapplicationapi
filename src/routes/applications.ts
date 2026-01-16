import express, { Request, Response } from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import { Application, IApplication } from '../models/Application';

const router = express.Router();

// Configure multer for file uploads
const uploadDir = 'uploads';
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, uploadDir);
  },
  filename: (_req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
});

const fileFilter = (_req: any, file: Express.Multer.File, cb: multer.FileFilterCallback) => {
  // Only allow PDF files
  if (file.mimetype === 'application/pdf' || file.originalname.toLowerCase().endsWith('.pdf')) {
    cb(null, true);
  } else {
    cb(new Error('Only PDF files are allowed') as any);
  }
};

const upload = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
});

// Create a new job application
router.post('/applications', (req: Request, res: Response, next) => {
  upload.single('resume')(req, res, (err: any) => {
    if (err) {
      if (err.code === 'LIMIT_FILE_SIZE') {
        return res.status(400).json({ error: 'File size exceeds 5MB limit' });
      }
      if (err.code === 'LIMIT_UNEXPECTED_FILE') {
        return res.status(400).json({ error: 'Unexpected field. Use field name "resume" for file upload' });
      }
      return res.status(400).json({ error: err.message || 'File upload error' });
    }
    next();
  });
}, async (req: Request, res: Response) => {
  try {
    const { name, email } = req.body;

    // Validation
    if (!name || !email) {
      return res.status(400).json({ error: 'Name and email are required' });
    }

    if (!req.file) {
      return res.status(400).json({ error: 'Resume file is required' });
    }

    // Create new application
    const application = new Application({
      name: name.trim(),
      email: email.trim().toLowerCase(),
      resumePath: req.file.path,
      resumeFileName: req.file.filename,
    });

    const savedApplication = await application.save();

    res.status(201).json({
      message: 'Application submitted successfully',
      data: savedApplication,
    });
  } catch (error: any) {
    if (req.file) {
      fs.unlinkSync(req.file.path);
    }

    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors)
        .map((err: any) => err.message)
        .join(', ');
      return res.status(400).json({ error: messages });
    }

    console.error('Error creating application:', error);
    res.status(500).json({ error: 'Failed to submit application' });
  }
});

// Get all applications
router.get('/applications', async (_req: Request, res: Response) => {
  try {
    const applications = await Application.find().sort({ createdAt: -1 });
    res.json({
      message: 'Applications retrieved successfully',
      data: applications,
      count: applications.length,
    });
  } catch (error) {
    console.error('Error fetching applications:', error);
    res.status(500).json({ error: 'Failed to fetch applications' });
  }
});

// Get a single application by ID
router.get('/applications/:id', async (req: Request, res: Response) => {
  try {
    const application = await Application.findById(req.params.id);

    if (!application) {
      return res.status(404).json({ error: 'Application not found' });
    }

    res.json({
      message: 'Application retrieved successfully',
      data: application,
    });
  } catch (error) {
    console.error('Error fetching application:', error);
    res.status(500).json({ error: 'Failed to fetch application' });
  }
});

// Download resume
router.get('/applications/:id/resume', async (req: Request, res: Response) => {
  try {
    const application = await Application.findById(req.params.id);

    if (!application) {
      return res.status(404).json({ error: 'Application not found' });
    }

    if (!fs.existsSync(application.resumePath)) {
      return res.status(404).json({ error: 'Resume file not found' });
    }

    res.download(application.resumePath, application.resumeFileName);
  } catch (error) {
    console.error('Error downloading resume:', error);
    res.status(500).json({ error: 'Failed to download resume' });
  }
});

// Update an application
router.put('/applications/:id', (req: Request, res: Response, next) => {
  upload.single('resume')(req, res, (err: any) => {
    if (err) {
      if (err.code === 'LIMIT_FILE_SIZE') {
        return res.status(400).json({ error: 'File size exceeds 5MB limit' });
      }
      if (err.code === 'LIMIT_UNEXPECTED_FILE') {
        return res.status(400).json({ error: 'Unexpected field. Use field name "resume" for file upload' });
      }
      return res.status(400).json({ error: err.message || 'File upload error' });
    }
    next();
  });
}, async (req: Request, res: Response) => {
  try {
    const { name, email } = req.body;
    const application = await Application.findById(req.params.id);

    if (!application) {
      if (req.file) {
        fs.unlinkSync(req.file.path);
      }
      return res.status(404).json({ error: 'Application not found' });
    }

    // Update fields
    if (name) {
      application.name = name.trim();
    }
    if (email) {
      application.email = email.trim().toLowerCase();
    }

    // Update resume if provided
    if (req.file) {
      const oldResumePath = application.resumePath;
      application.resumePath = req.file.path;
      application.resumeFileName = req.file.filename;

      // Delete old resume file
      if (fs.existsSync(oldResumePath)) {
        fs.unlinkSync(oldResumePath);
      }
    }

    const updatedApplication = await application.save();

    res.json({
      message: 'Application updated successfully',
      data: updatedApplication,
    });
  } catch (error: any) {
    if (req.file && fs.existsSync(req.file.path)) {
      fs.unlinkSync(req.file.path);
    }

    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors)
        .map((err: any) => err.message)
        .join(', ');
      return res.status(400).json({ error: messages });
    }

    console.error('Error updating application:', error);
    res.status(500).json({ error: 'Failed to update application' });
  }
});

// Delete an application
router.delete('/applications/:id', async (req: Request, res: Response) => {
  try {
    const application = await Application.findByIdAndDelete(req.params.id);

    if (!application) {
      return res.status(404).json({ error: 'Application not found' });
    }

    // Delete resume file
    if (fs.existsSync(application.resumePath)) {
      fs.unlinkSync(application.resumePath);
    }

    res.json({
      message: 'Application deleted successfully',
      data: application,
    });
  } catch (error) {
    console.error('Error deleting application:', error);
    res.status(500).json({ error: 'Failed to delete application' });
  }
});

export default router;
