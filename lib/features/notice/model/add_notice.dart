class AddNotice {
  String? title;
  String? fileId;
  String? priority;
  String? category;
  List<String>? targetAudience;

  AddNotice({
    this.title,
    this.fileId,
    this.priority,
    this.category,
    this.targetAudience,
  });

  AddNotice.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    fileId = json['file_id'];
    priority = json['priority'];
    category = json['category'];
    targetAudience = json['target_audience'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['file_id'] = this.fileId;
    data['priority'] = this.priority;
    data['category'] = this.category;
    data['target_audience'] = this.targetAudience;
    return data;
  }
}
