import 'package:flutter/material.dart';
import 'package:fradel_spies/models/data/product_model.dart';
import 'package:fradel_spies/models/data/shop_model.dart';
import 'package:fradel_spies/models/utilities/task_result_model.dart';
import 'package:fradel_spies/providers/my_shop_add_product_provider.dart';
import 'package:fradel_spies/screens/my_shop_add_product_screen.dart';
import 'package:fradel_spies/screens/my_shop_screen.dart';
import 'package:fradel_spies/services/product_service.dart';
import 'package:fradel_spies/services/shop_service.dart';
import 'package:fradel_spies/utilities/task_utility.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/data/product_image_model.dart';
import '../screens/product_detail_screen.dart';
import '../services/product_image_service.dart';
import 'product_detail_provider.dart';

class MyShopProvider with ChangeNotifier {
  PageController? _pageController;
  int? _selectedIndex;
  ShopModel? _shop;
  bool? _hasShop;
  bool? _wantToCreate;
  List<ProductModel>? _products;
  List<ProductImageModel>? _productImages;

  PageController? get pageController => _pageController;
  int get selectedIndex => _selectedIndex ??= 0;
  ShopModel? get shop => _shop;
  bool? get hasShop => _hasShop;
  bool get wantToCreate => _wantToCreate ?? false;
  List<ProductModel>? get products => _products;
  List<ProductImageModel> get productImages =>
      _productImages ??= <ProductImageModel>[];

  set pageController(PageController? value) {
    _pageController = value;
    notifyListeners();
  }

  set selectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }

  set shop(ShopModel? value) {
    _shop = value;
    notifyListeners();
  }

  set hasShop(bool? value) {
    _hasShop = value;
    notifyListeners();
  }

  set wantToCreate(bool? value) {
    _wantToCreate = value;
    notifyListeners();
  }

  set products(List<ProductModel>? value) {
    _products = value;
    notifyListeners();
  }

  set productImages(List<ProductImageModel>? value) {
    _productImages = value;
    notifyListeners();
  }

  Future<void> init() async {
    pageController = PageController();

    pageController?.addListener(() {
      selectedIndex = pageController?.page?.round();
    });

    await fetchMyShop();
    if (hasShop!) await fetchProducts();
  }

  Future<void> fetchMyShop() async {
    final TaskResult result = await TaskUtility.run<List<ShopModel>>(
        task: () => ShopService.p(userId: 'me'));
    final List<ShopModel> data = result.result as List<ShopModel>;

    shop = data.firstOrNull ?? ShopModel();
    hasShop = shop?.name != null;
  }

  Future<void> fetchProducts() async {
    final TaskResult result = await TaskUtility.run<List<ProductModel>>(
        task: () => ProductService.index(shopId: shop?.id.toString() ?? ''));
    products = result.result as List<ProductModel>;

    for (ProductModel product in products ?? <ProductModel>[]) {
      final TaskResult p = await TaskUtility.run<List<ProductImageModel>>(
          task: () => ProductImageService.index(productId: product.id ?? ''));
      final List<ProductImageModel> x = productImages;
      x.addAll(p.result);
      productImages = x;
    }
  }

  void onNavigationBarTapped({required int value}) {
    selectedIndex = value;
    pageController?.animateToPage(selectedIndex ?? 0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void onProductTapped({required ProductModel product}) => Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) {
            return ChangeNotifierProvider(
              create: (_) => ProductDetailProvider(product: product)..init(),
              child: const ProductDetailScreen(),
            );
          },
        ),
      );

  Future<void> updateShopName(String newName) async {
    if (shop == null) return;

    try {
      // Memperbarui nama toko secara langsung
      shop!.name = newName;

      // Memanggil service untuk memperbarui nama toko di server
      final bool success = await ShopService.update(shop: shop!);

      if (success) {
        notifyListeners(); // Memperbarui UI
        debugPrint('Shop name updated successfully');
      } else {
        debugPrint('Failed to update shop name');
      }
    } catch (e) {
      debugPrint('Error updating shop name: $e');
    }
  }

  void onAddProduct() => Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) {
            return ChangeNotifierProvider(
              create: (_) => MyShopAddProductProvider(shop: shop!)..init(),
              child: const MyShopAddProductScreen(),
            );
          },
        ),
      );
}
