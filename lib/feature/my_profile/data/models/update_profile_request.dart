class UpdateProfileRequest {
  final String name;
  final String? middleName;
  final String? lastName;
  final String mobileNumber;
  final String email;
  final String? dateOfBirth;
  final String? country;
  final String? state;
  final String? city;
  final String? address;

  UpdateProfileRequest({
    required this.name,
    this.middleName,
    this.lastName,
    required this.mobileNumber,
    required this.email,
    this.dateOfBirth,
    this.country,
    this.state,
    this.city,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'middleName': middleName ?? '',
      'lastName': lastName ?? '',
      'mobile_number': mobileNumber,
      'email': email,
      'dateOfBirth': dateOfBirth ?? '',
      'country': country ?? '',
      'state': state ?? '',
      'city': city ?? '',
      'address': address ?? '',
    };
  }
}
