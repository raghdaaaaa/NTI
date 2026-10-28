class AddressDto {
  final String firstName;
  final String lastName;
  final String street;
  final String city;
  final String country;

  const AddressDto({
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.city,
    required this.country,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) => AddressDto(
    firstName: json['firstName']?.toString() ?? '',
    lastName: json['lastName']?.toString() ?? '',
    street: json['street']?.toString() ?? '',
    city: json['city']?.toString() ?? '',
    country: json['country']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'street': street,
    'city': city,
    'country': country,
  };
}
