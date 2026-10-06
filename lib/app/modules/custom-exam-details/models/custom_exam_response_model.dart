import '../../contest-details/models/registered_user_model.dart';
import '../../contests/models/contest_model.dart';

class CustomExamDetailsResponse {
  final Contest contest;
  final List<RegisteredUser> registeredUsers;

  CustomExamDetailsResponse({
    required this.contest,
    required this.registeredUsers,
  });

  factory CustomExamDetailsResponse.fromJson(Map<String, dynamic> json) {
    // Handle both possible response structures
    if (json is Map<String, dynamic>) {
      return CustomExamDetailsResponse(
        contest: Contest.fromJson(json), // Use the entire json object for contest
        registeredUsers: (json['registeredUsers'] as List?)
                ?.map((user) => RegisteredUser.fromJson(user as Map<String, dynamic>))
                .toList() ??
            [],
      );
    } else {
      // Handle error case
      throw FormatException('Invalid response format: $json');
    }
  }
}
