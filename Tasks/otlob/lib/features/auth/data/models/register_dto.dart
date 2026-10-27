class RegisterDto {
  final String displayName;
  final String email;
  final String phoneNumber;
  final String password;

  const RegisterDto({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }
}
