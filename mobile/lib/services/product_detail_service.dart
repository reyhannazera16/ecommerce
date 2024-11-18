import 'dart:convert';

import '../models/data/product_detail_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class ProductDetailService {
  static String get _endpoint => 'product-details';

  static Future<List<ProductDetailModel>> index({String productId = ''}) async {
    final HttpPayload payload = HttpPayload(target: '$_endpoint?productId=$productId');
    final HttpResponse<List<dynamic>> response = await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.statusCode != 200 ? <ProductDetailModel>[] : response.body.map((dynamic data) => ProductDetailModel.fromMap(data)).toList();
  }

  static Future<Map<String, dynamic>> store({required ProductDetailModel data}) async {
    final HttpPayload payload = HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response = await HttpUtility.post(payload: payload);

    return response.body;
  }

  static Future<Map<String, dynamic>> update({required ProductDetailModel data}) async {
    final HttpPayload payload = HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response = await HttpUtility.put(payload: payload);

    return response.body;
  }
}
