import 'dart:convert';

import 'package:fradel_spies/main.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../models/data/product_image_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../providers/base_provider.dart';
import '../utilities/http_utility.dart';

class ProductImageService {
  static String get _endpoint => 'test';
  static String get _bearerToken => navigatorKey.currentContext!.read<BaseProvider>().bearerToken ?? '';

  static Future<List<ProductImageModel>> index({String id = '', String productId = ''}) async {
    final HttpPayload payload = HttpPayload(target: '$_endpoint?id=$id&product_id=$productId');
    final HttpResponse<List<dynamic>> response = await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.statusCode != 200 ? <ProductImageModel>[] : response.body.map((dynamic data) => ProductImageModel.fromMap(data)).toList();
  }

  static Future<bool> upload({
    required String productId,
    required String filePath,
  }) async {
    final MultipartRequest request = MultipartRequest(
      'POST',
      Uri.parse('http://103.158.196.80/api/product-images/uploads'),
    );

    request.headers['Authorization'] = 'Bearer $_bearerToken';

    request.fields['product_id'] = productId;

    request.files.add(await MultipartFile.fromPath('file', filePath));

    final StreamedResponse response = await request.send();

    return response.statusCode == 200;
  }
}
