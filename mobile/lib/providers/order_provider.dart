import 'package:flutter/material.dart';
import 'package:fradel_spies/main.dart';
import 'package:fradel_spies/models/data/product_sku_model.dart';
import 'package:fradel_spies/providers/home_provider.dart';
import 'package:fradel_spies/screens/home_screen.dart';
import 'package:provider/provider.dart';

import '../models/data/delivery_service_model.dart';
import '../models/data/order_model.dart';
import '../models/data/payment_method_model.dart';
import '../models/data/product_model.dart';
import '../models/data/shipping_address_model.dart';
import '../models/utilities/task_result_model.dart';
import '../services/delivery_service_service.dart';
import '../services/order_service.dart';
import '../services/payment_method_service.dart';
import '../services/product_service.dart';
import '../services/shipping_address_service.dart';
import '../utilities/common_widget_utility.dart';
import '../utilities/task_utility.dart';

class OrderProvider with ChangeNotifier {
  final ProductSkuModel productSku;

  OrderProvider({required this.productSku}) {
    _qty = 1;
    print('Debug - Initial qty: $_qty');
  }

  int? _qty;
  ProductModel? _product;
  List<DeliveryServiceModel>? _deliveryServices;
  DeliveryServiceModel? _selectedDeliveryService;
  List<PaymentMethodModel>? _paymentMethods;
  PaymentMethodModel? _selectedPaymentMethod;
  List<ShippingAddressModel>? _shippingAddresses;
  ShippingAddressModel? _selectedShippingAddress;

  int get qty => _qty ??= 1;
  ProductModel? get product => _product;
  List<DeliveryServiceModel>? get deliveryServices => _deliveryServices;
  DeliveryServiceModel? get selectedDeliveryService => _selectedDeliveryService;
  List<PaymentMethodModel>? get paymentMethods => _paymentMethods;
  PaymentMethodModel? get selectedPaymentMethod => _selectedPaymentMethod;
  List<ShippingAddressModel>? get shippingAddresses => _shippingAddresses;
  ShippingAddressModel? get selectedShippingAddress => _selectedShippingAddress;

  set qty(int value) {
    print('Debug - Setting qty to: $value');
    _qty = value;
    notifyListeners();
  }

  set product(ProductModel? value) {
    _product = value;
    notifyListeners();
  }

  set deliveryServices(List<DeliveryServiceModel>? value) {
    _deliveryServices = value;
    notifyListeners();
  }

  set selectedDeliveryService(DeliveryServiceModel? value) {
    _selectedDeliveryService = value;
    notifyListeners();
  }

  set paymentMethods(List<PaymentMethodModel>? value) {
    _paymentMethods = value;
    notifyListeners();
  }

  set selectedPaymentMethod(PaymentMethodModel? value) {
    _selectedPaymentMethod = value;
    notifyListeners();
  }

  set shippingAddresses(List<ShippingAddressModel>? value) {
    _shippingAddresses = value;
    notifyListeners();
  }

  set selectedShippingAddress(ShippingAddressModel? value) {
    _selectedShippingAddress = value;
    notifyListeners();
  }

  void init() {
    _fetchProduct();
    _fetchDeliveryServices();
    _fetchPaymentMethods();
    _fetchShippingAddresses();
  }

  Future<void> _fetchProduct() async {
    final TaskResult result = await TaskUtility.run<List<ProductModel>>(
        task: () => ProductService.index(id: '${productSku.productId}'));

    product = (result.result as List<ProductModel>).firstOrNull;
  }

  Future<void> _fetchDeliveryServices() async {
    final TaskResult result = await TaskUtility.run<List<DeliveryServiceModel>>(
        task: DeliveryServiceService.index);

    deliveryServices = result.result as List<DeliveryServiceModel>;
  }

  Future<void> _fetchPaymentMethods() async {
    final TaskResult result = await TaskUtility.run<List<PaymentMethodModel>>(
        task: PaymentMethodService.index);

    paymentMethods = result.result as List<PaymentMethodModel>;
  }

  Future<void> _fetchShippingAddresses() async {
    try {
      final TaskResult result =
          await TaskUtility.run<List<ShippingAddressModel>>(
              task: ShippingAddressService.index);

      if (result.result != null && (result.result as List).isNotEmpty) {
        shippingAddresses = result.result;
        selectedShippingAddress = shippingAddresses?.first;
      }
    } catch (e) {
      print('Error saat mengambil alamat: $e');
    }
  }

  void onDecrement() {
    if (qty > 1) {
      qty -= 1;
    }
  }

  void onIncrement() {
    qty += 1;
  }

  void onSelectAddress() async {
    selectedShippingAddress = await showDialog<ShippingAddressModel?>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih alamat'),
          children: shippingAddresses?.map((e) {
            return SimpleDialogOption(
              child: GestureDetector(
                onTap: () => Navigator.pop(context, e),
                child: Text(e.address ?? 'Tidak dikenal'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void setSelectedPaymentMethodByName(String? name) {
    _selectedPaymentMethod = paymentMethods?.firstWhere(
      (method) => method.name == name,
    );
    notifyListeners();
  }

  void onSelectDeliveryService() async {
    selectedDeliveryService = await showDialog<DeliveryServiceModel?>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih jasa antar'),
          children: deliveryServices?.map((e) {
            return SimpleDialogOption(
              child: GestureDetector(
                onTap: () => Navigator.pop(context, e),
                child: Text(e.name ?? 'Tidak dikenal'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void onSelectPaymentMethod() async {
    selectedPaymentMethod = await showDialog<PaymentMethodModel?>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih jasa antar'),
          children: paymentMethods?.map((e) {
            return SimpleDialogOption(
              child: GestureDetector(
                onTap: () => Navigator.pop(context, e),
                child: Text(e.name ?? 'Tidak dikenal'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void onOrderTapped() async {
    try {
      if (selectedShippingAddress == null) {
        CommonWidgetUtility.showSnackBar(message: 'Pilih alamat pengiriman');
        return;
      }

      print('Debug - Qty yang akan dikirim: $_qty');
      print('Debug - Price yang akan dikirim: ${productSku.price}');

      final OrderModel orderData = OrderModel(
          productId: product!.id,
          paymentMethodId: selectedPaymentMethod!.id.toString(),
          deliveryServiceId: selectedDeliveryService!.id.toString(),
          shippingAddressId: selectedShippingAddress!.id.toString(),
          qty: _qty,
          price: productSku.price,
          status: 'pending');

      print('Debug - Full order data yang akan dikirim:');
      print(orderData.toMap());

      final TaskResult result = await TaskUtility.run<Map<String, dynamic>>(
          task: () => OrderService.store(data: orderData));

      print('Debug - Response dari server:');
      print(result.result);

      if (result.result['message'] == 'Order successfully created') {
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                      create: (_) => HomeProvider()..init(),
                      child: const HomeScreen(),
                    )),
            (_) => false);
        CommonWidgetUtility.showSnackBar(message: 'Pesanan berhasil dibuat');
      } else {
        CommonWidgetUtility.showSnackBar(
            message: result.result['message'] ?? 'Gagal membuat pesanan');
      }
    } catch (e) {
      print('Error saat membuat pesanan: $e');
      CommonWidgetUtility.showSnackBar(
          message: 'Terjadi kesalahan saat membuat pesanan');
    }
  }
}
