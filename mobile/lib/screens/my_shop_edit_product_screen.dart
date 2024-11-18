import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/my_shop_edit_product_provider.dart';
import 'package:provider/provider.dart';

import '../models/data/product_sku_model.dart';
import '../providers/base_provider.dart';
import '../utilities/common_utility.dart';

class MyShopEditProductScreen extends StatelessWidget {
  const MyShopEditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF282828),
        elevation: .5,
        title: const Text('Ubah Produk'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed:
                context.read<MyShopEditProductProvider>().onDeleteProduct,
            icon: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
            child: Text('Utama',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Consumer<MyShopEditProductProvider>(
                builder: (_, MyShopEditProductProvider provider, __) {
              return TextFormField(
                controller: provider.nameFormController,
                decoration: const InputDecoration(
                    filled: true, labelText: 'Nama produk'),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Consumer<MyShopEditProductProvider>(
                builder: (_, MyShopEditProductProvider provider, __) {
              return TextFormField(
                controller: provider.detailFormController,
                decoration: const InputDecoration(
                    filled: true, labelText: 'Detail produk'),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 0, 8),
            child: Text(
              'SKU',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Consumer<MyShopEditProductProvider>(
              builder: (_, MyShopEditProductProvider provider, __) {
                final List<ProductSkuModel> productSkus = provider.productSkus;
                return productSkus.isEmpty
                    ? const Card.outlined(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text('Belum ada SKU'),
                          ),
                        ),
                      )
                    : Card(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: productSkus.map((ProductSkuModel sku) {
                              return ListTile(
                                key: ValueKey(
                                    '${sku.id ?? UniqueKey()}-${sku.name ?? 'defaultName'}'),

// Tambahkan key unik di sini
                                title: Text('${sku.name}'),
                                subtitle: Text('${sku.qty}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(CommonUtility.formatRupiah(
                                        value: (sku.price ?? 0))),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // Menampilkan modal untuk mengedit SKU
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            final TextEditingController
                                                nameController =
                                                TextEditingController(
                                                    text: sku.name);
                                            final TextEditingController
                                                qtyController =
                                                TextEditingController(
                                                    text: sku.qty.toString());
                                            final TextEditingController
                                                priceController =
                                                TextEditingController(
                                                    text: (sku.price ?? 0)
                                                        .toString());

                                            return AlertDialog(
                                              title: Text('Edit SKU'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller: nameController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Nama SKU',
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    controller: qtyController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Jumlah',
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                  TextFormField(
                                                    controller: priceController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Harga',
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ],
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
                                                    // Update data SKU dan panggil metode update
                                                    sku.name =
                                                        nameController.text;
                                                    sku.qty = int.tryParse(
                                                            qtyController
                                                                .text) ??
                                                        0;
                                                    sku.price = double.tryParse(
                                                                priceController
                                                                    .text)
                                                            ?.toInt() ??
                                                        0;

                                                    provider.updateSku(sku);

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Simpan'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Consumer<MyShopEditProductProvider>(
              builder: (_, MyShopEditProductProvider providerTwo, __) {
                return FilledButton.tonalIcon(
                  onPressed: providerTwo.onAddSku,
                  icon: const Icon(Icons.add_outlined),
                  label: const Text('SKU'),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<BaseProvider>(
            builder: (_, BaseProvider provider, __) {
              return Consumer<MyShopEditProductProvider>(
                builder: (_, MyShopEditProductProvider providerTwo, __) {
                  return FilledButton(
                    onPressed:
                        provider.isBusy ? null : providerTwo.onUpdateProduct,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Simpan',
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
}
