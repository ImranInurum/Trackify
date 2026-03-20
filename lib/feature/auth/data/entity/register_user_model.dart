class RegisterUserModel {
  bool? status;
  String? message;
  String? userId;

  RegisterUserModel({this.status, this.message, this.userId});

  RegisterUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['userId'] = userId;
    return data;
  }
}
