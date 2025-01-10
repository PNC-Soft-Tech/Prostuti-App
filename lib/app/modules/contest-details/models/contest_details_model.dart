import '../../../common/models/contest_model.dart';
import 'registered_user_model.dart';

class ContestDetailsResponse {
  final Contest contest;
  final List<RegisteredUser> registeredUsers;

  ContestDetailsResponse({required this.contest, required this.registeredUsers});

  factory ContestDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ContestDetailsResponse(
      contest: Contest.fromJson(json['contest']),
      registeredUsers: (json['registeredUsers'] as List)
          .map((user) => RegisteredUser.fromJson(user))
          .toList(),
    );
  }
}
