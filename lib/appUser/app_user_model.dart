class AppUserModel {
  final String id;
  final String email;
  final String? organizationName;
  final bool subscription;
  final int sessions;
  final String? createdAt;
  final String? updatedAt;
  final String? phone;
  final String? fullName;
  final String? referredBy;
  final String? referralCode;

  AppUserModel({
    required this.id,
    required this.email,
    this.organizationName,
    required this.subscription,
    required this.sessions,
    this.createdAt,
    this.updatedAt,
    this.phone,
    this.fullName,
    this.referredBy,
    this.referralCode,
  });

  /// Convert model → SQLite Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'organization_name': organizationName,
      'subscription': subscription ? 1 : 0,
      'sessions': sessions,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'phone': phone,
      'full_name': fullName,
      'referred_by': referredBy,
      'referral_code': referralCode,
    };
  }

  /// Convert SQLite Map → model
  factory AppUserModel.fromMap(Map<String, dynamic> map) {
    return AppUserModel(
      id: map['id'],
      email: map['email'],
      organizationName: map['organization_name'],
      subscription: map['subscription'] == 1,
      sessions: map['sessions'] ?? 0,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      phone: map['phone'],
      fullName: map['full_name'],
      referredBy: map['referred_by'],
      referralCode: map['referral_code'],
    );
  }


  factory AppUserModel.fromApi(Map<String, dynamic> json) {
  return AppUserModel(
    id: json['id'],
    email: json['email'],
    organizationName: json['organization_name'],
    subscription: json['subscription'] ?? false,
    sessions: json['sessions'] ?? 0,
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
    phone: json['phone'],
    fullName: json['full_name'],
    referredBy: json['referred_by'],
    referralCode: json['referral_code'],
  );
}
}
