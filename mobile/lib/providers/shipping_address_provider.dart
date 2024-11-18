import 'package:flutter/material.dart';
import 'package:fradel_spies/main.dart';
import 'package:fradel_spies/models/data/shipping_address_model.dart';
import 'package:fradel_spies/models/utilities/task_result_model.dart';
import 'package:fradel_spies/screens/shipping_addresses_screen.dart';
import 'package:fradel_spies/services/shipping_address_service.dart';
import 'package:fradel_spies/utilities/common_widget_utility.dart';
import 'package:fradel_spies/utilities/task_utility.dart';

class ShippingAddressProvider with ChangeNotifier {
  List<ShippingAddressModel>? _shippingAddresses;
  ShippingAddressModel? _primaryAddress;

  List<ShippingAddressModel>? get shippingAddresses => _shippingAddresses;
  ShippingAddressModel? get primaryAddress => _primaryAddress;

  set shippingAddresses(List<ShippingAddressModel>? value) {
    _shippingAddresses = value;
    notifyListeners();
  }

  set primaryAddress(ShippingAddressModel? value) {
    _primaryAddress = value;
    notifyListeners();
  }

  void init() async {
    fetchShippingAddresses();
  }

  Future<void> fetchShippingAddresses() async {
    final TaskResult result = await TaskUtility.run<List<ShippingAddressModel>>(task: ShippingAddressService.index);
    shippingAddresses = result.result as List<ShippingAddressModel>;
    primaryAddress = shippingAddresses?.where((ShippingAddressModel e) => e.isPrimary == true).firstOrNull;
  }

  void onAddAddress() async {
    late final ShippingAddressModel? data;
    late final TaskResult result;
    late final Map<String, dynamic> response;

    data = await showDialog<ShippingAddressModel?>(
      context: navigatorKey.currentContext!,
      builder: (_) => const AddUserShipmentAddressDialog(),
    );

    if (data == null) return;
    result = await TaskUtility.run<Map<String, dynamic>>(task: () => ShippingAddressService.store(data: data!));
    response = result.result;

    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    }

    fetchShippingAddresses();
  }

  void onEditAddress({required ShippingAddressModel source}) async {
    late final ShippingAddressModel? data;
    late final TaskResult result;
    late final Map<String, dynamic> response;

    data = await showDialog<ShippingAddressModel?>(
      context: navigatorKey.currentContext!,
      builder: (_) => EditUserShipmentAddressDialog(data: source),
    );

    if (data == null) return;
    result = await TaskUtility.run<Map<String, dynamic>>(task: () => ShippingAddressService.update(data: data!));
    response = result.result;

    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    }

    fetchShippingAddresses();
  }

  void onDeleteAddress({required ShippingAddressModel source}) async {
    late final bool? data;
    late final TaskResult result;
    late final Map<String, dynamic> response;

    data = await showDialog<bool?>(
      context: navigatorKey.currentContext!,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete confirmation'),
          content: const Text('Are you sure want to delete this data?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(navigatorKey.currentContext!),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(navigatorKey.currentContext!, true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (data == null) return;
    result = await TaskUtility.run<Map<String, dynamic>>(task: () => ShippingAddressService.delete(data: source));
    response = result.result;

    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    }

    fetchShippingAddresses();
  }
}
