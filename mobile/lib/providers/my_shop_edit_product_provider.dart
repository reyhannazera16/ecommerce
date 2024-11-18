import 'package:flutter/material.dart';
import 'package:fradel_spies/models/data/product_detail_model.dart';
import 'package:fradel_spies/models/data/product_model.dart';

import '../main.dart';
import '../models/data/product_sku_model.dart';
import '../models/utilities/task_result_model.dart';
import '../screens/my_shop_add_product_screen.dart';
import '../services/product_detail_service.dart';
import '../services/product_service.dart';
import '../services/product_sku_service.dart';
import '../utilities/common_widget_utility.dart';
import '../utilities/task_utility.dart';

class MyShopEditProductProvider with ChangeNotifier {
  final ProductModel product;

  MyShopEditProductProvider({required this.product});

  TextEditingController? _nameFormController;
  TextEditingController? _detailFormController;
  ProductDetailModel? _productDetail;

  List<ProductSkuModel> _productSkus = [];

  // Kontroler untuk nama produk
  TextEditingController get nameFormController =>
      _nameFormController ??= TextEditingController();
  // Kontroler untuk detail produk
  TextEditingController get detailFormController =>
      _detailFormController ??= TextEditingController();
  // Detail produk
  ProductDetailModel? get productDetail => _productDetail;
  // Daftar SKU produk
  List<ProductSkuModel> get productSkus => _productSkus ?? <ProductSkuModel>[];

  // Setter untuk detail produk
  set productDetail(ProductDetailModel? value) {
    _productDetail = value;
    notifyListeners();
  }

  // Setter untuk daftar SKU produk
  set productSkus(List<ProductSkuModel>? value) {
    _productSkus = value!;
    notifyListeners();
  }

  // Inisialisasi kontroler dan data
  void init() async {
    nameFormController.text = product.name ?? '';
    await _fetchProductDetail();
    await _fetchProductSkus();
  }

  // Mengambil detail produk
  Future<void> _fetchProductDetail() async {
    final TaskResult result = await TaskUtility.run<List<ProductDetailModel>>(
        task: () => ProductDetailService.index(productId: product.id ?? ''));
    productDetail = (result.result as List<ProductDetailModel>).first;
    detailFormController.text = productDetail?.description ?? '';
  }

  // Mengambil daftar SKU produk
  Future<void> _fetchProductSkus() async {
    final TaskResult result = await TaskUtility.run<List<ProductSkuModel>>(
        task: () => ProductSkuService.index(productId: product.id ?? ''));
    productSkus = result.result as List<ProductSkuModel>;
  }

  void onAddSku() {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController priceController = TextEditingController();
        TextEditingController quantityController = TextEditingController();

        return AlertDialog(
          title: Text('Tambah SKU'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: 'Harga',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Kuantitas',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Get and validate user input
                String name = nameController.text.trim();
                int? price = int.tryParse(priceController.text.trim());
                int? quantity = int.tryParse(quantityController.text.trim());

                if (name.isNotEmpty && price != null && quantity != null) {
                  // Add new SKU to the list if input is valid
                  _productSkus.add(ProductSkuModel(
                    name: name,
                    price: price,
                    qty: quantity,
                  ));
                  notifyListeners();
                } else {
                  // Show error message if input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Data tidak valid')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Menambahkan SKU baru
  /*void onAddSku() async {
    final ProductSkuModel? data = await showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => const MyShopAddSkuDialogWidget(),
    );
    if (data == null) return;

    List<ProductSkuModel> currentProductSkus = productSkus;
    currentProductSkus.add(data);
    productSkus = currentProductSkus;
  }
  */

// Metode untuk memperbarui SKU
  void updateSku(ProductSkuModel sku) async {
    late Map<String, dynamic> response;

    try {
      // Memanggil service untuk memperbarui atau menambahkan SKU
      if (sku.id != null) {
        response = await ProductSkuService.update(data: sku);
      } else {
        response = await ProductSkuService.store(data: sku);
      }

      // Tampilkan pesan berdasarkan respons
      if (response['message'] != null && response['message'].isNotEmpty) {
        CommonWidgetUtility.showSnackBar(message: response['message']);
      } else {
        CommonWidgetUtility.showSnackBar(
            message: 'SKU ${sku.name} berhasil diperbarui atau ditambahkan.');
      }

      notifyListeners(); // Memberitahu pendengar tentang perubahan
    } catch (e) {
      CommonWidgetUtility.showSnackBar(
          message: 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Memperbarui produk
  void onUpdateProduct() async {
    late TaskResult result;
    late Map<String, dynamic> response;

    // Memperbarui nama produk
    product.name = nameFormController.value.text;
    result = await TaskUtility.run<Map<String, dynamic>>(
        task: () => ProductService.update(data: product));
    response = result.result;

    // Cek respons dan tampilkan pesan untuk produk
    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    } else {
      // Tampilkan pesan jika pembaruan berhasil
      CommonWidgetUtility.showSnackBar(message: 'Produk berhasil diperbarui.');
    }

    // Memperbarui deskripsi produk
    productDetail?.description = detailFormController.value.text;
    result = await TaskUtility.run<Map<String, dynamic>>(
        task: () => ProductDetailService.update(data: productDetail!));
    response = result.result;

    // Cek respons dan tampilkan pesan untuk detail produk
    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    } else {
      // Tampilkan pesan jika deskripsi berhasil diperbarui
      CommonWidgetUtility.showSnackBar(
          message: 'Deskripsi produk berhasil diperbarui.');
    }

    // Memproses pembaruan SKU produk
    for (ProductSkuModel sku in productSkus) {
      // Cek apakah SKU memiliki ID
      if (sku.id != null) {
        // Jika SKU memiliki ID, lakukan update
        result = await TaskUtility.run<Map<String, dynamic>>(
            task: () => ProductSkuService.update(data: sku));
      } else {
        // Jika SKU tidak memiliki ID, tambahkan sebagai entri baru
        result = await TaskUtility.run<Map<String, dynamic>>(
            task: () => ProductSkuService.store(data: sku));
      }

      response = result.result;
      // Cek respons dan tampilkan pesan untuk setiap SKU
      if (response['message'] != '') {
        CommonWidgetUtility.showSnackBar(message: response['message']);
      } else {
        // Tampilkan pesan jika SKU berhasil diperbarui atau ditambahkan
        CommonWidgetUtility.showSnackBar(
            message: 'SKU ${sku.name} berhasil diperbarui atau ditambahkan.');
      }
    }
  }

  // Menghapus produk
  void onDeleteProduct() async {
    late TaskResult result;
    late Map<String, dynamic> response;

    product.isDeleted = true;
    result = await TaskUtility.run<Map<String, dynamic>>(
        task: () => ProductService.update(data: product));
    response = result.result;
    if (response['message'] != '') {
      CommonWidgetUtility.showSnackBar(message: response['message']);
    }

    Navigator.pop(navigatorKey.currentContext!);
  }
}
