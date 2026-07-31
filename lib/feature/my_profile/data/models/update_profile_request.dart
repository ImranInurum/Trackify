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
  final String countryCode;

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
    this.countryCode = '',
  });

  Map<String, dynamic> toJson() {
    String outMobile = mobileNumber;
    String outCountryCode = countryCode;

    if (outCountryCode.isEmpty && outMobile.isNotEmpty) {
      if (outMobile.startsWith('+91')) {
        outCountryCode = '+91';
        outMobile = outMobile.substring(3);
      } else if (outMobile.length > 10 && outMobile.startsWith('91')) {
        outCountryCode = '+91';
        outMobile = outMobile.substring(2);
      } else if (outMobile.startsWith('+')) {
        // Fallback for other country codes if space separated
        int spaceIdx = outMobile.indexOf(' ');
        if (spaceIdx != -1) {
          outCountryCode = outMobile.substring(0, spaceIdx);
          outMobile = outMobile.substring(spaceIdx + 1).replaceAll(' ', '');
        }
      }
    }

    return {
      'name': name,
      'middleName': middleName ?? '',
      'lastName': lastName ?? '',
      'mobile_number': outMobile,
      'email': email,
      'dateOfBirth': dateOfBirth ?? '',
      'country': country ?? '',
      'state': state ?? '',
      'city': city ?? '',
      'address': address ?? '',
      'countryCode': outCountryCode,
    };
  }
}
