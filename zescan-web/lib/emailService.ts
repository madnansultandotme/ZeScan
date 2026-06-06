import nodemailer from 'nodemailer';

interface FeedbackEmailData {
  type: 'feedback' | 'feature_request' | 'bug_report';
  email?: string;
  subject: string;
  message: string;
  appVersion?: string;
  deviceInfo?: string;
  feedbackId: string;
  timestamp: string;
  ipAddress: string;
  userAgent: string;
}

// Create reusable transporter
const createTransporter = () => {
  return nodemailer.createTransport({
    service: 'gmail', // or 'smtp.gmail.com'
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASSWORD, // Use App Password for Gmail
    },
  });
};

// Format feedback type for display
const formatFeedbackType = (type: string): string => {
  switch (type) {
    case 'feature_request':
      return '🚀 Feature Request';
    case 'bug_report':
      return '🐛 Bug Report';
    case 'feedback':
      return '💬 Feedback';
    default:
      return type;
  }
};

// Send email notification
export async function sendFeedbackEmail(data: FeedbackEmailData): Promise<void> {
  try {
    const transporter = createTransporter();

    const emailHtml = `
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
          }
          .header {
            background: linear-gradient(135deg, #2196F3 0%, #1E88E5 100%);
            color: white;
            padding: 20px;
            border-radius: 8px 8px 0 0;
          }
          .content {
            background: #f8f9fa;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-top: none;
            border-radius: 0 0 8px 8px;
          }
          .field {
            margin-bottom: 15px;
            padding: 10px;
            background: white;
            border-radius: 5px;
          }
          .label {
            font-weight: bold;
            color: #2196F3;
            margin-bottom: 5px;
          }
          .value {
            color: #555;
          }
          .footer {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #dee2e6;
            font-size: 12px;
            color: #6c757d;
          }
        </style>
      </head>
      <body>
        <div class="header">
          <h1 style="margin: 0;">ZeScan ${formatFeedbackType(data.type)}</h1>
          <p style="margin: 5px 0 0 0; opacity: 0.9;">New submission received</p>
        </div>
        
        <div class="content">
          <div class="field">
            <div class="label">Type:</div>
            <div class="value">${formatFeedbackType(data.type)}</div>
          </div>

          <div class="field">
            <div class="label">Subject:</div>
            <div class="value">${data.subject}</div>
          </div>

          <div class="field">
            <div class="label">Message:</div>
            <div class="value">${data.message.replace(/\n/g, '<br>')}</div>
          </div>

          ${data.email ? `
          <div class="field">
            <div class="label">User Email:</div>
            <div class="value"><a href="mailto:${data.email}">${data.email}</a></div>
          </div>
          ` : ''}

          ${data.appVersion ? `
          <div class="field">
            <div class="label">App Version:</div>
            <div class="value">${data.appVersion}</div>
          </div>
          ` : ''}

          ${data.deviceInfo ? `
          <div class="field">
            <div class="label">Device Info:</div>
            <div class="value">${data.deviceInfo}</div>
          </div>
          ` : ''}

          <div class="footer">
            <p><strong>Feedback ID:</strong> ${data.feedbackId}</p>
            <p><strong>Timestamp:</strong> ${new Date(data.timestamp).toLocaleString()}</p>
            <p><strong>IP Address:</strong> ${data.ipAddress}</p>
            <p><strong>User Agent:</strong> ${data.userAgent}</p>
          </div>
        </div>
      </body>
      </html>
    `;

    const mailOptions = {
      from: `"ZeScan Feedback" <${process.env.EMAIL_USER}>`,
      to: process.env.NOTIFICATION_EMAIL || process.env.EMAIL_USER,
      subject: `ZeScan ${formatFeedbackType(data.type)}: ${data.subject}`,
      html: emailHtml,
      replyTo: data.email || undefined,
    };

    await transporter.sendMail(mailOptions);
    console.log('✅ Feedback email sent successfully:', data.feedbackId);
  } catch (error) {
    console.error('❌ Error sending feedback email:', error);
    throw error;
  }
}

// Test email configuration
export async function testEmailConfiguration(): Promise<boolean> {
  try {
    const transporter = createTransporter();
    await transporter.verify();
    console.log('✅ Email configuration is valid');
    return true;
  } catch (error) {
    console.error('❌ Email configuration error:', error);
    return false;
  }
}
