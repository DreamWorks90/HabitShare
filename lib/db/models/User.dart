class User {

  final int? user_id;
  final String name;
  final String email;
  final String password;

  User({
    this.user_id,
    required this.name,
    required this.email,
    required this.password
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id' : user_id,
      'name' : name,
      'email' : email,
      'password' : password
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        user_id: map['user_id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? ''
    );
  }

}