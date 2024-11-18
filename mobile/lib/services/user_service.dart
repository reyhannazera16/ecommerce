import 'dart:convert';
import '../models/data/user_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class UserService {
  // Method untuk mendapatkan data pengguna
  static Future<UserModel> get() async {
    final HttpPayload payload = HttpPayload(target: 'user');
    final HttpResponse<Map<String, dynamic>> response =
        await HttpUtility.get<Map<String, dynamic>>(payload: payload);

    if (response.statusCode == 200 && response.body != null) {
      return UserModel.fromMap(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  // Method untuk memperbarui data pengguna
  static Future<bool> put({required UserModel data}) async {
    final HttpPayload payload = HttpPayload(
      target: 'user',
      data: jsonEncode(data.toMap()),
    );

    final HttpResponse<Map<String, dynamic>> response =
        await HttpUtility.put<Map<String, dynamic>>(payload: payload);

    if (response.statusCode == 200) {
      return true; // Indikasi bahwa pembaruan berhasil
    } else {
      throw Exception('Failed to update user data: ${response.body}');
    }
  }
}
