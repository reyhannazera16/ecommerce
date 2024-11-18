import 'dart:convert';


import '../models/data/shipping_address_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class ShippingAddressService {
  static String get _endpoint => 'shipping-addresses';

  static Future<List<ShippingAddressModel>> index() async {
    final HttpPayload payload = HttpPayload(target: _endpoint);
    final HttpResponse<List<dynamic>> response = await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.statusCode != 200 ? <ShippingAddressModel>[] : response.body.map((dynamic data) => ShippingAddressModel.fromMap(data)).toList();
  }

  static Future<Map<String, dynamic>> store({required ShippingAddressModel data}) async {
    final HttpPayload payload = HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response = await HttpUtility.post(payload: payload);

    return response.body;
  }

  static Future<Map<String, dynamic>> update({required ShippingAddressModel data}) async {
    final HttpPayload payload = HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response = await HttpUtility.put(payload: payload);

    return response.body;
  }

  static Future<Map<String, dynamic>> delete({required ShippingAddressModel data}) async {
    final HttpPayload payload = HttpPayload(target: _endpoint, data: jsonEncode(data.toMap()));
    final HttpResponse<Map<String, dynamic>> response = await HttpUtility.delete(payload: payload);

    return response.body;
  }
}
