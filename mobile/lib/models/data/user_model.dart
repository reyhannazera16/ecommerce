class UserModel {
  int? id;
  String? name;
  String? email;
  DateTime? emailVerifiedAt;
  String? password;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      emailVerifiedAt: map['email_verified_at'] != null ? DateTime.parse(map['email_verified_at']) : null,
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'password': password,
    };
  }
}
