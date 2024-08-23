class VariantType {
  String? name;
  String? type;
  String? sId;
  String? createdAt;
  String? updatedAt;

  VariantType({
    this.name,
    this.type,
    this.sId,
    this.createdAt,
    this.updatedAt,
  });

  VariantType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['type'] = type;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
