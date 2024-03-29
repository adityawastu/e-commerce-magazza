// ignore_for_file: non_constant_identifier_names

class User {
  int user_id;
  String user_name;
  String user_number;
  String user_email;
  String user_password;

  User(
    this.user_id,
    this.user_name,
    this.user_number,
    this.user_email,
    this.user_password,
  );

  factory User.fromJson(Map<String, dynamic> json) => User(
        int.parse(json["user_id"]),
        json["user_name"],
        json["user_number"],
        json["user_email"],
        json["user_password"],
      );

  Map<String, dynamic> toJson() => {
        'user_id': user_id.toString(),
        'user_name': user_name,
        'user_number': user_number,
        'user_email': user_email,
        'user_password': user_password,
      };
}
