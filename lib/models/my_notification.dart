class MyNotification {
  String? sId;
  String? notificationId;
  String? title;
  String? description;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MyNotification(
      {this.sId,
      this.notificationId,
      this.title,
      this.description,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MyNotification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notificationId = json['notificationId'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['notificationId'] = notificationId;
    data['title'] = title;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
