import '../models/data/payment_method_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class PaymentMethodService {
  static String get _endpoint => 'payment-methods';

  static Future<List<PaymentMethodModel>> index({String id = ''}) async {
    final HttpPayload payload = HttpPayload(target: '$_endpoint?id=$id');
    final HttpResponse<List<dynamic>> response = await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.statusCode != 200 ? <PaymentMethodModel>[] : response.body.map((dynamic data) => PaymentMethodModel.fromMap(data)).toList();
  }
}
