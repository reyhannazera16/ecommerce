import '../models/data/delivery_service_model.dart';
import '../models/utilities/http_payload_model.dart';
import '../models/utilities/http_response_model.dart';
import '../utilities/http_utility.dart';

class DeliveryServiceService {
  static String get _endpoint => 'delivery-services';

  static Future<List<DeliveryServiceModel>> index({String id = ''}) async {
    final HttpPayload payload = HttpPayload(target: '$_endpoint?id=$id');
    final HttpResponse<List<dynamic>> response = await HttpUtility.get<List<dynamic>>(payload: payload);

    return response.statusCode != 200 ? <DeliveryServiceModel>[] : response.body.map((dynamic data) => DeliveryServiceModel.fromMap(data)).toList();
  }
}
