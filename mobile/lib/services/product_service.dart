import 'dart:convert';

import '../models/data/product_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class ProductService {
  static String get _endpoint => 'products';

  static Future<List<ProductModel>> index({String searchTerm = '', String id = '', String shopId = '', int skip = 0}) async {
    final HttpPayload payload = HttpPayload(target: '$_endpoint?searchTerm=$searchTerm&id=$id&shopId=$shopId&skip=$skip');
    final HttpResponse<List<dynamic>> response = await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.body.map((dynamic data) => ProductModel.fromMap(data)).toList();
  }

  static Future<List<ProductModel>> getFromShop({required int shopId, int skip = 0}) async {
    final HttpPayload payload = HttpPayload(target: '$_endpoint?skip=$skip');
    final HttpResponse response = await HttpUtility.get(payload: payload);

    return response.statusCode != 200 ? <ProductModel>[] : response.body.map((dynamic data) => ProductModel.fromMap(data)).toList();
  }

  static Future<Map<String, dynamic>> store({required ProductModel data}) async {
    final HttpPayload payload = HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response = await HttpUtility.post(payload: payload);

    return response.body;
  }

  static Future<Map<String, dynamic>> update({required ProductModel data}) async {
    final HttpPayload payload = HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response = await HttpUtility.put(payload: payload);

    return response.body;
  }
}
