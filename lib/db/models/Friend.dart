class Friend {

  final int? friend_id;
  final String name;
  final String email;
  final int user_id;

  Friend({
    this.friend_id,
    required this.name,
    required this.email,
    required this.user_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'friend_id' : friend_id,
      'name' : name,
      'email' : email,
      'user_id' : user_id
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
        friend_id: map['friend_id']?.toInt() ?? 0,
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        user_id: map['user_id'] ?? ''
    );
  }

}