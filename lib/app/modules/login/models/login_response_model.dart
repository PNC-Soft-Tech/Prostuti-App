class LoginResponseModel {
  final String token;
  final String userId;

  LoginResponseModel({required this.token, required this.userId});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Extract token from the `data` field
    final data = json['data'];
    final user = data['user'];
    return LoginResponseModel(
      token: data['token'], // Access token directly from `data`
      userId: user['_id'],  // Access user ID from `user`
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
    };
  }
}
