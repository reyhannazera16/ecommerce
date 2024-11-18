import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/base_provider.dart';
import 'package:fradel_spies/providers/order_provider.dart';
import 'package:fradel_spies/utilities/common_utility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderProductScreen extends StatelessWidget {
  const OrderProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF282828),
        elevation: .5,
        title: const Text('Pemesanan'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
              child: Text(
                'Informasi produk',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined),
                    title: const Text('Nama'),
                    subtitle: Consumer<OrderProvider>(
                      builder: (_, OrderProvider provider, __) {
                        return Skeletonizer(
                          enabled: provider.product == null,
                          child: Text(provider.product?.name ?? 'Memuat nama produk'),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_outlined),
                    title: const Text('Varian'),
                    subtitle: Consumer<OrderProvider>(
                      builder: (_, OrderProvider provider, __) {
                        return Text(provider.productSku.name ?? 'Tidak ada nama');
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.monetization_on_outlined),
                    title: const Text('Harga satuan'),
                    subtitle: Consumer<OrderProvider>(
                      builder: (_, OrderProvider provider, __) {
                        return Text(
                          CommonUtility.formatRupiah(value: provider.productSku.price ?? 0),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.summarize_outlined),
                    title: const Text('Jumlah'),
                    trailing: Consumer<OrderProvider>(
                      builder: (_, OrderProvider provider, __) {
                        return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: provider.onDecrement,
                              icon: const Icon(Icons.arrow_left),
                            ),
                            Text(provider.qty.toString()),
                            IconButton(
                              onPressed: provider.onIncrement,
                              icon: const Icon(Icons.arrow_right),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: Text(
                'Alamat tujuan',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Consumer<OrderProvider>(builder: (_, OrderProvider provider, __) {
                return InkWell(
                  onTap: provider.onSelectAddress,
                  child: ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: Consumer<OrderProvider>(builder: (_, OrderProvider provider, __) {
                      return Skeletonizer(
                        enabled: provider.shippingAddresses == null,
                        child: provider.shippingAddresses == null || provider.shippingAddresses!.isEmpty
                            ? const Text('Tidak ada alamat')
                            : Text(provider.selectedShippingAddress?.address ?? 'Belum dipilih, tekan untuk memilih'),
                      );
                    }),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: Text(
                'Jasa antar',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Consumer<OrderProvider>(builder: (_, OrderProvider provider, __) {
                return InkWell(
                  onTap: provider.onSelectDeliveryService,
                  child: ListTile(
                    leading: const Icon(Icons.delivery_dining_outlined),
                    title: const Text('Penyedia'),
                    subtitle: Consumer<OrderProvider>(builder: (_, OrderProvider provider, __) {
                      return Skeletonizer(
                        enabled: provider.deliveryServices == null,
                        child: Text(provider.selectedDeliveryService?.name ?? 'Belum dipilih, tekan untuk memilih'),
                      );
                    }),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: Text(
                'Metode pembayaran',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              child: Consumer<OrderProvider>(
                builder: (_, OrderProvider provider, __) {
                  return ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: DropdownButton<String>(
                      isExpanded: true,
                      value: provider.selectedPaymentMethod?.name,
                      hint: const Text('Pilih Bank'),
                      items: provider.paymentMethods?.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.name,
                          child: Text(e.name ?? 'Tidak dikenal'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        provider.setSelectedPaymentMethodByName(newValue);
                      },
                      underline: SizedBox(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Consumer(
                    builder: (_, OrderProvider provider, __) {
                      return Text(
                        CommonUtility.formatRupiah(value: (provider.productSku.price ?? 0) * provider.qty),
                        style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Consumer<BaseProvider>(
                  builder: (_, BaseProvider provider, __) {
                    return Consumer<OrderProvider>(
                      builder: (_, OrderProvider providerTwo, __) {
                        return FilledButton(
                          onPressed: provider.isBusy ? null : providerTwo.onOrderTapped,
                          style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                          child: const Text(
                            'Beli sekarang',
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:fradel_spies/main.dart';
// import 'package:fradel_spies/models/data/delivery_service_model.dart';
// import 'package:fradel_spies/models/data/order_model.dart';
// import 'package:fradel_spies/models/data/payment_method_model.dart';
// import 'package:fradel_spies/models/data/product_model.dart';
// import 'package:fradel_spies/models/data/product_sku_model.dart';
// import 'package:fradel_spies/models/data/shipping_address_model.dart';
// import 'package:fradel_spies/models/utilities/task_result_model.dart';
// import 'package:fradel_spies/screens/home_screen.dart';
// import 'package:fradel_spies/services/delivery_service_service.dart';
// import 'package:fradel_spies/services/order_service.dart';
// import 'package:fradel_spies/services/payment_method_service.dart';
// import 'package:fradel_spies/services/product_service.dart';
// import 'package:fradel_spies/services/shipping_address_service.dart';
// import 'package:fradel_spies/utilities/common_utility.dart';
// import 'package:fradel_spies/utilities/task_utility.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// import '../utilities/common_widget_utility.dart';

// class OrderProductScreen extends StatefulWidget {
//   final ProductSkuModel sku;
//   const OrderProductScreen({super.key, required this.sku});

//   @override
//   State<OrderProductScreen> createState() => _OrderProductScreenState();
// }

// class _OrderProductScreenState extends State<OrderProductScreen> {
//   ProductSkuModel? _productSku;
//   List<DeliveryServiceModel>? _deliveryServices;
//   DeliveryServiceModel? _selectedDeliveryService;
//   List<PaymentMethodModel>? _paymentMethods;
//   PaymentMethodModel? _selectedPaymentMethod;
//   List<ShippingAddressModel>? _shippingAddresses;
//   ShippingAddressModel? _selectedShippingAddress;
//   TextEditingController? _notesFieldController;

//   @override
//   void initState() {
//     _productSku = widget.sku;
//     _notesFieldController = TextEditingController();
//     _notesFieldController?.addListener(() {
//       setState(() {});
//     });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _fetchProduct();
//       _fetchDeliveryServices();
//       _fetchPaymentMethods();
//       _fetchShippingAddresses();
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _notesFieldController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: <Widget>[
//           const SliverAppBar.medium(
//             title: Text('Beli produk'),
//           ),
//           SliverList.list(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
//                 child: Text(
//                   'Informasi produk',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
//                 child: Card.filled(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       ListTile(
//                         leading: const Icon(Icons.dashboard_outlined),
//                         title: const Text('Nama'),
//                         subtitle: Skeletonizer(
//                           enabled: _product == null,
//                           child: Text(_product?.name ?? 'Memuat nama produk'),
//                         ),
//                       ),
//                       Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
//                       ListTile(
//                         leading: const Icon(Icons.list_outlined),
//                         title: const Text('Varian'),
//                         subtitle: Skeletonizer(
//                           enabled: _productSku == null,
//                           child: Text(_productSku?.name ?? 'Memuat sku'),
//                         ),
//                       ),
//                       Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.surface),
//                       ListTile(
//                         leading: const Icon(Icons.monetization_on_outlined),
//                         title: const Text('Harga'),
//                         subtitle: Skeletonizer(
//                           enabled: _productSku == null,
//                           child: Text(CommonUtility.formatRupiah(value: _productSku?.price ?? 0)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
//                 child: Text(
//                   'Alamat tujuan',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
//                 child: Card.filled(
//                   child: InkWell(
//                     onTap: () async {
//                       _selectedPaymentMethod = await showDialog<PaymentMethodModel?>(
//                         context: context,
//                         builder: (_) {
//                           return SimpleDialog(
//                             title: const Text('Pilih jasa antar'),
//                             children: _paymentMethods?.map((e) {
//                               return SimpleDialogOption(
//                                 child: GestureDetector(
//                                   onTap: () => Navigator.pop(context, e),
//                                   child: Text(e.name ?? 'Tidak dikenal'),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       );

//                       setState(() {});
//                     },
//                     child: ListTile(
//                       leading: const Icon(Icons.payment_outlined),
//                       title: Skeletonizer(
//                         enabled: _shippingAddresses == null,
//                         child: Text(_selectedShippingAddress?.address ?? 'Belum dipilih, tekan untuk memilih'),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
//                 child: Text(
//                   'Jasa antar',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
//                 child: Card.filled(
//                   child: InkWell(
//                     onTap: () async {
//                       _selectedDeliveryService = await showDialog<DeliveryServiceModel?>(
//                         context: context,
//                         builder: (_) {
//                           return SimpleDialog(
//                             title: const Text('Pilih jasa antar'),
//                             children: _deliveryServices?.map((e) {
//                               return SimpleDialogOption(
//                                 child: GestureDetector(
//                                   onTap: () => Navigator.pop(context, e),
//                                   child: Text(e.name ?? 'Tidak dikenal'),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       );

//                       setState(() {});
//                     },
//                     child: ListTile(
//                       leading: const Icon(Icons.delivery_dining_outlined),
//                       title: const Text('Penyedia'),
//                       subtitle: Skeletonizer(
//                         enabled: _deliveryServices == null,
//                         child: Text(_selectedDeliveryService?.name ?? 'Belum dipilih, tekan untuk memilih'),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
//                 child: Text(
//                   'Metode pembayaran',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
//                 child: Card.filled(
//                   child: InkWell(
//                     onTap: () async {
//                       _selectedPaymentMethod = await showDialog<PaymentMethodModel?>(
//                         context: context,
//                         builder: (_) {
//                           return SimpleDialog(
//                             title: const Text('Pilih jasa antar'),
//                             children: _paymentMethods?.map((e) {
//                               return SimpleDialogOption(
//                                 child: GestureDetector(
//                                   onTap: () => Navigator.pop(context, e),
//                                   child: Text(e.name ?? 'Tidak dikenal'),
//                                 ),
//                               );
//                             }).toList(),
//                           );
//                         },
//                       );

//                       setState(() {});
//                     },
//                     child: ListTile(
//                       leading: const Icon(Icons.payment_outlined),
//                       title: Skeletonizer(
//                         enabled: _paymentMethods == null,
//                         child: Text(_selectedPaymentMethod?.name ?? 'Belum dipilih, tekan untuk memilih'),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
//                 child: Text(
//                   'Lainnya',
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
//                 child: TextFormField(
//                   controller: _notesFieldController,
//                   decoration: const InputDecoration(
//                     filled: true,
//                     prefixIcon: Icon(Icons.note_outlined),
//                     labelText: 'Catatan',
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//       bottomNavigationBar: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         child: BottomAppBar(
//           child: FilledButton(
//             onPressed: _selectedShippingAddress != null && _selectedDeliveryService != null && _selectedPaymentMethod != null
//                 ? () async {
//                     late final TaskResult result;
//                     late final Map<String, dynamic> response;
//                     final OrderModel data = OrderModel();

//                     data.productId = _product?.id;
//                     data.paymentMethodId = _selectedPaymentMethod?.id;
//                     data.deliveryServiceId = _selectedDeliveryService?.id;
//                     data.shippingAddressId = _selectedShippingAddress?.id;

//                     result = await TaskUtility.run<Map<String, dynamic>>(task: () => OrderService.store(data: data));
//                     response = result.result;


//                     if (response['message'] != '') {
//                       CommonWidgetUtility.showSnackBar(message: response['message']);
//                     }

//                     Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
//                   }
//                 : null,
//             child: const Text('Pesan sekarang'),
//           ),
//         ),
//       ),
//     );
//   }


// }
