import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fradel_spies/main.dart';
import 'package:fradel_spies/models/data/order_model.dart';
import 'package:fradel_spies/models/data/product_image_model.dart';
import 'package:fradel_spies/models/data/shop_model.dart';
import 'package:fradel_spies/models/utilities/task_result_model.dart';
import 'package:fradel_spies/providers/shipping_address_provider.dart';
import 'package:fradel_spies/screens/shipping_addresses_screen.dart';
import 'package:fradel_spies/services/order_service.dart';
import 'package:fradel_spies/services/product_image_service.dart';
import 'package:fradel_spies/services/product_service.dart';
import 'package:fradel_spies/services/user_service.dart';
import 'package:fradel_spies/models/utilities/http_response_model.dart';
import 'package:fradel_spies/utilities/sqlite_utility.dart';
import 'package:fradel_spies/utilities/task_utility.dart';
import 'package:provider/provider.dart';

import '../models/data/order_status_model.dart';
import '../models/data/product_model.dart';
import '../models/data/user_model.dart';
import '../screens/my_shop_screen.dart';
import '../screens/product_detail_screen.dart';
import '../services/shop_service.dart';
import 'my_shop_provider.dart';
import 'product_detail_provider.dart';

class HomeProvider with ChangeNotifier {
  PageController? _pageController;
  ScrollController? _scrollController;
  SearchController? _searchController;
  MapController? _mapController;
  int? _selectedIndex;
  String? _searchTerm;
  UserModel? _user;
  List<ProductModel>? _products;
  List<ProductImageModel>? _productImages;
  ShopModel? _shop;
  TabController? _tabController;
  //
  List<OrderModel>? _orders;
  List<OrderModel>? _shopOrders;

  PageController? get pageController => _pageController;
  ScrollController? get scrollController => _scrollController;
  SearchController? get searchController => _searchController;
  MapController? get mapController => _mapController;
  int? get selectedIndex => _selectedIndex;
  String? get searchTerm => _searchTerm;
  UserModel? get user => _user;
  List<ProductModel>? get products => _products;
  List<ProductImageModel> get productImages =>
      _productImages ??= <ProductImageModel>[];
  ShopModel? get shop => _shop;
  TabController? get tabController => _tabController;
  // Pembelian
  List<OrderModel>? get orders => _orders;
  // Penjualan
  List<OrderModel>? get shopOrders => _shopOrders;

  set pageController(PageController? value) {
    _pageController = value;
    notifyListeners();
  }

  set scrollController(ScrollController? value) {
    _scrollController = value;
    notifyListeners();
  }

  set searchController(SearchController? value) {
    _searchController = value;
    notifyListeners();
  }

  set mapController(MapController? value) {
    _mapController = value;
    notifyListeners();
  }

  set selectedIndex(int? value) {
    _selectedIndex = value;
    notifyListeners();
  }

  set searchTerm(String? value) {
    _searchTerm = value;
    notifyListeners();
  }

  set user(UserModel? value) {
    _user = value;
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

  set orders(List<OrderModel>? value) {
    _orders = value;
    notifyListeners();
  }

  set shop(ShopModel? value) {
    _shop = value;
    notifyListeners();
  }

  set tabController(TabController? value) {
    _tabController = value;
    notifyListeners();
  }

  void init() async {
    SystemChrome.restoreSystemUIOverlays();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFFFFFFF),
      statusBarIconBrightness: Brightness.dark,
    ));

    pageController = PageController();
    pageController?.addListener(() {
      selectedIndex = pageController?.page?.round();
      _systemUiChanger();
    });

    scrollController = ScrollController();
    searchController = SearchController();

    _mapController = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
      areaLimit: const BoundingBox(
          east: 10.4922941,
          north: 47.8084648,
          south: 45.817995,
          west: 5.9559113),
    );

    tabController = TabController(length: 2, vsync: navigatorKey.currentState!);

    await _fetchUser();
    await _fetchMyShop();
    await _fetchProducts();
    await _fetchOrders();
    await _fetchShopOrders();

    scrollController?.addListener(() {
      scrollController?.position.pixels ==
              scrollController?.position.maxScrollExtent
          ? _fetchProducts()
          : null;
    });
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    final TaskResult result =
        await TaskUtility.run<UserModel>(task: UserService.get);
    user = result.result as UserModel;
  }

  Future<void> _fetchMyShop() async {
    final TaskResult result = await TaskUtility.run<List<ShopModel>>(
        task: () => ShopService.p(userId: 'me'));

    if (result.result != null) {
      final List<ShopModel> shops = result.result as List<ShopModel>;
      _shop = shops.firstOrNull;
      if (_shop != null) {
        _fetchShopOrders(); // Fetch orders setelah dapat data toko
      }
    }
    notifyListeners();
  }

  Future<void> _fetchProducts() async {
    final TaskResult result = await TaskUtility.run<List<ProductModel>>(
        task: () => ProductService.index(
            searchTerm: searchTerm ?? '', skip: products?.length ?? 0));

    products ??= <ProductModel>[];
    products?.addAll(result.result as List<ProductModel>);

    for (ProductModel product in products ?? <ProductModel>[]) {
      final TaskResult p = await TaskUtility.run<List<ProductImageModel>>(
          task: () => ProductImageService.index(productId: product.id ?? ''));
      final List<ProductImageModel> x = productImages;
      x.addAll(p.result);
      productImages = x;
    }
  }

  Future<void> _fetchOrders() async {
    try {
      print('=== MENGAMBIL DATA PEMBELIAN ===');
      final TaskResult result = await TaskUtility.run<List<OrderModel>>(
          task: () => OrderService.index());

      if (result.result == null ||
          (result.result as List<OrderModel>).isEmpty) {
        // Jika data null atau kosong, set orders sebagai daftar kosong
        orders = [];
      } else {
        // Jika data ada, sort berdasarkan ID secara descending (terbaru di atas)
        orders = (result.result as List<OrderModel>)
          ..sort((a, b) {
            final int idA = int.tryParse(a.id ?? '0') ?? 0;
            final int idB = int.tryParse(b.id ?? '0') ?? 0;
            return idB.compareTo(idA); // Descending order (terbaru di atas)
          });
      }

      print('Jumlah pembelian: ${orders?.length}');
      notifyListeners(); // Notifikasi bahwa data telah diperbarui
    } catch (e) {
      print('ERROR FETCH ORDERS: $e');
    }
  }

  void _systemUiChanger() {
    if (selectedIndex == 1 || selectedIndex == 3) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0x00000000),
        statusBarIconBrightness: Brightness.dark,
      ));
    } else if (selectedIndex == 2) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFBAB9BD),
        statusBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFFFFFF),
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  void onNavigationBarTapped({required int value}) {
    selectedIndex = value;

    _systemUiChanger();

    pageController?.animateToPage(selectedIndex ?? 0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void onSearchSubmitted(String s) {
    if (_searchTerm == null ||
        (_searchTerm!.isEmpty && searchController!.value.text.isNotEmpty)) {
      _searchTerm = searchController!.value.text;
      _products = null;
    } else if (_searchTerm == searchController!.value.text) {
      _products = null;
    } else {
      _searchTerm = searchController!.value.text;
    }

    _fetchProducts();
  }

  void onSearchReset() {
    _searchTerm = null;
    _searchController?.clear();
    _searchController?.clearComposing();
    _fetchProducts();
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

  void onCreateShop() async {
    final TextEditingController nameController = TextEditingController();
    late final String? name;

    name = await showDialog<String?>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buat toko'),
          content: TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nama toko'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, nameController.value.text),
              child: const Text('Buat toko'),
            )
          ],
        );
      },
    );

    if (name == null || name.isEmpty) return;

    final Map<String, dynamic> data = <String, dynamic>{'name': name};
    final TaskResult result = await TaskUtility.run<Map<String, dynamic>>(
        task: () => ShopService.post(data: data));
    final Map<String, dynamic> response = result.result;

    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(response['message'])));

    _fetchMyShop();
  }

  void onMyShopTapped() => Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => MyShopProvider()..init(),
            child: const MyShopScreen(),
          ),
        ),
      );

  void onShippingAddressTapped() => Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
                create: (_) => ShippingAddressProvider()..init(),
                child: const ShippingAddressesScreen(),
              )));

  void onLogout() {
    showDialog<bool?>(
      context: navigatorKey.currentContext!,
      builder: (_) {
        return AlertDialog(
          title: const Text('Apa kamu yakin akan keluar akun?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(navigatorKey.currentContext!),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(navigatorKey.currentContext!, true),
              child: const Text('Ya'),
            ),
          ],
        );
      },
    ).then((bool? value) async {
      if (value != null && value) {
        final TaskResult result =
            await TaskUtility.run(task: SqliteUtility.clearData);
        if (result.result) exit(0);
      }
    });
  }

  Future<void> _fetchShopOrders() async {
    try {
      print('=== MENGAMBIL DATA PESANAN ===');
      print('Shop ID: ${shop?.id}');

      final result = await TaskUtility.run<List<OrderModel>>(
          task: () =>
              OrderService.getShopOrders(shopId: shop?.id.toString() ?? ''));

      if (result.result != null) {
        _shopOrders = result.result;
        print('Jumlah pesanan: ${_shopOrders?.length}');
        _shopOrders?.forEach((order) {
          print('ID: ${order.id}, Status: ${order.status}, Qty: ${order.qty}');
        });
      }
    } catch (e) {
      print('ERROR FETCH SHOP ORDERS: $e');
    }
  }

  Future<void> updateOrderStatus(OrderModel order, String newStatus) async {
    try {
      print('Debug - Start updateOrderStatus: ${order.id}, status: $newStatus');

      String? trackingNumber;

      if (newStatus == OrderStatus.shipped) {
        trackingNumber = await showDialog<String>(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Column(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Input Nomor Resi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon: const Icon(Icons.numbers),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    labelText: 'Nomor Resi',
                    hintText: 'Masukkan nomor resi pengiriman',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      Navigator.pop(context, controller.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nomor resi tidak boleh kosong'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            );
          },
        );

        if (trackingNumber == null) return;

        print(
            'Debug - Updating order status with tracking number: $trackingNumber');
      }

      final result = await TaskUtility.run(
        task: () => OrderService.updateStatus(
          id: order.id ?? '',
          status: newStatus,
          trackingNumber: trackingNumber,
        ),
      );

      if (result.result != null) {
        await Future.wait([
          _fetchShopOrders(),
          _fetchOrders(),
        ]);
        notifyListeners();

        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(
                'Status pesanan berhasil diperbarui ke ${OrderStatus.getIndonesian(newStatus)}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Gagal update status order');
      }
    } catch (e) {
      print('Error updating order status: $e');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status pesanan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> showConfirmationDialog(String message) async {
    final result = await showDialog<bool>(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Column(
          children: [
            Icon(
              message.contains('Tolak')
                  ? Icons.cancel_outlined
                  : Icons.check_circle_outlined,
              size: 50,
              color: message.contains('Tolak')
                  ? Colors.red
                  : Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              message.contains('Tolak')
                  ? 'Konfirmasi Penolakan'
                  : 'Konfirmasi Pesanan',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: message.contains('Tolak')
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    message.contains('Tolak') ? 'Tolak' : 'Konfirmasi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
    );
    return result ?? false;
  }

  // Fungsi untuk mengubah status ke cancelled
  Future<void> cancelOrder(OrderModel order) async {
    try {
      if (await showConfirmationDialog('Tolak pesanan ini?')) {
        print('=== PROSES PENOLAKAN PESANAN ===');
        print('ID Pesanan: ${order.id}');

        final result = await TaskUtility.run(
            task: () => OrderService.updateStatus(
                id: order.id ?? '',
                status: OrderStatus.cancelled,
                trackingNumber: null));

        if (result.result != null) {
          await Future.wait([
            _fetchShopOrders(),
            _fetchOrders(),
          ]);
          notifyListeners();

          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Pesanan berhasil ditolak')),
          );
        } else {
          throw Exception('Gagal mengupdate status order');
        }
      }
    } catch (e) {
      print('ERROR PENOLAKAN PESANAN: $e');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Gagal menolak pesanan')),
      );
    }
  }

  // Fungsi untuk mengubah status ke confirmed
  Future<void> confirmOrder(OrderModel order) async {
    try {
      if (await showConfirmationDialog('Konfirmasi pesanan ini?')) {
        print('Mengkonfirmasi pesanan dengan ID: ${order.id}');

        final result = await TaskUtility.run(
            task: () => OrderService.updateStatus(
                id: order.id ?? '', status: 'confirmed', trackingNumber: null));

        if (result.result != null) {
          await Future.wait([
            _fetchShopOrders(),
            _fetchOrders(),
          ]);
          notifyListeners();

          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Text('Pesanan berhasil dikonfirmasi'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('Gagal update status order: ${result.message}');
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Gagal mengkonfirmasi pesanan'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error saat mengkonfirmasi pesanan: $e');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi untuk mengubah status ke shipped
  Future<void> shipOrder(OrderModel order) async {
    try {
      if (order.trackingNumber == null || order.trackingNumber!.isEmpty) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Nomor resi harus diisi')),
        );
        return;
      }

      final result = await TaskUtility.run(
          task: () => OrderService.updateStatus(
              id: order.id ?? '',
              status: OrderStatus.shipped,
              trackingNumber: order.trackingNumber));

      if (result.result != null) {
        await _fetchShopOrders();
        notifyListeners();

        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dikirim')),
        );
      } else {
        throw Exception('Gagal mengupdate status order');
      }
    } catch (e) {
      print('Error saat mengirim pesanan: $e');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim pesanan')),
      );
    }
  }

  Future<void> sendShipment(OrderModel order, String trackingNumber) async {
    try {
      if (await showConfirmationDialog('Kirim pesanan ini?')) {
        print('Mengirim pesanan dengan ID: ${order.id}');

        final result = await TaskUtility.run(
            task: () => OrderService.updateStatus(
                id: order.id ?? '',
                status: 'shipped',
                trackingNumber: trackingNumber));

        print('Debug - Tracking Number: $trackingNumber');

        if (result.result != null) {
          await _fetchShopOrders();
          notifyListeners();

          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            const SnackBar(
              content: Text('Pesanan berhasil dikirim'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('Gagal mengirim pesanan: ${result.message}');
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text(result.message ?? 'Gagal mengirim pesanan'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error saat mengirim pesanan: $e');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
