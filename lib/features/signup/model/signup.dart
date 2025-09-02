class SignupU {
  String? email;
  String? username;
  String? password;
  String? name;
  String? gender;
  String? role;
  String? contact;

  SignupU({
    this.email,
    this.username,
    this.password,
    this.name,
    this.gender,
    this.role,
    this.contact,
  });

  SignupU.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    username = json['username'];
    password = json['password'];
    name = json['name'];
    gender = json['gender'];
    role = json['role'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['role'] = this.role;
    data['contact'] = this.contact;
    return data;
  }
}
