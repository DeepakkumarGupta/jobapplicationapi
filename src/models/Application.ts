import mongoose, { Schema, Document } from 'mongoose';

export interface IApplication extends Document {
  name: string;
  email: string;
  resumePath: string;
  resumeFileName: string;
  createdAt: Date;
  updatedAt: Date;
}

const applicationSchema = new Schema<IApplication>(
  {
    name: {
      type: String,
      required: [true, 'Candidate name is required'],
      trim: true,
      minlength: [2, 'Name must be at least 2 characters long'],
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      lowercase: true,
      match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Please provide a valid email'],
    },
    resumePath: {
      type: String,
      required: [true, 'Resume path is required'],
    },
    resumeFileName: {
      type: String,
      required: [true, 'Resume file name is required'],
    },
  },
  {
    timestamps: true,
  }
);

export const Application = mongoose.model<IApplication>('Application', applicationSchema);
