class assignment {
  String? assignmentId;
  String? title;
  String? description;
  Subject? subject;
  String? teacher;
  String? deadline;
  String? faculty;
  String? semester;

  assignment({
    this.assignmentId,
    this.title,
    this.description,
    this.subject,
    this.teacher,
    this.deadline,
    this.faculty,
    this.semester,
  });

  assignment.fromJson(Map<String, dynamic> json) {
    assignmentId = json['assignment_id'];
    title = json['title'];
    description = json['description'];
    subject = json['subject'] != null
        ? new Subject.fromJson(json['subject'])
        : null;
    teacher = json['teacher'];
    deadline = json['deadline'];
    faculty = json['faculty'];
    semester = json['semester'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assignment_id'] = this.assignmentId;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.subject != null) {
      data['subject'] = this.subject!.toJson();
    }
    data['teacher'] = this.teacher;
    data['deadline'] = this.deadline;
    data['faculty'] = this.faculty;
    data['semester'] = this.semester;
    return data;
  }
}

class Subject {
  String? subjectId;
  String? name;

  Subject({this.subjectId, this.name});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['name'] = this.name;
    return data;
  }
}
