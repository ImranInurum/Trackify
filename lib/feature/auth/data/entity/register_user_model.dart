class RegisterUserModel {
  bool? status;
  String? message;
  Data? data;

  RegisterUserModel({this.status, this.message, this.data});

  RegisterUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? name;
  String? email;
  String? password;
  String? role;
  bool? inOnline;
  bool? isOtpVerified;
  String? mobileNumber;
  String? country;
  String? state;
  String? city;
  String? userProfile;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.name,
    this.email,
    this.password,
    this.role,
    this.inOnline,
    this.isOtpVerified,
    this.mobileNumber,
    this.country,
    this.state,
    this.city,
    this.userProfile,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    inOnline = json['inOnline'];
    isOtpVerified = json['isOtpVerified'];
    mobileNumber = json['mobile_number'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    userProfile = json['userProfile'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['inOnline'] = inOnline;
    data['isOtpVerified'] = isOtpVerified;
    data['mobile_number'] = mobileNumber;
    data['country'] = country;
    data['state'] = state;
    data['city'] = city;
    data['userProfile'] = userProfile;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
