import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../providers/base_provider.dart';

class HttpUtility {
  static String get _baseUrl => 'http://103.158.196.80';
  static String get _bearerToken => navigatorKey.currentContext!.read<BaseProvider>().bearerToken ?? '';

  static Map<String, String> get _headers {
    return <String, String>{'Authorization': 'Bearer $_bearerToken', 'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  static Uri _generateUrl({required String target}) {
    return Uri.parse('$_baseUrl/api/$target');
  }

  static Future<HttpResponse<T>> get<T>({required HttpPayload payload}) async {
    final http.Response response = await http.get(_generateUrl(target: payload.target), headers: _headers);
    final T result = jsonDecode(response.body);

    return HttpResponse(
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase ?? '',
      body: result,
    );
  }

  static Future<HttpResponse<T>> post<T>({required HttpPayload payload}) async {
    final http.Response response = await http.post(_generateUrl(target: payload.target), headers: _headers, body: payload.data);
    final T result = jsonDecode(response.body);

    return HttpResponse(
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase ?? '',
      body: result,
    );
  }

  static Future<HttpResponse<T>> put<T>({required HttpPayload payload}) async {
    final http.Response response = await http.put(_generateUrl(target: payload.target), headers: _headers, body: payload.data);
    final T result = jsonDecode(response.body);

    return HttpResponse(
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase ?? '',
      body: result,
    );
  }

  static Future<HttpResponse<T>> delete<T>({required HttpPayload payload}) async {
    final http.Response response = await http.delete(_generateUrl(target: payload.target), headers: _headers, body: payload.data);
    final T result = jsonDecode(response.body);

    return HttpResponse(
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase ?? '',
      body: result,
    );
  }
}
