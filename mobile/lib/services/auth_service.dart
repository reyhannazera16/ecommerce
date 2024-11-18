import 'dart:convert';

import 'package:fradel_spies/models/utilities/http_payload_model.dart';
import 'package:fradel_spies/models/utilities/http_response_model.dart';
import 'package:fradel_spies/utilities/http_utility.dart';

class AuthService {
  static Future<String> register({required Map<String, dynamic> data}) async {
    final HttpPayload payload = HttpPayload(target: 'register', data: jsonEncode(data));
    final HttpResponse response = await HttpUtility.post(payload: payload);

    return response.statusCode != 201 ? '' : response.body['token'];
  }

  static Future<String> login({required Map<String, dynamic> data}) async {
    final HttpPayload payload = HttpPayload(target: 'login', data: jsonEncode(data));
    final HttpResponse response = await HttpUtility.post(payload: payload);

    return response.statusCode != 200 ? '' : response.body['token'];
  }
}
