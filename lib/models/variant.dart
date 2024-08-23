class Variant {
  String? sId;
  String? name;
  VariantTypeId? variantTypeId;
  String? createdAt;
  String? updatedAt;

  Variant(
      {this.sId,
      this.name,
      this.variantTypeId,
      this.createdAt,
      this.updatedAt});

  Variant.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    variantTypeId = json['variantTypeId'] != null
        ? VariantTypeId.fromJson(json['variantTypeId'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    if (variantTypeId != null) {
      data['variantTypeId'] = variantTypeId!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class VariantTypeId {
  String? sId;
  String? name;
  String? type;
  String? createdAt;
  String? updatedAt;

  VariantTypeId(
      {this.sId, this.name, this.type, this.createdAt, this.updatedAt});

  VariantTypeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
