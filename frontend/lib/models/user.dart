class User {
  final String name;
  final String phoneNumber;

  User({required this.name, required this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        phoneNumber: json['phoneNumber']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
      };

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      name: data['name'] as String,
      phoneNumber: data['phoneNumber'] as String,
    );
  }
  @override
  String toString() {
    return 'User{name: $name, phoneNumber: $phoneNumber}';
  }
}
