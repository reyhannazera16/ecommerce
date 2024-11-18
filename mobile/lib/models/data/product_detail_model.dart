class ProductDetailModel {
  int? id;
  String? productId;
  String? description;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductDetailModel({
    this.id,
    this.productId,
    this.description,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductDetailModel.fromMap(Map<String, dynamic> map) {
    return ProductDetailModel(
      id: map['id'],
      productId: map['product_id'],
      description: map['description'],
      isDeleted: map['is_deleted'] != null && map['is_deleted'] == 1 ? true : false,
      createdAt: DateTime.tryParse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_id': productId,
      'description': description,
      'is_deleted': isDeleted,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
