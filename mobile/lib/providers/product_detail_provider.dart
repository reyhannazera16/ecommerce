import 'package:flutter/material.dart';
import 'package:fradel_spies/main.dart';
import 'package:fradel_spies/models/data/product_detail_model.dart';
import 'package:fradel_spies/models/data/product_model.dart';
import 'package:fradel_spies/models/data/product_sku_model.dart';
import 'package:fradel_spies/models/data/shop_model.dart';
import 'package:fradel_spies/models/utilities/task_result_model.dart';
import 'package:fradel_spies/providers/order_provider.dart';
import 'package:fradel_spies/services/product_detail_service.dart';
import 'package:fradel_spies/services/product_sku_service.dart';
import 'package:fradel_spies/services/shop_service.dart';
import 'package:fradel_spies/utilities/task_utility.dart';
import 'package:provider/provider.dart';

import '../models/data/order_model.dart';
import '../models/data/product_image_model.dart';
import '../screens/order_product_screen.dart';
import '../screens/shop_screen.dart';
import '../services/order_service.dart';
import '../services/product_image_service.dart';
import 'shop_provider.dart';

class ProductDetailProvider with ChangeNotifier {
  final ProductModel product;

  ProductDetailProvider({required this.product});

  ProductDetailModel? _productDetail;
  List<ProductSkuModel>? _productSkus;
  int? _activeSku;
  ShopModel? _shop;
  List<ProductImageModel>? _productImages;

  ProductDetailModel? get productDetail => _productDetail;
  List<ProductSkuModel>? get productSkus => _productSkus;
  int? get activeSku => _activeSku;
  ShopModel? get shop => _shop;
  List<ProductImageModel> get productImages => _productImages ??= <ProductImageModel>[];

  set productDetail(ProductDetailModel? value) {
    _productDetail = value;
    notifyListeners();
  }

  set productSkus(List<ProductSkuModel>? value) {
    _productSkus = value;
    notifyListeners();
  }

  set activeSku(int? value) {
    _activeSku = value;
    notifyListeners();
  }

  set shop(ShopModel? value) {
    _shop = value;
    notifyListeners();
  }

  set productImages(List<ProductImageModel>? value) {
    _productImages = value;
    notifyListeners();
  }

  Future<void> init() async {
    fetchProductDetail();
    fetchProductSkus();
    fetchShop();

    final TaskResult p = await TaskUtility.run<List<ProductImageModel>>(task: () => ProductImageService.index(productId: product.id ?? ''));
    final List<ProductImageModel> x = productImages;
    x.addAll(p.result);
    productImages = x;
  }

  Future<void> fetchProductDetail() async {
    final TaskResult result = await TaskUtility.run<List<ProductDetailModel>>(task: () => ProductDetailService.index(productId: product.id.toString()));
    productDetail = (result.result as List<ProductDetailModel>).first;
  }

  Future<void> fetchProductSkus() async {
    final TaskResult result = await TaskUtility.run<List<ProductSkuModel>>(task: () => ProductSkuService.index(productId: product.id.toString()));
    productSkus = result.result as List<ProductSkuModel>;
    activeSku = 0;
  }

  Future<void> fetchShop() async {
    final TaskResult result = await TaskUtility.run<List<ShopModel>>(task: () => ShopService.index(id: product.shopId.toString()));
    shop = (result.result as List<ShopModel>).first;
  }

  void onSkuSelected({required ProductSkuModel sku}) {
    activeSku = productSkus?.indexOf(sku);
  }

  void onShopTapped() {
    Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) => ShopProvider(shop: shop!)..init(),
                  child: const ShopScreen(),
                )));
  }

  void onOrderTapped() {
    Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) => OrderProvider(productSku: productSkus!.elementAt(activeSku!))..init(),
                  child: const OrderProductScreen(),
                )));
  }

  Future<bool> createOrder(OrderModel order) async {
    try {
      print('Debug - Creating order with data:');
      print('Qty: ${order.qty}');
      print('Price: ${order.price}');
      
      final TaskResult result = await TaskUtility.run<Map<String, dynamic>>(
        task: () => OrderService.store(data: order)
      );
      
      return result.result != null;
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }
}
