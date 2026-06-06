# ZeScan Feedback System Setup Guide

## Overview

The ZeScan feedback system allows users to submit feedback, bug reports, and feature requests from both the mobile app and website. All submissions are sent via email to your personal inbox.

## Backend Architecture

- **Framework**: Next.js API Routes
- **Email Service**: Nodemailer (supports Gmail, Outlook, Yahoo, Custom SMTP)
- **Storage**: Currently email-only (can be extended to Firestore/MongoDB)
- **Validation**: Zod schema validation

## Setup Instructions

### 1. Email Configuration

#### For Gmail (Recommended):

1. **Enable 2-Factor Authentication**
   - Go to [Google Account Security](https://myaccount.google.com/security)
   - Enable 2-Step Verification

2. **Generate App Password**
   - Go to [App Passwords](https://myaccount.google.com/apppasswords)
   - Select "Mail" and "Other (Custom name)"
   - Name it "ZeScan Feedback"
   - Copy the generated 16-character password

3. **Create Environment File**
   ```bash
   cd zescan-web
   cp .env.example .env.local
   ```

4. **Update .env.local**
   ```env
   EMAIL_USER=your-gmail@gmail.com
   EMAIL_PASSWORD=your-16-char-app-password
   NOTIFICATION_EMAIL=your-personal-email@gmail.com
   ```

#### For Other Email Providers:

**Outlook/Hotmail:**
```env
EMAIL_USER=your-email@outlook.com
EMAIL_PASSWORD=your-password
NOTIFICATION_EMAIL=your-personal-email@outlook.com
```

**Yahoo:**
```env
EMAIL_USER=your-email@yahoo.com
EMAIL_PASSWORD=your-app-password
NOTIFICATION_EMAIL=your-personal-email@yahoo.com
```

**Custom SMTP:**
Edit `lib/emailService.ts` and replace the transporter configuration:
```typescript
const createTransporter = () => {
  return nodemailer.createTransporter({
    host: 'smtp.example.com',
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASSWORD,
    },
  });
};
```

### 2. Install Dependencies

```bash
cd zescan-web
npm install
```

Dependencies installed:
- `nodemailer`: Email sending
- `@types/nodemailer`: TypeScript types
- `zod`: Input validation (already included)

### 3. Test the Setup

#### Test Locally:

1. Start the development server:
   ```bash
   npm run dev
   ```

2. Test the API endpoint:
   ```bash
   curl -X POST http://localhost:3000/api/feedback \
     -H "Content-Type: application/json" \
     -d '{
       "type": "feedback",
       "email": "test@example.com",
       "subject": "Test Feedback",
       "message": "This is a test message to verify the feedback system works correctly.",
       "appVersion": "1.0.0",
       "deviceInfo": "Test Device"
     }'
   ```

3. Check your email inbox for the feedback notification

#### Test from Website:

1. Navigate to `http://localhost:3000/contact`
2. Fill out the form
3. Submit and check your email

### 4. Deploy to Production

#### Vercel (Recommended):

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Add feedback system"
   git push
   ```

2. **Deploy on Vercel**
   - Go to [Vercel Dashboard](https://vercel.com)
   - Import your repository
   - Add environment variables:
     - `EMAIL_USER`
     - `EMAIL_PASSWORD`
     - `NOTIFICATION_EMAIL`
   - Deploy

3. **Update Mobile App**
   - Update the API URL in `lib/features/settings/feedback_screen.dart`
   - Change from `http://localhost:3000/api/feedback` to `https://your-domain.vercel.app/api/feedback`

#### Other Platforms:

The feedback system works on any Node.js hosting platform:
- Netlify Functions
- AWS Lambda
- Google Cloud Functions
- Railway
- Render

## Mobile App Setup

### 1. Install Dependencies

```bash
cd zescan
flutter pub get
```

New dependencies added:
- `http`: HTTP requests
- `device_info_plus`: Device information
- `package_info_plus`: App version info

### 2. Update API Endpoint

Edit `lib/features/settings/feedback_screen.dart` and update line 144:

```dart
final response = await http.post(
  Uri.parse('https://your-domain.vercel.app/api/feedback'), // Update this URL
  // ...
);
```

### 3. Test from App

1. Run the app:
   ```bash
   flutter run
   ```

2. Navigate to Settings → Send Feedback / Report Bug / Feature Request
3. Fill out the form and submit
4. Check your email inbox

## Email Template

The feedback emails include:

- **Type**: Feedback, Bug Report, or Feature Request
- **Subject**: User-provided subject
- **Message**: Detailed message from user
- **User Email**: (Optional) For follow-up
- **App Version**: Automatically captured
- **Device Info**: Automatically captured
- **Timestamp**: Submission time
- **IP Address**: For security/spam prevention
- **User Agent**: Browser/app information

## API Endpoints

### POST /api/feedback

Submit feedback, bug reports, or feature requests.

**Request Body:**
```json
{
  "type": "feedback" | "bug_report" | "feature_request",
  "email": "user@example.com", // Optional
  "subject": "Brief description",
  "message": "Detailed message",
  "appVersion": "1.0.0", // Optional
  "deviceInfo": "Samsung Galaxy S21" // Optional
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Thank you for your feedback! We appreciate your input.",
  "feedbackId": "1234567890-abc123"
}
```

**Response (Error):**
```json
{
  "success": false,
  "message": "Error message",
  "errors": [] // Validation errors if applicable
}
```

### GET /api/feedback/stats

Get feedback statistics (for future dashboard).

**Response:**
```json
{
  "success": true,
  "stats": {
    "total": 0,
    "byType": {
      "feedback": 0,
      "feature_request": 0,
      "bug_report": 0
    },
    "byStatus": {
      "new": 0,
      "reviewing": 0,
      "planned": 0,
      "completed": 0,
      "closed": 0
    },
    "recentCount": 0
  }
}
```

## Security Considerations

1. **Environment Variables**: Never commit `.env.local` to Git
2. **Rate Limiting**: Consider adding rate limiting for production
3. **Validation**: All inputs are validated with Zod schemas
4. **Email Privacy**: User emails are not required and are only used for replies
5. **Spam Prevention**: IP addresses are logged for spam tracking

## Future Enhancements

### Database Storage (Optional)

To save feedback to a database instead of just email:

1. **Install Firestore/MongoDB**
   ```bash
   npm install firebase-admin
   # or
   npm install mongodb
   ```

2. **Update API Route**
   Edit `app/api/feedback/route.ts` and uncomment:
   ```typescript
   // await saveFeedbackToDatabase(feedback);
   ```

3. **Implement Database Function**
   Create `lib/database.ts` with save logic

### Admin Dashboard (Optional)

Create an admin panel to view and manage feedback:

1. Create `/app/admin/page.tsx`
2. Add authentication (NextAuth.js)
3. Display feedback from database
4. Add status updates and reply functionality

## Troubleshooting

### Email Not Sending

1. **Check credentials**: Verify EMAIL_USER and EMAIL_PASSWORD in .env.local
2. **Check Gmail App Password**: Must be 16 characters without spaces
3. **Check logs**: Look at terminal output for error messages
4. **Test configuration**:
   ```typescript
   import { testEmailConfiguration } from '@/lib/emailService';
   await testEmailConfiguration(); // Should return true
   ```

### Mobile App Connection Error

1. **Check URL**: Ensure API endpoint URL is correct
2. **Check CORS**: Vercel handles this automatically
3. **Check network**: Ensure device has internet connection
4. **Check SSL**: Use HTTPS in production

### Validation Errors

Common validation errors:
- Subject too short (min 3 chars)
- Message too short (min 10 chars)
- Invalid email format
- Message too long (max 2000 chars)

## Support

For issues or questions:
- Check the logs in Vercel dashboard
- Test API endpoint with curl/Postman
- Verify environment variables are set correctly
- Check email spam folder

## License

This feedback system is part of ZeScan and follows the same license.
