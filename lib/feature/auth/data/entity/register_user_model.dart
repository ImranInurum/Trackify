class RegisterUserModel {
  bool? status;
  String? message;
  Data? data;

  RegisterUserModel({this.status, this.message, this.data});

  RegisterUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['role'] = this.role;
    data['inOnline'] = this.inOnline;
    data['isOtpVerified'] = this.isOtpVerified;
    data['mobile_number'] = this.mobileNumber;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['userProfile'] = this.userProfile;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
