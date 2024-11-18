import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/my_shop_add_product_provider.dart';
import 'package:provider/provider.dart';

import '../models/data/product_sku_model.dart';
import '../providers/base_provider.dart';
import '../utilities/common_utility.dart';

class MyShopAddProductScreen extends StatelessWidget {
  const MyShopAddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF282828),
        elevation: .5,
        title: const Text('Tambah Produk'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 12),
            child: Text('Utama', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Consumer<MyShopAddProductProvider>(builder: (_, MyShopAddProductProvider provider, __) {
              return TextFormField(
                controller: provider.nameFormController,
                decoration: const InputDecoration(filled: true, labelText: 'Nama produk'),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Consumer<MyShopAddProductProvider>(builder: (_, MyShopAddProductProvider provider, __) {
              return TextFormField(
                controller: provider.detailFormController,
                decoration: const InputDecoration(filled: true, labelText: 'Detail produk'),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 0, 8),
            child: Text(
              'SKU',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Consumer<MyShopAddProductProvider>(
              builder: (_, MyShopAddProductProvider provider, __) {
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
                                title: Text('${sku.name}'),
                                subtitle: Text('${sku.qty}'),
                                trailing: Text(CommonUtility.formatRupiah(value: (sku.price ?? 0))),
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
            child: Consumer<MyShopAddProductProvider>(builder: (_, MyShopAddProductProvider providerTwo, __) {
              return FilledButton.tonalIcon(
                onPressed: providerTwo.onAddSku,
                icon: const Icon(Icons.add_outlined),
                label: const Text('SKU'),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 0, 8),
            child: Text(
              'Gambar produk',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          SizedBox(
            height: 256,
            child: Consumer<MyShopAddProductProvider>(
              builder: (_, MyShopAddProductProvider p0, __) {
                return p0.images.isEmpty
                    ? const Center(
                        child: Text('Belum ada foto'),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: p0.images.map((e) {
                            return Image.file(File(e.path));
                          }).toList(),
                        ),
                      );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Consumer<MyShopAddProductProvider>(builder: (_, MyShopAddProductProvider providerTwo, __) {
              return FilledButton.tonalIcon(
                onPressed: providerTwo.onAddImage,
                icon: const Icon(Icons.add_outlined),
                label: const Text('Gambar'),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<BaseProvider>(
            builder: (_, BaseProvider provider, __) {
              return Consumer<MyShopAddProductProvider>(
                builder: (_, MyShopAddProductProvider providerTwo, __) {
                  return FilledButton(
                    onPressed: provider.isBusy ? null : providerTwo.onAddProduct,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

class MyShopAddSkuDialogWidget extends StatefulWidget {
  const MyShopAddSkuDialogWidget({super.key});

  @override
  State<MyShopAddSkuDialogWidget> createState() => _MyShopAddSkuDialogWidgetState();
}

class _MyShopAddSkuDialogWidgetState extends State<MyShopAddSkuDialogWidget> {
  GlobalKey<FormState>? _formKey;
  TextEditingController? _nameFieldController;
  TextEditingController? _priceFieldController;
  TextEditingController? _qtyFieldController;

  bool get _isValid => _formKey?.currentState?.validate() ?? false;
  String get _nameFieldValue => _nameFieldController?.value.text ?? '';
  String get _priceFieldValue => _priceFieldController?.value.text ?? '';
  String get _qtyFieldValue => _qtyFieldController?.value.text ?? '';
  ProductSkuModel get _data {
    return ProductSkuModel(name: _nameFieldValue, price: int.parse(_priceFieldValue), qty: int.parse(_qtyFieldValue));
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _nameFieldController = TextEditingController();
    _priceFieldController = TextEditingController();
    _qtyFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameFieldController?.dispose();
    _priceFieldController?.dispose();
    _qtyFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('New SKU'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameFieldController,
                validator: CommonUtility.formValidator,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                controller: _priceFieldController,
                validator: CommonUtility.formValidator,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Price',
                ),
              ),
              TextFormField(
                controller: _qtyFieldController,
                validator: CommonUtility.formValidator,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Qty',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => _isValid ? Navigator.pop(context, _data) : null,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          )
        ],
      ),
    );
  }
}
