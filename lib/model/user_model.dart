class UserModel {
  int? id;
  String? username;
  String? email;
  String? password;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    return map;
  }

  UserModel.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    username = map['username'];
    email = map['email'];
    password = map['password'];
  }
}
