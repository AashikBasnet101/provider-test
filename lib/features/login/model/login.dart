class LoginU {
  String? email;
  String? password;
  String? deviceToken;

  LoginU({this.email, this.password, this.deviceToken});

  LoginU.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    deviceToken = json['deviceToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['deviceToken'] = this.deviceToken;
    return data;
  }
}
