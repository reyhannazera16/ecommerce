import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../models/data/product_detail_model.dart';
import '../models/data/product_model.dart';
import '../models/data/product_sku_model.dart';
import '../models/data/shop_model.dart';
import '../models/utilities/task_result_model.dart';
import '../screens/home_screen.dart';
import '../screens/my_shop_add_product_screen.dart';
import '../services/product_detail_service.dart';
import '../services/product_image_service.dart';
import '../services/product_service.dart';
import '../services/product_sku_service.dart';
import '../utilities/common_widget_utility.dart';
import '../utilities/task_utility.dart';
import 'home_provider.dart';

class MyShopAddProductProvider with ChangeNotifier {
  final ShopModel shop;

  MyShopAddProductProvider({required this.shop});

  TextEditingController? _nameFormController;
  TextEditingController? _detailFormController;
  List<ProductSkuModel>? _productSkus;
  List<XFile>? _images;

  TextEditingController get nameFormController => _nameFormController ??= TextEditingController();
  TextEditingController get detailFormController => _detailFormController ??= TextEditingController();
  List<ProductSkuModel> get productSkus => _productSkus ??= <ProductSkuModel>[];
  List<XFile> get images => _images ??= <XFile>[];

  set productSkus(List<ProductSkuModel>? value) {
    _productSkus = value;
    notifyListeners();
  }

  set images(List<XFile> value) {
    _images = value;
    notifyListeners();
  }

  void init() {}

  void onAddSku() async {
    final ProductSkuModel? data = await showDialog(context: navigatorKey.currentContext!, builder: (_) => const MyShopAddSkuDialogWidget());
    if (data == null) return;

    List<ProductSkuModel> currentProductSkus = productSkus;
    currentProductSkus.add(data);
    productSkus = currentProductSkus;
  }

  void onAddProduct() async {
    final String generatedUuid = const Uuid().v4();

    ProductModel product = ProductModel(id: generatedUuid, name: nameFormController?.value.text ?? '', shopId: shop.id);
    // final ProductDetailModel productDetailModel = ProductDetailModel(description: detailFormController?.value.text ?? '');
    // final List<ProductSkuModel> savedProductSkus = productSkus;
    late TaskResult result;
    late Map<String, dynamic> response;

    result = await TaskUtility.run<Map<String, dynamic>>(task: () => ProductService.store(data: product));
    response = result.result;

    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    }

    // product = await _fetchProduct();
    final ProductDetailModel productDetailModel = ProductDetailModel(
      productId: product.id,
      description: detailFormController?.value.text ?? '',
    );

    result = await TaskUtility.run<Map<String, dynamic>>(task: () => ProductDetailService.store(data: productDetailModel));
    response = result.result;

    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    }

    final List<ProductSkuModel> savedProductSkus = productSkus
        .map((e) => ProductSkuModel(
              productId: product.id,
              name: e.name,
              price: e.price,
              qty: e.qty,
            ))
        .toList();

    for (ProductSkuModel sku in savedProductSkus) {
      result = await TaskUtility.run<Map<String, dynamic>>(task: () => ProductSkuService.store(data: sku));
      response = result.result;

      if (response['message'] != '') {
        CommonWidgetUtility.showSnackBar(message: response['message']);
      }
    }

    for (XFile image in images) {
      result = await TaskUtility.run(task: () => ProductImageService.upload(productId: generatedUuid, filePath: image.path));

      if (result.result) {
        CommonWidgetUtility.showSnackBar(message: 'Uploaded');
      } else {
        CommonWidgetUtility.showSnackBar(message: 'Error');
      }
    }

    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) => HomeProvider()..init(),
                  child: const HomeScreen(),
                )),
        (_) => false);
  }

  void onAddImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final List<XFile> current = images;

    if (image == null) return;
    current.add(image);
    images = current;
  }
}
