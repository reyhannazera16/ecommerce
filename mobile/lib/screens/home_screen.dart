import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:fradel_spies/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fradel_spies/screens/profile_screen.dart'; // Sesuaikan jalur impor dengan struktur proyek Anda

import '../models/data/order_model.dart';
import '../models/data/order_status_model.dart';
import '../models/data/product_model.dart';
import '../providers/home_provider.dart';
import '../utilities/common_utility.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _onRejectOrder(OrderModel order) {
    context.read<HomeProvider>().cancelOrder(order);
  }

  void _onConfirmOrder(OrderModel order) {
    context.read<HomeProvider>().confirmOrder(order);
  }

  void _showShippingDialog(OrderModel order) async {
    print('Debug - Opening shipping dialog for order: ${order.id}');

    try {
      await context.read<HomeProvider>().updateOrderStatus(
            order,
            OrderStatus
                .shipped, // Pastikan ini sesuai dengan yang diharapkan backend
          );
      print('Debug - Order status updated successfully');
    } catch (e) {
      print('Debug - Error updating order status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengupdate status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildOrderItem(OrderModel order) {
    final totalPrice = (order.qty ?? 0) * (order.price ?? 0);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Header status
          Container(
            decoration: BoxDecoration(
              color: _getStatusColor(order.status).withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _getStatusIcon(order.status),
                    const SizedBox(width: 8),
                    Text(
                      OrderStatus.getIndonesian(order.status ?? ''),
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  DateFormat('dd MMM yyyy • HH:mm')
                      .format(order.createdAt ?? DateTime.now()),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Konten Pesanan
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Pembeli
                Row(
                  children: [
                    order.buyerPhoto != null && order.buyerPhoto!.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(order.buyerPhoto!),
                            backgroundColor: Colors.grey[100],
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            child: Text(
                              (order.buyerName ?? '?')[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.buyerName ?? 'Pembeli',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (order.buyerId != null)
                            Text(
                              'ID: ${order.buyerId}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Detail Produk
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar Produk (placeholder)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.fastfood,
                          color: Colors.grey[400], size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productName ?? 'Produk tidak dikenal',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(order.price ?? 0),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            '${order.qty} item',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (order.status == OrderStatus.shipped &&
                    order.trackingNumber != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nomor Resi',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                order.trackingNumber ?? '',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () =>
                              _copyToClipboard(order.trackingNumber),
                          color: Colors.blue[700],
                        ),
                      ],
                    ),
                  ),

                const Divider(height: 24),

                // Total Harga
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'id',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Footer dengan tombol aksi
          if (order.status != OrderStatus.cancelled &&
              order.status != OrderStatus.completed)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (order.status == OrderStatus.pending) ...[
                    OutlinedButton.icon(
                      onPressed: () => _onRejectOrder(order),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Tolak'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _onConfirmOrder(order),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Terima'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ] else if (order.status == OrderStatus.confirmed)
                    ElevatedButton.icon(
                      onPressed: () => _showShippingDialog(order),
                      icon:
                          const Icon(Icons.local_shipping, color: Colors.white),
                      label: const Text(
                        'Kirim Pesanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Icon _getStatusIcon(String? status) {
    switch (status) {
      case OrderStatus.pending:
        return Icon(Icons.schedule, color: Colors.orange[700]);
      case OrderStatus.confirmed:
        return Icon(Icons.thumb_up, color: Colors.blue[700]);
      case OrderStatus.shipped:
        return Icon(Icons.local_shipping, color: Colors.green[700]);
      case OrderStatus.completed:
        return Icon(Icons.check_circle, color: Colors.purple[700]);
      case OrderStatus.cancelled:
        return Icon(Icons.cancel, color: Colors.red[700]);
      default:
        return Icon(Icons.help, color: Colors.grey[700]);
    }
  }

  void _copyToClipboard(String? text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Nomor resi disalin ke clipboard')),
      );
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange[700]!;
      case OrderStatus.confirmed:
        return Colors.blue[700]!;
      case OrderStatus.shipped:
        return Colors.green[700]!;
      case OrderStatus.completed:
        return Colors.purple[700]!;
      case OrderStatus.cancelled:
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id_ID');

    return Scaffold(
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: Consumer<HomeProvider>(builder: (_, HomeProvider provider, __) {
          return PageView(
            controller: provider.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: const Color(0xFFFFFFFF),
                    foregroundColor: const Color(0xFF282828),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Consumer<HomeProvider>(
                                builder: (_, HomeProvider provider, __) {
                                  return Skeletonizer(
                                    enabled: provider.user == null,
                                    child: Text(
                                      'Hi ${CommonUtility.firstName(value: '${provider.user?.name}')}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: const Color(0xFF282828),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              'Selamat datang!',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: const Color(0xFF282828),
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          child: Icon(Icons.person_outline_outlined),
                        ),
                      ],
                    ),
                    toolbarHeight: kToolbarHeight * 1.5,
                    elevation: 0,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD9D9D9)),
                      ),
                      child: SearchBar(
                        controller: provider.searchController,
                        elevation: WidgetStateProperty.all(0),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.only(left: 16, right: 24)),
                        hintText: 'Search',
                        hintStyle: WidgetStateProperty.all(
                          GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: const Color(0xFF979595),
                          ),
                        ),
                        onSubmitted: provider.onSearchSubmitted,
                        trailing: <Widget>[
                          provider.searchTerm == null
                              ? IconButton(
                                  onPressed: () => provider.onSearchSubmitted(
                                      provider.searchController?.value.text ??
                                          ''),
                                  icon: const Icon(Icons.search_outlined),
                                )
                              : IconButton(
                                  onPressed: provider.onSearchReset,
                                  icon: const Icon(Icons.close_outlined),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: provider.products == null
                        ? GridView.count(
                            crossAxisCount: 2,
                            children: List.generate(8, (_) {
                              return const Card.outlined(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Card.filled(
                                        margin: EdgeInsets.zero,
                                        child: Center(),
                                      ),
                                    ),
                                    ListTile(
                                      title: Skeletonizer(
                                        child: Text('Product name'),
                                      ),
                                      subtitle: Skeletonizer(
                                        child: Text('Product price'),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                          )
                        : provider.products!.isEmpty
                            ? const Center(
                                child: Text('Belum ada produk!'),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: .6,
                                    crossAxisSpacing: 16,
                                    children: provider.products!
                                        .map((ProductModel p) {
                                      return InkWell(
                                        onTap: () => provider.onProductTapped(
                                            product: p),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFD3D3D3),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Hero(
                                                  tag: 'product-${p.id}',
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      // child: const Image(image: AssetImage('assets/ahdedas.png')),
                                                      // child: Image.network('http://103.158.196.80/api/download/${provider.productImages.where((x) => x.productId == p.id).first.id}'),
                                                      child: provider.products !=
                                                                  null &&
                                                              provider
                                                                  .productImages
                                                                  .where((q) =>
                                                                      q.productId ==
                                                                      p.id)
                                                                  .isNotEmpty
                                                          ? Image.network(
                                                              'http://103.158.196.80/api/download/${provider.productImages.where((q) => q.productId == p.id).first.id}',
                                                              fit: BoxFit.cover,
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity)
                                                          : const CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text(
                                                p.name ?? 'Memuat nama produk',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xD91E1E1E),
                                                ),
                                              ),
                                              subtitle: Text(
                                                CommonUtility.formatRupiah(
                                                    value: p.price ?? 0),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF000000),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList()),
                              ),
                  ),
                ],
              ),
              // Peta
              OSMFlutter(
                controller: provider.mapController!,
                osmOption: OSMOption(
                  userTrackingOption: const UserTrackingOption(
                    enableTracking: true,
                    unFollowUser: false,
                  ),
                  zoomOption: const ZoomOption(
                    initZoom: 8,
                    minZoomLevel: 3,
                    maxZoomLevel: 19,
                    stepZoom: 1.0,
                  ),
                  userLocationMarker: UserLocationMaker(
                    personMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.location_history_rounded,
                        color: Colors.red,
                        size: 48,
                      ),
                    ),
                    directionArrowMarker: const MarkerIcon(
                      icon: Icon(
                        Icons.double_arrow,
                        size: 48,
                      ),
                    ),
                  ),
                  roadConfiguration: const RoadOption(
                    roadColor: Colors.yellowAccent,
                  ),
                ),
              ),
              // Riwayat pemesanan
              DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFF333333),
                    title: const Text('Riwayat pemesanan'),
                    centerTitle: true,
                    toolbarHeight: kToolbarHeight * 1.5,
                    elevation: 0,
                    bottom: const TabBar(
                      tabs: [
                        Tab(text: 'Pembelian'),
                        Tab(text: 'Penjualan'),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // Tab Pembelian
                      Consumer<HomeProvider>(
                        builder: (context, provider, child) {
                          final orders = provider.orders;

                          print('Debug - Building orders list');
                          print('Orders null? ${orders == null}');
                          print('Orders empty? ${orders?.isEmpty ?? true}');

                          if (orders == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (orders.isEmpty) {
                            return const Center(
                                child: Text('Tidak ada pesanan'));
                          }

                          // Tampilkan pesan "Belum ada pembelian" jika data null atau kosong
                          if (orders == null || orders.isEmpty) {
                            return const Center(
                              child: Text(
                                'Belum ada pembelian',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              print('Debug - Building order ${order.id}');
                              return _buildOrderPembelian(order);
                            },
                          );
                        },
                      ),

                      // Tab Penjualan
                      provider.shopOrders == null
                          ? const Center(child: CircularProgressIndicator())
                          : provider.shopOrders!.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.store_outlined,
                                        size: 64,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Belum ada penjualan'),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  itemCount: provider.shopOrders!.length,
                                  itemBuilder: (context, index) {
                                    final order = provider.shopOrders![index];
                                    // final totalPrice = (order.qty ?? 0) * (order.price ?? 0);
                                    // final isCompleted = order.status == OrderStatus.completed ||
                                    //               order.status == OrderStatus.cancelled;

                                    return _buildOrderItem(order);
                                  },
                                ),
                    ],
                  ),
                ),
              ),
              // Profile
              Stack(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(36),
                      ),
                      child: Image(
                        image: AssetImage(
                            'assets/heber-davis-OWz1mcjdoKQ-unsplash.jpg'),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 340),
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Text(
                              '${provider.user?.name}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: const Color(0xFF282828),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 16),
                            child: FilledButton(
                              onPressed: () {
                                // Navigasi ke ProfileScreen
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                );
                              },
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Text(
                                'Ubah profile',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFFFFFFFF)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: provider.shop?.name == null
                                      ? InkWell(
                                          onTap: provider.onCreateShop,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: const ListTile(
                                            leading: Icon(Icons.store_outlined),
                                            title: Text('Buat toko sekarang'),
                                            subtitle:
                                                Text('Mulai menjual produk'),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: provider.onMyShopTapped,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: const ListTile(
                                            leading: Icon(Icons.store_outlined),
                                            title: Text('Toko Anda'),
                                            subtitle:
                                                Text('Atur toko Anda disini'),
                                          ),
                                        ),
                                ),
                                InkWell(
                                  onTap: provider.onShippingAddressTapped,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: const ListTile(
                                    leading:
                                        Icon(Icons.delivery_dining_outlined),
                                    title: Text('Alamat pengiriman'),
                                    subtitle:
                                        Text('Atur alamat-alamat Anda disini'),
                                  ),
                                ),
                                InkWell(
                                  onTap: provider.onLogout,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: const ListTile(
                                    leading: Icon(Icons.logout_outlined),
                                    title: Text('Keluar'),
                                    subtitle: Text('keluar dari aplikasi'),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 212),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 56,
                          child: Icon(Icons.person_outlined, size: 56),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.qr_code),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x21000000)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Consumer<HomeProvider>(
              builder: (_, HomeProvider provider, __) {
                return IconButton(
                  onPressed: () => provider.onNavigationBarTapped(value: 0),
                  icon: Icon(
                    Icons.home_outlined,
                    color: provider.pageController?.page?.round() == 0
                        ? Colors.orange
                        : null,
                  ),
                );
              },
            ),
            Consumer<HomeProvider>(builder: (_, HomeProvider provider, __) {
              return IconButton(
                onPressed: () => provider.onNavigationBarTapped(value: 1),
                icon: Icon(
                  Icons.location_on_outlined,
                  color: provider.pageController?.page?.round() == 1
                      ? Colors.orange
                      : null,
                ),
              );
            }),
            Consumer<HomeProvider>(builder: (_, HomeProvider provider, __) {
              return IconButton(
                onPressed: () => provider.onNavigationBarTapped(value: 2),
                icon: Icon(
                  Icons.history_outlined,
                  color: provider.pageController?.page?.round() == 2
                      ? Colors.orange
                      : null,
                ),
              );
            }),
            Consumer<HomeProvider>(builder: (_, HomeProvider provider, __) {
              return IconButton(
                onPressed: () => provider.onNavigationBarTapped(value: 3),
                icon: Icon(
                  Icons.person_outlined,
                  color: provider.pageController?.page?.round() == 3
                      ? Colors.orange
                      : null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Container _buildOrderPembelian(OrderModel order) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header dengan tanggal
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(order.createdAt ?? DateTime.now()),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Konten
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama Produk
                Text(
                  order.productName ?? 'Produk tidak diketahui',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                //
                const SizedBox(height: 8),
                // Status dan Qty
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // randomStatusIcon
                          _getStatusIcon(order.status),
                          const SizedBox(width: 4),
                          Text(
                            OrderStatus.getIndonesian(order.status ?? ''),
                            style: TextStyle(
                              color: _getStatusColor(order.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 14,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${order.qty} item',
                            // '${order.qty ?? 0} item',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Divider dengan pattern dots
                Row(
                  children: List.generate(
                    30,
                    (index) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        height: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Payment Info
                Row(
                  children: [
                    Icon(Icons.payment, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              // Parse payment method string
                              final String paymentInfo =
                                  order.paymentMethodName ?? '';
                              final List<String> parts = paymentInfo.split(' ');
                              final String bankName =
                                  parts.isNotEmpty ? parts[0] : '';
                              final String accountNumber =
                                  parts.length > 1 ? parts[1] : '';
                              final String accountName = parts.length > 3
                                  ? parts.sublist(3).join(' ')
                                  : '';

                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.account_balance,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text('Detail Pembayaran'),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Bank Info
                                    Text(
                                      'Bank $bankName',
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      accountName,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Nomor Rekening
                                    Text(
                                      'Nomor Rekening',
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          accountNumber,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: accountNumber));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Nomor rekening berhasil disalin'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.copy_rounded,
                                            size: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          tooltip: 'Salin nomor rekening',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Nomor Resi
                                    Text(
                                      'Nomor Resi',
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          order.trackingNumber ?? '',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text: order.trackingNumber ??
                                                    ''));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Nomor resi berhasil disalin'),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.copy_rounded,
                                            size: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          tooltip: 'Salin nomor resi',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Tutup'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'BCA a.n Mohammad Iqbal..',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Delivery Info
                Row(
                  children: [
                    Icon(Icons.local_shipping_outlined,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      order.deliveryServiceName ?? 'Kurir tidak diketahui',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(String? paymentMethodName) {
    switch (paymentMethodName) {
      case 'Bank Transfer':
        return Icons.credit_card;
      case 'Credit Card':
        return Icons.credit_card;
      case 'PayPal':
        return Icons.paypal;
      default:
        return Icons.payment;
    }
  }

  static void _showOrderActionDialog(BuildContext context, OrderModel order) {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Tindakan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Status saat ini: ${OrderStatus.getIndonesian(order.status ?? '')}'),
            const SizedBox(height: 16),
            if (order.status == OrderStatus.pending) ...[
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await provider.confirmOrder(order);
                },
                child: const Text('Konfirmasi Pesanan'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  print('DEBUG - Tombol Tolak ditekan');
                  Navigator.pop(dialogContext);
                  await provider.cancelOrder(order);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Tolak Pesanan'),
              ),
            ],
            if (order.status == OrderStatus.confirmed) ...[
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Nomor Resi',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    order.trackingNumber = controller.text;
                    Navigator.pop(dialogContext);
                    await provider.shipOrder(order);
                  }
                },
                child: const Text('Kirim Pesanan'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
