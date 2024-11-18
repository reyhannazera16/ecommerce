import 'package:flutter/material.dart';
import 'package:fradel_spies/models/data/shop_model.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/data/product_model.dart';
import '../models/utilities/task_result_model.dart';
import '../screens/product_detail_screen.dart';
import '../services/product_service.dart';
import '../utilities/task_utility.dart';
import 'product_detail_provider.dart';
import '../models/data/product_image_model.dart';
import 'package:fradel_spies/services/product_image_service.dart';

class ShopProvider with ChangeNotifier {
  final ShopModel shop;

  ShopProvider({required this.shop});

  List<ProductModel>? _products; //
  List<ProductImageModel>? _productImages;

  // 01 - get data
  // 02 - add Data

  int? _productLength;

  List<ProductModel>? get products => _products;
  List<ProductImageModel> get productImages =>
      _productImages ??= <ProductImageModel>[];

  int get productLength => _productLength ?? 0;

  set products(List<ProductModel>? value) {
    _products = value;
    notifyListeners();
  }

  set productLength(int? value) {
    _productLength = value;
    notifyListeners();
  }

  void init() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    // Fetch the list of products
    final TaskResult productResult = await TaskUtility.run<List<ProductModel>>(
      task: () => ProductService.index(skip: productLength),
    );
    final List<ProductModel> currentState = products ?? <ProductModel>[];

    // Filter products by shopId
    final List<ProductModel> filteredProducts =
        (productResult.result as List<ProductModel>)
            .where((product) => product.shopId == shop.id)
            .toList();

    currentState.addAll(filteredProducts);
    products = currentState;
    productLength = products?.length ?? 0;

    // Fetch images for each product
    for (ProductModel product in products ?? <ProductModel>[]) {
      final TaskResult imageResult =
          await TaskUtility.run<List<ProductImageModel>>(
        task: () => ProductImageService.index(productId: product.id ?? ''),
      );

      // Add the images to the productImages list
      final List<ProductImageModel> images = productImages;
      images.addAll(imageResult.result);
      _productImages = images;
    }

    // Notify listeners after updating product images
    notifyListeners();
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
}
