// import 'package:fradel_spies/models/product_sku_model.dart';

// class ProductModel {
//   final int id;
//   final String name;
//   final List<ProductSkuModel> skus;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.skus,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory ProductModel.fromMap(Map<String, dynamic> map) {
//     return ProductModel(
//       id: map['id'],
//       name: map['name'],
//       skus: List<ProductSkuModel>.from(map['skus'].map((e) => ProductSkuModel.fromMap(e))),
//       createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
//       updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'skus': skus,
//       'createdAt': createdAt.toString(),
//       'updatedAt': updatedAt.toString(),
//     };
//   }
// }

class ProductModel {
  String? id;
  String? name;
  int? price;
  int? shopId;
  bool? isActive;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.shopId,
    this.isActive,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      shopId: map['shop_id'],
      isActive:
          map['is_active'] != null && map['is_active'] == 1 ? true : false,
      isDeleted:
          map['is_deleted'] != null && map['is_deleted'] == 1 ? true : false,
      createdAt: DateTime.tryParse(map['created_at']),
      updatedAt: DateTime.tryParse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'shopId': shopId,
      'is_active': isActive != null && isActive! ? 1 : 0,
      'is_deleted': isDeleted != null && isDeleted! ? 1 : 0,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
