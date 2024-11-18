import 'package:flutter/material.dart';
import 'package:fradel_spies/models/data/product_model.dart';
import 'package:fradel_spies/providers/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../utilities/common_utility.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShopProvider>(context, listen: false);
    provider.init(); // Ensure products are loaded

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF282828),
        elevation: .5,
        title: Consumer<ShopProvider>(
          builder: (_, ShopProvider provider, __) {
            return Text('${provider.shop.name}');
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.only(top: 16),
        child: Consumer<ShopProvider>(
          builder: (_, ShopProvider provider, __) {
            return provider.products == null
                ? _buildLoadingGrid()
                : provider.products!.isEmpty
                    ? const Center(
                        child: Text('Belum ada produk!'),
                      )
                    : _buildProductGrid(provider, provider.products!);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.count(
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
    );
  }

  Widget _buildProductGrid(ShopProvider provider, List<ProductModel> products) {
    // Remove duplicates by using a Set to track unique product IDs
    final uniqueProducts = <ProductModel>[];
    final uniqueIds = <String>{};

    for (final product in products) {
      if (!uniqueIds.contains(product.id)) {
        uniqueIds.add(product.id!);
        uniqueProducts.add(product);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .6,
        crossAxisSpacing: 16,
        children: uniqueProducts.map((ProductModel p) {
          return InkWell(
            onTap: () => provider.onProductTapped(product: p),
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD3D3D3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Hero(
                      tag: 'product-${p.id}',
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: provider.products != null &&
                                  provider.productImages
                                      .where((q) => q.productId == p.id)
                                      .isNotEmpty
                              ? Image.network(
                                  'http://103.158.196.80/api/download/${provider.productImages.where((q) => q.productId == p.id).first.id}',
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                )
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
                    CommonUtility.formatRupiah(value: p.price ?? 0),
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
        }).toList(),
      ),
    );
  }
}
