import { NextResponse } from 'next/server';

// This endpoint provides statistics about feedback
// Useful for analytics dashboard
export async function GET() {
  // TODO: Fetch real stats from database
  const stats = {
    total: 0,
    byType: {
      feedback: 0,
      feature_request: 0,
      bug_report: 0,
    },
    byStatus: {
      new: 0,
      reviewing: 0,
      planned: 0,
      completed: 0,
      closed: 0,
    },
    recentCount: 0,
  };

  return NextResponse.json({
    success: true,
    stats,
  });
}
