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
    // Helper function to safely parse nested objects
    Map<String, dynamic>? safelyGetMap(dynamic value) {
      if (value == null) return null;
      if (value is Map<String, dynamic>) return value;
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
      print('Cannot convert to Map<String, dynamic>: $value (${value.runtimeType})');
      return null;
    }
    
    // Handle institution data
    String? institutionId;
    Institution? institutionObject;
    final institutionData = json['institution'];
    
    if (institutionData is String) {
      institutionId = institutionData;
    } else if (institutionData != null) {
      final institutionMap = safelyGetMap(institutionData);
      if (institutionMap != null) {
        institutionId = institutionMap['_id'] as String?;
        try {
          institutionObject = Institution.fromJson(institutionMap);
        } catch (e) {
          print('Error creating Institution object: $e');
        }
      }
    }
    
    // Handle institutionType data
    String? institutionTypeId;
    InstitutionType? institutionTypeObject;
    final institutionTypeData = json['institutionType'];
    
    if (institutionTypeData is String) {
      institutionTypeId = institutionTypeData;
    } else if (institutionTypeData != null) {
      final institutionTypeMap = safelyGetMap(institutionTypeData);
      if (institutionTypeMap != null) {
        institutionTypeId = institutionTypeMap['_id'] as String?;
        try {
          institutionTypeObject = InstitutionType.fromJson(institutionTypeMap);
        } catch (e) {
          print('Error creating InstitutionType object: $e');
        }
      }
    }
    
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
      institution: institutionId,
      institutionObj: institutionObject,
      institutionType: institutionTypeId,
      institutionTypeObj: institutionTypeObject,
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
      profilePic: (() {
        final pic = json['profilePic'];
        print("DEBUG: Raw profilePic value from JSON: '$pic' (type: ${pic?.runtimeType})");
        
        if (pic == null || pic.toString().isEmpty || pic == 'null') {
          print("DEBUG: Using default profile pic URL due to empty/null value");
          return 'https://picsum.photos/id/1/200/300';
        }
        
        String imageUrl = pic.toString();
        print("DEBUG: Using profile pic URL: '$imageUrl'");
        
        // Validate URL format
        if (!imageUrl.startsWith('http')) {
          print("DEBUG: Image URL doesn't start with http - might be invalid: '$imageUrl'");
        }
        
        return imageUrl;
      })(),
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
