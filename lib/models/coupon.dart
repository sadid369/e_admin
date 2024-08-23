class Coupon {
  String? sId;
  String? couponCode;
  String? discountType;
  double? discountAmount;
  double? minimumPurchaseAmount;
  String? endDate;
  String? status;
  CatRef? applicableCategory;
  CatRef? applicableSubCategory;
  CatRef? applicableProduct;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Coupon(
      {this.sId,
      this.couponCode,
      this.discountType,
      this.discountAmount,
      this.minimumPurchaseAmount,
      this.endDate,
      this.status,
      this.applicableCategory,
      this.applicableSubCategory,
      this.applicableProduct,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Coupon.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    couponCode = json['couponCode'];
    discountType = json['discountType'];
    discountAmount = json['discountAmount']?.toDouble();
    minimumPurchaseAmount = json['minimumPurchaseAmount']?.toDouble();
    endDate = json['endDate'];
    status = json['status'];
    applicableCategory = json['applicableCategory'] != null
        ? CatRef.fromJson(json['applicableCategory'])
        : null;
    applicableSubCategory = json['applicableSubCategory'] != null
        ? CatRef.fromJson(json['applicableSubCategory'])
        : null;
    applicableProduct = json['applicableProduct'] != null
        ? CatRef.fromJson(json['applicableProduct'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['couponCode'] = couponCode;
    data['discountType'] = discountType;
    data['discountAmount'] = discountAmount;
    data['minimumPurchaseAmount'] = minimumPurchaseAmount;
    data['endDate'] = endDate;
    data['status'] = status;
    if (applicableCategory != null) {
      data['applicableCategory'] = applicableCategory!.toJson();
    }
    if (applicableSubCategory != null) {
      data['applicableSubCategory'] = applicableSubCategory!.toJson();
    }
    if (applicableProduct != null) {
      data['applicableProduct'] = applicableProduct!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class CatRef {
  String? sId;
  String? name;

  CatRef({this.sId, this.name});

  CatRef.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
