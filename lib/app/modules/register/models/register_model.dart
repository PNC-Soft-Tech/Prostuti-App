class RegisterRequestModel {
  final String username;
  final String fname;
  final String lname;
  final String email;
  final String phone;
  final String password;

  RegisterRequestModel({
    required this.username,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.password,
  });

  /// Converts the object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "fname": fname,
      "lname": lname,
      "email": email,
      "phone": phone,
      "password": password,
    };
  }

  /// Creates an object from a JSON map
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      username: json['username'] ?? '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
