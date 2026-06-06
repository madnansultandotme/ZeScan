import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { sendFeedbackEmail } from '@/lib/emailService';

// Validation schema for feedback
const feedbackSchema = z.object({
  type: z.enum(['feedback', 'feature_request', 'bug_report']),
  email: z.string().email().optional().or(z.literal('')),
  subject: z.string().min(3).max(200),
  message: z.string().min(10).max(2000),
  appVersion: z.string().optional(),
  deviceInfo: z.string().optional(),
});

export async function POST(request: NextRequest) {
  try {
    // Parse request body
    const body = await request.json();
    
    // Validate input
    const validatedData = feedbackSchema.parse(body);
    
    // Create feedback entry
    const feedback = {
      id: `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      ...validatedData,
      email: validatedData.email || undefined,
      timestamp: new Date().toISOString(),
      status: 'new',
      ipAddress: request.headers.get('x-forwarded-for') || 
                 request.headers.get('x-real-ip') || 
                 'unknown',
      userAgent: request.headers.get('user-agent') || 'unknown',
    };

    // Log feedback
    console.log('📝 New feedback received:', {
      id: feedback.id,
      type: feedback.type,
      subject: feedback.subject,
    });

    // Send email notification
    try {
      await sendFeedbackEmail(feedback);
      console.log('✅ Email notification sent for feedback:', feedback.id);
    } catch (emailError) {
      console.error('❌ Failed to send email notification:', emailError);
      // Continue even if email fails - don't block the user
    }

    // TODO: Save to database (Firestore, MongoDB, etc.)
    // await saveFeedbackToDatabase(feedback);

    return NextResponse.json(
      {
        success: true,
        message: 'Thank you for your feedback! We appreciate your input.',
        feedbackId: feedback.id,
      },
      { status: 201 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        {
          success: false,
          message: 'Invalid input data',
          errors: error.errors,
        },
        { status: 400 }
      );
    }

    console.error('❌ Error processing feedback:', error);
    return NextResponse.json(
      {
        success: false,
        message: 'An error occurred while processing your feedback',
      },
      { status: 500 }
    );
  }
}

export async function GET() {
  return NextResponse.json(
    {
      message: 'Feedback API endpoint',
      methods: ['POST'],
      expectedFields: {
        type: 'feedback | feature_request | bug_report',
        email: 'string (optional)',
        subject: 'string (3-200 chars)',
        message: 'string (10-2000 chars)',
        appVersion: 'string (optional)',
        deviceInfo: 'string (optional)',
      },
    },
    { status: 200 }
  );
}
