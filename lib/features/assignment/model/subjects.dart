class Subjects {
  String? subjectId;
  String? name;
  String? code;
  String? description;
  int? credits;
  String? createdAt;
  String? updatedAt;

  Subjects({
    this.subjectId,
    this.name,
    this.code,
    this.description,
    this.credits,
    this.createdAt,
    this.updatedAt,
  });

  Subjects.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    credits = json['credits'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['credits'] = this.credits;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
