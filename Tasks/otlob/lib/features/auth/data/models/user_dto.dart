class UserDto {
  final String? displayName;
  final String? email;
  final String? token;

  const UserDto({
    this.displayName,
    this.email,
    this.token,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'token': token,
    };
  }
}
