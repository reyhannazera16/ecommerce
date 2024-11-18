import 'dart:convert';

import '../models/data/product_sku_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class ProductSkuService {
  static String get _endpoint => 'product-skus';

  // Metode untuk mendapatkan daftar SKU produk
  static Future<List<ProductSkuModel>> index(
      {String id = '', String productId = ''}) async {
    final HttpPayload payload =
        HttpPayload(target: '$_endpoint?id=$id&productId=$productId');
    final HttpResponse<List<dynamic>> response =
        await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.statusCode != 200
        ? <ProductSkuModel>[]
        : response.body
            .map((dynamic data) => ProductSkuModel.fromMap(data))
            .toList();
  }

  // Metode untuk menambahkan SKU produk
  static Future<Map<String, dynamic>> store(
      {required ProductSkuModel data}) async {
    final HttpPayload payload =
        HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response =
        await HttpUtility.post(payload: payload);

    return response.body;
  }

  // Metode untuk memperbarui SKU produk
  static Future<Map<String, dynamic>> update(
      {required ProductSkuModel data}) async {
    if (data.id == null) {
      throw ArgumentError(
          "ID tidak boleh null untuk memperbarui data SKU produk.");
    }

    final String target =
        '$_endpoint/${data.id}'; // Menggunakan ID untuk memperbarui data tertentu
    final HttpPayload payload =
        HttpPayload(target: target, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response =
        await HttpUtility.put(payload: payload);

    return response.body;
  }
}
