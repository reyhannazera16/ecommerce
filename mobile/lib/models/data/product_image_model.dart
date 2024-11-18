class ProductImageModel {
  int? id;
  String? productId;
  String? originalFileName;
  String? filePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductImageModel({
    this.id,
    this.productId,
    this.originalFileName,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImageModel.fromMap(Map<String, dynamic> map) {
    return ProductImageModel(
      id: map['id'],
      productId: map['product_id'],
      originalFileName: map['origina_file_name'],
      filePath: map['file_path'],
      createdAt: DateTime.tryParse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_id': productId,
      'original_file_name': originalFileName,
      'file_path': filePath,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
