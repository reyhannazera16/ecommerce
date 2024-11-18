import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/base_provider.dart';
import 'package:fradel_spies/providers/shop_provider.dart';
import 'package:fradel_spies/screens/shop_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/data/order_model.dart';
import '../models/data/product_model.dart';
import '../models/data/product_sku_model.dart';
import '../providers/product_detail_provider.dart';
import '../utilities/common_utility.dart';
import '../utilities/common_widget_utility.dart';
import 'order_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  dynamic selectedPaymentMethod;
  dynamic selectedDeliveryService;
  dynamic selectedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Consumer<ProductDetailProvider>(
                  builder:
                      (_, ProductDetailProvider productDetailProvider, __) {
                    // Filter images related to the product
                    final productImages = productDetailProvider.productImages
                        .where((q) =>
                            q.productId == productDetailProvider.product.id)
                        .toList();

                    return Hero(
                      tag: 'product-${productDetailProvider.product.id}',
                      child: productImages.isNotEmpty
                          ? PageView.builder(
                              itemCount: productImages.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // Show the image in fullscreen when clicked
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.black,
                                          insetPadding: EdgeInsets.zero,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Image.network(
                                              'http://103.158.196.80/api/download/${productImages[index].id}',
                                              fit: BoxFit.contain,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.network(
                                    'http://103.158.196.80/api/download/${productImages[index].id}',
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                );
                              },
                            )
                          : const CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ListTile(
                  title: Consumer<ProductDetailProvider>(
                    builder:
                        (_, ProductDetailProvider productDetailProvider, __) {
                      final ProductModel product =
                          productDetailProvider.product;
                      return Text(
                        '${product.name}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: const Color(0xFF282828),
                        ),
                      );
                    },
                  ),
                  trailing: Consumer<ProductDetailProvider>(
                    builder:
                        (_, ProductDetailProvider productDetailProvider, __) {
                      final List<ProductSkuModel>? productSkus =
                          productDetailProvider.productSkus;
                      final int? activeSku = productDetailProvider.activeSku;
                      late final int price;
                      late final String priceRupiah;

                      if (productSkus == null || activeSku == null) {
                        return const Skeletonizer(
                          child: Text('Memuat Harga'),
                        );
                      }

                      price = productSkus.elementAt(activeSku).price!;
                      priceRupiah = CommonUtility.formatRupiah(value: price);

                      return Text(
                        priceRupiah,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF29D38),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Varian tersedia',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF282828),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Consumer<ProductDetailProvider>(
                        builder: (_,
                            ProductDetailProvider productDetailProvider, ___) {
                          return productDetailProvider.productSkus == null
                              ? const LinearProgressIndicator()
                              : Wrap(
                                  spacing: 8,
                                  children: productDetailProvider.productSkus!
                                      .map((ProductSkuModel sku) {
                                    return sku ==
                                            productDetailProvider.productSkus!
                                                .elementAt(productDetailProvider
                                                    .activeSku!)
                                        ? FilledButton.icon(
                                            onPressed: () =>
                                                productDetailProvider
                                                    .onSkuSelected(sku: sku),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFE5E5E5),
                                              side: const BorderSide(
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                            icon: const Icon(
                                                Icons.check_outlined),
                                            label: Text(sku.name!),
                                          )
                                        : FilledButton(
                                            onPressed: () =>
                                                productDetailProvider
                                                    .onSkuSelected(sku: sku),
                                            style: FilledButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFE5E5E5),
                                              side: const BorderSide(
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                            child: Text(sku.name!),
                                          );
                                  }).toList(),
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<ProductDetailProvider>(
                builder: (_, ProductDetailProvider productDetailProvider, ___) {
                  return productDetailProvider.productDetail == null
                      ? const Card.outlined(
                          child: ListTile(
                            title: Skeletonizer(
                              child: Text('Memuat Deskripsi'),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: const Text('Deskripsi'),
                            subtitle: Text(
                                '${productDetailProvider.productDetail?.description}'),
                          ),
                        );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                child: Consumer<ProductDetailProvider>(builder:
                    (_, ProductDetailProvider productDetailProvider, ___) {
                  return productDetailProvider.shop == null
                      ? const Card.outlined(
                          child: ListTile(
                            title: Skeletonizer(
                              child: Text('Memuat Toko'),
                            ),
                          ),
                        )
                      : Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: InkWell(
                            onTap: productDetailProvider.onShopTapped,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: ListTile(
                              leading: const Icon(Icons.store_outlined),
                              title:
                                  Text('${productDetailProvider.shop?.name}'),
                            ),
                          ),
                        );
                }),
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<BaseProvider>(
            builder: (_, BaseProvider provider, __) {
              return Consumer<ProductDetailProvider>(
                builder: (_, ProductDetailProvider providerTwo, __) {
                  return FilledButton(
                    onPressed:
                        provider.isBusy ? null : providerTwo.onOrderTapped,
                    style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                    child: const Text(
                      'Beli sekarang',
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _createOrder() async {
    final provider = context.read<ProductDetailProvider>();
    final product = provider.product;
    final activeSku = provider.productSkus?.elementAt(provider.activeSku!);

    final OrderModel order = OrderModel(
        productId: product.id,
        paymentMethodId: selectedPaymentMethod?.id.toString(),
        deliveryServiceId: selectedDeliveryService?.id.toString(),
        shippingAddressId: selectedAddress?.id.toString(),
        qty: quantity,
        price: activeSku?.price ?? 0,
        status: 'pending');

    print('Debug - Order Data:');
    print(order.toMap());

    final result = await provider.createOrder(order);

    if (result) {
      Navigator.pop(context);
      CommonWidgetUtility.showSnackBar(message: 'Berhasil membuat pesanan');
    }
  }
}
