// user model to retrive data from shared preferences
class UserModel {
  String id;
  String name;
  String email;
  String password;
  String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      };
}
