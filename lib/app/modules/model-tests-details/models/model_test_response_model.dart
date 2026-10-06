import '../../contest-details/models/registered_user_model.dart';
import '../../contests/models/contest_model.dart';

class ModelTestDetailsResponse {
  final Contest contest;
  final List<RegisteredUser> registeredUsers;

  ModelTestDetailsResponse({
    required this.contest,
    required this.registeredUsers,
  });

  factory ModelTestDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ModelTestDetailsResponse(
      contest: Contest.fromJson(json), // Use the entire `data` object
      registeredUsers: (json['registeredUsers'] as List?)
              ?.map((user) => RegisteredUser.fromJson(user as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
