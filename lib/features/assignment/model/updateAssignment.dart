class UpdateAssignment {
  String? title;
  String? description;
  String? subjectName;
  String? semester;
  String? faculty;

  UpdateAssignment({
    this.title,
    this.description,
    this.subjectName,
    this.semester,
    this.faculty,
  });

  UpdateAssignment.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    subjectName = json['subjectName'];
    semester = json['semester'];
    faculty = json['faculty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['subjectName'] = this.subjectName;
    data['semester'] = this.semester;
    data['faculty'] = this.faculty;
    return data;
  }
}
