class LoginResponseModel {
  bool? status;
  String? message;
  String? token;
  User? user;

  LoginResponseModel({this.status, this.message, this.token, this.user});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    dynamic statusValue = json['status'] ?? json['success'];
    if (statusValue is String) {
      status = statusValue.toLowerCase() == 'true';
    } else if (statusValue is bool) {
      status = statusValue;
    } else {
      status = false;
    }
    
    message = json['message'];
    
    // Check if token is in 'data'
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      token = json['data']['token'] ?? json['token'];
      
      // If user is not present but userId is in data, create a partial user
      if (json['user'] != null) {
        user = User.fromJson(json['user']);
      } else if (json['data']['userId'] != null) {
        user = User(id: json['data']['userId']);
      }
    } else {
      token = json['token'];
      user = json['user'] != null ? User.fromJson(json['user']) : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? email;
  String? role;
  String? mobileNumber;
  String? country;
  String? state;
  String? city;
  String? middleName;
  String? lastName;
  String? dateOfBirth;
  String? address;
  String? userProfile;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.mobileNumber,
    this.country,
    this.state,
    this.city,
    this.middleName,
    this.lastName,
    this.dateOfBirth,
    this.address,
    this.userProfile,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['_id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    mobileNumber = json['mobile_number'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    address = json['address'];
    userProfile = json['userProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['mobile_number'] = mobileNumber;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['dateOfBirth'] = dateOfBirth;
    data['address'] = address;
    data['userProfile'] = userProfile;
    return data;
  }
}