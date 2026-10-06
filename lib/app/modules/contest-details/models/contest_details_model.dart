import '../../contests/models/contest_model.dart';
import 'registered_user_model.dart';

class ContestDetailsResponse {
  final Contest contest;
  final List<RegisteredUser> registeredUsers;

  ContestDetailsResponse({
    required this.contest,
    required this.registeredUsers,
  });

  factory ContestDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ContestDetailsResponse(
      contest: Contest.fromJson(json), // Use the entire `data` object
      registeredUsers: (json['registeredUsers'] as List?)
              ?.map((user) => RegisteredUser.fromJson(user as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
