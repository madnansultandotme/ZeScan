/**
 * Test Script for ZeScan Feedback API
 * 
 * Usage:
 *   node test-feedback-api.js
 * 
 * This will send a test feedback to your API endpoint.
 * Make sure the server is running (npm run dev) or deployed.
 */

const API_URL = 'https://zescan.zeppelinlabs.digital/api/feedback';
// For local testing, use: 'http://localhost:3000/api/feedback'

const testData = {
  type: 'feedback',
  email: 'test@example.com',
  subject: 'Test Feedback Submission',
  message: 'This is a test message to verify the feedback system is working correctly. If you receive this email, the system is functioning properly!',
  appVersion: '1.0.0',
  deviceInfo: 'Test Device (Node.js Script)',
};

async function testFeedbackAPI() {
  console.log('🧪 Testing ZeScan Feedback API...\n');
  console.log('📡 API Endpoint:', API_URL);
  console.log('📝 Test Data:', JSON.stringify(testData, null, 2), '\n');

  try {
    console.log('⏳ Sending request...');
    
    const response = await fetch(API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(testData),
    });

    console.log('📊 Response Status:', response.status, response.statusText);

    const data = await response.json();
    console.log('📦 Response Data:', JSON.stringify(data, null, 2), '\n');

    if (response.ok) {
      console.log('✅ SUCCESS! Feedback submitted successfully.');
      console.log('📧 Check your email inbox for the notification.');
      console.log('🆔 Feedback ID:', data.feedbackId);
    } else {
      console.log('❌ FAILED! Error submitting feedback.');
      console.log('Error details:', data.message);
      if (data.errors) {
        console.log('Validation errors:', data.errors);
      }
    }
  } catch (error) {
    console.error('💥 ERROR:', error.message);
    console.error('\nPossible causes:');
    console.error('- Server is not running');
    console.error('- Network connection issue');
    console.error('- API endpoint URL is incorrect');
    console.error('- CORS configuration issue');
  }
}

// Run the test
testFeedbackAPI();
