class RegisteredUser {
  final String id;
  final String fullName;
  final String email;
  final String profilePic;

  RegisteredUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePic,
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    return RegisteredUser(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profilePic: json['profilePic'],
    );
  }
}
