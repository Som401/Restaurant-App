class User {
  final String name;
  final String phoneNumber;
  final String dialCode;
  final String isoCode;
  final String providerId;

  User({
    required this.name,
    required this.phoneNumber,
    required this.dialCode,
    required this.isoCode,
    required this.providerId,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      dialCode: json['dialCode'],
      isoCode: json['isoCode'],
      providerId: json['providerId']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'dialCode': dialCode,
        'isoCode': isoCode,
        'providerId': providerId,
      };

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      name: data['name'] as String,
      phoneNumber: data['phoneNumber'] as String,
      dialCode: data['dialCode'] as String,
      isoCode: data['isoCode'] as String,
      providerId: data['providerId'] as String,
    );
  }

  @override
  String toString() {
    return 'User{name: $name, phoneNumber: $phoneNumber, dialCode: $dialCode, isoCode: $isoCode, providerId: $providerId}';
  }
}
