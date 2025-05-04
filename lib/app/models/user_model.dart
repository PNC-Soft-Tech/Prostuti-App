import 'institution.dart';
import 'institution_type.dart';

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
  final Institution? institutionObj; // For full institution object
  final String? institutionType; // MongoDB ObjectId as String
  final InstitutionType? institutionTypeObj; // For full institution type object
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
    this.institutionObj,
    this.institutionType,
    this.institutionTypeObj,
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
      institution: json['institution'] is String 
          ? json['institution'] 
          : json['institution']?['_id'] as String?,
      institutionObj: json['institution'] is Map 
          ? Institution.fromJson(json['institution']) 
          : null,
      institutionType: json['institutionType'] is String 
          ? json['institutionType'] 
          : json['institutionType']?['_id'] as String?,
      institutionTypeObj: json['institutionType'] is Map 
          ? InstitutionType.fromJson(json['institutionType']) 
          : null,
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

  // Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? username,
    String? fullName,
    String? fname,
    String? lname,
    String? email,
    String? phone,
    String? authType,
    int? otp,
    bool? isVerified,
    String? institution,
    Institution? institutionObj,
    String? institutionType,
    InstitutionType? institutionTypeObj,
    double? honsGpa,
    double? profileCompleted,
    String? permanentAddress,
    String? presentAddress,
    String? postCode,
    String? userPlan,
    String? userType,
    String? userRole,
    DateTime? dateOfBirth,
    String? district,
    String? upzilla,
    String? gender,
    String? division,
    String? country,
    String? profilePic,
    String? aboutMe,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      fname: fname ?? this.fname,
      lname: lname ?? this.lname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      authType: authType ?? this.authType,
      otp: otp ?? this.otp,
      isVerified: isVerified ?? this.isVerified,
      institution: institution ?? this.institution,
      institutionObj: institutionObj ?? this.institutionObj,
      institutionType: institutionType ?? this.institutionType,
      institutionTypeObj: institutionTypeObj ?? this.institutionTypeObj,
      honsGpa: honsGpa ?? this.honsGpa,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      presentAddress: presentAddress ?? this.presentAddress,
      postCode: postCode ?? this.postCode,
      userPlan: userPlan ?? this.userPlan,
      userType: userType ?? this.userType,
      userRole: userRole ?? this.userRole,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      district: district ?? this.district,
      upzilla: upzilla ?? this.upzilla,
      gender: gender ?? this.gender,
      division: division ?? this.division,
      country: country ?? this.country,
      profilePic: profilePic ?? this.profilePic,
      aboutMe: aboutMe ?? this.aboutMe,
    );
  }
}
