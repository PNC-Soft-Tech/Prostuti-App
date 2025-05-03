class UserProfile {
  final String? id;
  final String? username;
  final String fullName;
  final String? fname;
  final String? lname;
  final String email;
  final String? phone;
  final String? authType;
  final int? otp;
  final bool isVerified;
  final String? institution; // MongoDB ObjectId as String
  final String? institutionType; // MongoDB ObjectId as String
  final double honsGpa;
  final double profileCompleted;
  final String? permanentAddress;
  final String? presentAddress;
  final String? postCode;
  final String userPlan;
  final String userType;
  final String userRole;
  final DateTime? dateOfBirth;
  final String? district;
  final String? upzilla;
  final String? gender;
  final String? division;
  final String country;
  final String profilePic;
  final String? aboutMe;

  UserProfile({
    this.id,
    this.username,
    required this.fullName,
    this.fname,
    this.lname,
    required this.email,
    this.phone,
    this.authType,
    this.otp,
    this.isVerified = false,
    this.institution,
    this.institutionType,
    this.honsGpa = 0.0,
    this.profileCompleted = 0.0,
    this.permanentAddress,
    this.presentAddress,
    this.postCode,
    this.userPlan = 'free',
    this.userType = 'student',
    this.userRole = 'user',
    this.dateOfBirth,
    this.district,
    this.upzilla,
    this.gender,
    this.division,
    this.country = 'BD',
    this.profilePic = 'https://picsum.photos/id/1/200/300',
    this.aboutMe,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      fullName: json['fullName'] as String,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      authType: json['authType'] as String?,
      otp: json['otp'] as int?,
      isVerified: json['isVerified'] as bool? ?? false,
      institution: json['institution'] as String?,
      institutionType: json['institutionType'] as String?,
      honsGpa: (json['honsGpa'] as num?)?.toDouble() ?? 0.0,
      profileCompleted: (json['profileCompleted'] as num?)?.toDouble() ?? 0.0,
      permanentAddress: json['permanentAddress'] as String?,
      presentAddress: json['presentAddress'] as String?,
      postCode: json['postCode'] as String?,
      userPlan: json['userPlan'] as String? ?? 'free',
      userType: json['userType'] as String? ?? 'student',
      userRole: json['userRole'] as String? ?? 'user',
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      district: json['district'] as String?,
      upzilla: json['upzilla'] as String?,
      gender: json['gender'] as String?,
      division: json['division'] as String?,
      country: json['country'] as String? ?? 'BD',
      profilePic:
          json['profilePic'] as String? ?? 'https://picsum.photos/id/1/200/300',
      aboutMe: json['about_me'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      if (username != null) 'username': username,
      'fullName': fullName,
      if (fname != null) 'fname': fname,
      if (lname != null) 'lname': lname,
      'email': email,
      if (phone != null) 'phone': phone,
      if (authType != null) 'authType': authType,
      if (otp != null) 'otp': otp,
      'isVerified': isVerified,
      if (institution != null) 'institution': institution,
      if (institutionType != null) 'institutionType': institutionType,
      'honsGpa': honsGpa,
      'profileCompleted': profileCompleted,
      if (permanentAddress != null) 'permanentAddress': permanentAddress,
      if (presentAddress != null) 'presentAddress': presentAddress,
      if (postCode != null) 'postCode': postCode,
      'userPlan': userPlan,
      'userType': userType,
      'userRole': userRole,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (district != null) 'district': district,
      if (upzilla != null) 'upzilla': upzilla,
      if (gender != null) 'gender': gender,
      if (division != null) 'division': division,
      'country': country,
      'profilePic': profilePic,
      if (aboutMe != null) 'about_me': aboutMe,
    };
  }
}
