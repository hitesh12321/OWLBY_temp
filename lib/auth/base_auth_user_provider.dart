class AuthUserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  const AuthUserModel({
    this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
  });
// to send data to api as response body  or to database sqflite
  Map<String, dynamic> toMap() {
    return {
'uid': uid,
'email': email,
'displayName': displayName,
'photoUrl': photoUrl,
'phoneNumber': phoneNumber,


    };
  }

// here we convert json to model 
// parsing json response data form api or from database like sqflite
  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    return AuthUserModel(
uid: map['uid'] as String?,
email: map['email'] as String?,
displayName: map['displayName'] as String?,
photoUrl: map['photoUrl'] as String?,
phoneNumber: map['phoneNumber'] as String?,


    );
  } 
}

abstract class BaseAuthUser {
  bool get loggedIn;
  bool get emailVerified;

  AuthUserModel get authUserInfo;

  Future? delete();
  Future? updateEmail(String email);
  Future? updatePassword(String newPassword);
  Future? sendEmailVerification();
  Future refreshUser() async {}

  String? get uid => authUserInfo.uid;
  String? get email => authUserInfo.email;
  String? get displayName => authUserInfo.displayName;
  String? get photoUrl => authUserInfo.photoUrl;
  String? get phoneNumber => authUserInfo.phoneNumber;
}

BaseAuthUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
