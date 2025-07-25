class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? currency;
  final bool? isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.currency,
    this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      currency: json['currency'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "profileImage": profileImage,
      "currency": currency,
      "isActive": isActive,
    };
  }
}
