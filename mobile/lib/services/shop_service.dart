import 'dart:convert';

import 'package:fradel_spies/models/data/shop_model.dart';

import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class ShopService {
  static String get _endpoint => 'shops';

  static Future<List<ShopModel>> index(
      {String searchTerm = '', String id = '', String userId = ''}) async {
    final HttpPayload payload = HttpPayload(
        target: '$_endpoint?searchTerm=$searchTerm&id=$id&userId=$userId');
    final HttpResponse<List<dynamic>> response =
        await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.body
        .map((dynamic data) => ShopModel.fromMap(data))
        .toList();
  }

  static Future<List<ShopModel>> p(
      {String searchTerm = '', String id = '', String userId = ''}) async {
    final HttpPayload payload = HttpPayload(
        target: '$_endpoint?searchTerm=$searchTerm&id=$id&userId=$userId');
    final HttpResponse<List<dynamic>> response =
        await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.body
        .map((dynamic data) => ShopModel.fromMap(data))
        .toList();
  }

  static Future<bool> update({required ShopModel shop}) async {
    try {
      final String target = '$_endpoint/${shop.id}';
      final HttpPayload payload =
          HttpPayload(target: target, data: jsonEncode(shop.toMap()));

      print('Sending data to: $target');
      print('Payload: ${jsonEncode(shop.toMap())}');

      final HttpResponse<Map<String, dynamic>> response =
          await HttpUtility.put(payload: payload);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        print(
            'Error: Failed to update shop. Status code: ${response.statusCode}');
        return false;
      }

      return true;
    } catch (e) {
      print('Error updating shop: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> post(
      {required Map<String, dynamic> data}) async {
    final HttpPayload payload =
        HttpPayload(target: 'shops', data: jsonEncode(data));
    final HttpResponse<Map<String, dynamic>> response =
        await HttpUtility.post(payload: payload);

    return response.body;
  }

  static Future<ShopModel> show({String id = ''}) async {
    final HttpPayload payload = HttpPayload(target: '$_endpoint/$id');
    final HttpResponse<Map<String, dynamic>> response =
        await HttpUtility.get<Map<String, dynamic>>(payload: payload);

    return ShopModel.fromMap(response.body);
  }
}
