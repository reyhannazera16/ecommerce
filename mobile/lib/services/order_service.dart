import 'dart:convert';

import 'package:fradel_spies/models/data/order_model.dart';

import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class OrderService {
  static String get _endpoint => 'orders';

  static Future<List<OrderModel>> index() async {
    final HttpPayload payload = HttpPayload(target: _endpoint);
    final HttpResponse<List<dynamic>> response = await HttpUtility.get<List<dynamic>>(payload: payload);

    if (response.statusCode != 200) {
      return <OrderModel>[];
    }
    
    print('==========================================-------------------------------------------================================= \n');
    print('Response body: ${response.body}');
    print('Payment Method Name: ${response.body.first['payment_method_name']}');
    print('Delivery Service Name: ${response.body.first['delivery_service_name']}');
    
    return response.body.map((dynamic data) => OrderModel.fromMap(data)).toList();
  }

  static Future<Map<String, dynamic>> store({required OrderModel data}) async {
    try {
      final Map<String, dynamic> requestData = {
        'productId': data.productId,
        'paymentMethodId': data.paymentMethodId,
        'deliveryServiceId': data.deliveryServiceId,
        'shippingAddressId': data.shippingAddressId,
        'qty': data.qty ?? 1,
        'price': data.price ?? 0,
        'status': data.status ?? 'pending',
        'tracking_number': data.trackingNumber
      };

      print('Debug - Data yang dikirim ke server:');
      print(requestData);

      final HttpPayload payload =
          HttpPayload(target: 'orders', data: jsonEncode(requestData));

      print('Debug - Request URL: ${payload.target}');
      print('Debug - Encoded request body: ${payload.data}');

      final HttpResponse<Map<String, dynamic>> response =
          await HttpUtility.post(payload: payload);

      print('Debug - Response status code: ${response.statusCode}');
      print('Debug - Raw response body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to create order: ${response.body}');
      }

      return response.body;
    } catch (e) {
      print('Error di OrderService.store: $e');
      return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
    }
  }

  static Future<List<OrderModel>> getShopOrders(
      {required String shopId}) async {
    try {
      final HttpPayload payload = HttpPayload(
        target: '$_endpoint/shop/$shopId',
      );

      print('Fetching shop orders from: ${payload.target}');

      final HttpResponse<List<dynamic>> response =
          await HttpUtility.get<List<dynamic>>(payload: payload);
      
      if (response.statusCode != 200) return <OrderModel>[];

      return response.body.map((dynamic data) {
        print('Mapping shop order data: $data');
        return OrderModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error in OrderService.getShopOrders: $e');
      return <OrderModel>[];
    }
  }

  static Future<OrderModel?> updateStatus({
    required String id,
    required String status,
    String? trackingNumber,
  }) async {
    try {
      final Map<String, dynamic> requestData = {
        'id': id,
        'status': status,
        'tracking_number': trackingNumber ?? '',
      };

      print('Debug - Update Order Status Request:');
      print('URL: orders/update-status');
      print('Data: $requestData');

      final HttpPayload payload = HttpPayload(
        target: 'orders/update-status',
        data: jsonEncode(requestData)
      );

      final HttpResponse<Map<String, dynamic>> response = 
          await HttpUtility.post<Map<String, dynamic>>(payload: payload);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 && response.body['data'] != null) {
        return OrderModel.fromMap(response.body['data']);
      }

      throw Exception(response.body['message'] ?? 'Gagal mengupdate status order');
    } catch (e) {
      print('Error di OrderService.updateStatus: $e');
      rethrow;
    }
  }
}
