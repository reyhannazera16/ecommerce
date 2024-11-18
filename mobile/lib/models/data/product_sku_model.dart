class ProductSkuModel {
  int? id;
  String? productId;
  String? name;
  int? price;
  int? qty;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductSkuModel({
    this.id,
    this.productId,
    this.name,
    this.price,
    this.qty,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductSkuModel.fromMap(Map<String, dynamic> map) {
    return ProductSkuModel(
      id: map['id'],
      productId: map['product_id'],
      name: map['name'],
      price: map['price'],
      qty: map['qty'],
      isDeleted: map['is_deleted'] != null && map['is_deleted'] == 1,
      createdAt: DateTime.tryParse(map['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Menyertakan ID untuk keperluan update
      'product_id': productId,
      'name': name,
      'price': price,
      'qty': qty,
      'is_deleted': isDeleted == true ? 1 : 0,
      'created_at': createdAt?.toIso8601String(), // Menggunakan format ISO 8601
      'updated_at': updatedAt?.toIso8601String(), // Menggunakan format ISO 8601
    };
  }
}
