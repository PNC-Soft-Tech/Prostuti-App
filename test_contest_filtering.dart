import 'dart:developer';

void main() {
  // TEST: Verify the contest filtering fix
  // 
  // ISSUE: Completed contests were showing because the app was calling 
  // fetchAllContests() instead of fetchRecentContests()
  //
  // FIX: Changed ContestController.displayRecentContests() to call 
  // _apiHelper.fetchRecentContests() which hits the /contests/?contestType=recent endpoint
  // This endpoint should return only active contests from the server side.
  
  // Mock contest data to test filtering logic
  final contests = [
    {
      'name': 'Completed Contest',
      'startContest': '2024-01-01T10:00:00Z',
      'endContest': '2024-01-01T12:00:00Z', // Past date
      '_id': 'contest1',
    },
    {
      'name': 'Running Contest',
      'startContest': '2024-01-15T10:00:00Z',
      'endContest': '2024-12-31T23:59:59Z', // Future date
      '_id': 'contest2',
    },
    {
      'name': 'Upcoming Contest',
      'startContest': '2024-12-20T10:00:00Z',
      'endContest': '2024-12-25T12:00:00Z', // Future date
      '_id': 'contest3',
    },
  ];

  // Test filtering logic
  final now = DateTime.now();
  log('=== CONTEST FILTERING TEST ===');
  log('Current time: $now');
  log('Total contests: ${contests.length}');

  final activeContests = contests.where((contestJson) {
    final endDateStr = contestJson['endContest'] as String;
    final endTime = DateTime.parse(endDateStr).toLocal();
    final isActive = endTime.isAfter(now);
    
    log('Contest: ${contestJson['name']}');
    log('  End: $endDateStr');
    log('  End (Local): $endTime');
    log('  Is Active: $isActive');
    log('  ---');
    
    return isActive;
  }).toList();

  log('Active contests after filtering: ${activeContests.length}');
  log('Active contest names: ${activeContests.map((c) => c['name']).join(', ')}');
}