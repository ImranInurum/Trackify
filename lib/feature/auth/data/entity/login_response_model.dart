class LoginResponseModel {
  bool? status;
  String? message;
  String? token;
  User? user;

  LoginResponseModel({this.status, this.message, this.token, this.user});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] is bool
        ? json['status']
        : json['status']?.toString().toLowerCase() == 'true';
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.mobileNumber,
    this.country,
    this.state,
    this.city,
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['mobile_number'] = mobileNumber;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    return data;
  }
}