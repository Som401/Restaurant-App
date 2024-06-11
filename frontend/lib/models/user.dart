class User {
  final String name;
  final String email;
  final String phoneNumber;

  User({required this.name, required this.email, required this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
      };

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      name: data['name'] as String,
      email: data['email'] as String,
      phoneNumber: data['phoneNumber'] as String,
    );
  }
  @override
  String toString() {
    return 'User{name: $name, email: $email, phoneNumber: $phoneNumber}';
  }
}
