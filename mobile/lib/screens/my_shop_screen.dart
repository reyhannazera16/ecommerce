import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/base_provider.dart';
import 'package:fradel_spies/providers/my_shop_edit_product_provider.dart';
import 'package:fradel_spies/providers/my_shop_provider.dart';
import 'package:fradel_spies/screens/my_shop_edit_product_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/data/product_model.dart';
import '../utilities/common_utility.dart';

class MyShopScreen extends StatelessWidget {
  const MyShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF282828),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: Consumer<MyShopProvider>(
          builder: (_, MyShopProvider provider, __) {
            return PageView(
              controller: provider.pageController,
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 48,
                      child: Icon(Icons.store_outlined, size: 48),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Consumer<MyShopProvider>(
                          builder: (_, MyShopProvider myShopProvider, __) {
                            return Skeletonizer(
                              enabled: provider.shop == null,
                              child: Text(
                                provider.shop?.name ?? 'Memuat nama toko',
                                style: GoogleFonts.inter(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.store_outlined),
                        title: const Text('Status toko'),
                        subtitle: const Text('Atur buka atau tutup toko'),
                        trailing: Switch(value: true, onChanged: (value) {}),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final shopProvider =
                            Provider.of<MyShopProvider>(context, listen: false);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            TextEditingController nameController =
                                TextEditingController(
                              text:
                                  shopProvider.shop?.name ?? 'Memuat nama toko',
                            );

                            return AlertDialog(
                              title: Text('Ubah Nama Toko'),
                              content: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'Nama Toko',
                                  border: OutlineInputBorder(),
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
                                    String newName = nameController.text.trim();
                                    if (newName.isNotEmpty) {
                                      shopProvider.updateShopName(newName);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Nama toko tidak boleh kosong')),
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
                      },
                      child: const ListTile(
                        leading: Icon(Icons.settings_outlined),
                        title: Text('Ubah informasi toko'),
                        subtitle: Text('Atur informasi toko disini'),
                      ),
                    ),
                  ],
                ),
                provider.products == null
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
                        ? Center(
                            child: Text(
                              'Belum ada produk!',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: .6,
                                crossAxisSpacing: 16,
                                children:
                                    provider.products!.map((ProductModel p) {
                                  return InkWell(
                                    onTap: () =>
                                        provider.onProductTapped(product: p),
                                    onLongPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return ChangeNotifierProvider(
                                              create: (_) =>
                                                  MyShopEditProductProvider(
                                                      product: p)
                                                    ..init(),
                                              child:
                                                  const MyShopEditProductScreen(),
                                            );
                                          },
                                        ),
                                      ).whenComplete(() => provider.init());
                                    },
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFD3D3D3),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Hero(
                                              tag: 'product-${p.id}',
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  // child: const Image(image: AssetImage('assets/ahdedas.png')),
                                                  child: provider.products !=
                                                              null &&
                                                          provider.productImages
                                                              .where((q) =>
                                                                  q.productId ==
                                                                  p.id)
                                                              .isNotEmpty
                                                      ? Image.network(
                                                          'http://103.158.196.80/api/download/${provider.productImages.where((q) => q.productId == p.id).first.id}',
                                                          fit: BoxFit.cover,
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity)
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
              ],
            );
          },
        ),
      ),
      floatingActionButton: Consumer(
        builder: (_, BaseProvider provider, __) {
          return Consumer(
            builder: (_, MyShopProvider providerTwo, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: provider.isBusy
                    ? null
                    : FloatingActionButton(
                        onPressed: providerTwo.onAddProduct,
                        child: const Icon(Icons.add_outlined),
                      ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x21000000)),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Consumer<MyShopProvider>(
              builder: (_, MyShopProvider provider, __) {
                return IconButton(
                  onPressed: () => provider.onNavigationBarTapped(value: 0),
                  icon: Icon(
                    Icons.info_outlined,
                    color: provider.pageController?.page?.round() == 0
                        ? Colors.orange
                        : null,
                  ),
                );
              },
            ),
            Consumer<MyShopProvider>(builder: (_, MyShopProvider provider, __) {
              return IconButton(
                onPressed: () => provider.onNavigationBarTapped(value: 1),
                icon: Icon(
                  Icons.store,
                  color: provider.pageController?.page?.round() == 1
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
}
// import 'package:flutter/material.dart';
// import 'package:fradel_spies/models/data/product_model.dart';
// import 'package:fradel_spies/models/data/shop_model.dart';
// import 'package:fradel_spies/providers/base_provider.dart';
// import 'package:fradel_spies/providers/my_shop_add_product_provider.dart';
// import 'package:fradel_spies/providers/my_shop_provider.dart';
// import 'package:fradel_spies/screens/my_shop_add_product_screen.dart';
// import 'package:fradel_spies/utilities/common_widget_utility.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletonizer/skeletonizer.dart';

// import '../main.dart';

// class MyShopScreen extends StatefulWidget {
//   const MyShopScreen({super.key});

//   @override
//   State<MyShopScreen> createState() => _MyShopScreenState();
// }

// class _MyShopScreenState extends State<MyShopScreen> {
//   PageController? _pageController;

//   @override
//   void initState() {
//     _pageController = PageController();

//     WidgetsBinding.instance.addPostFrameCallback((_) => context.read<MyShopProvider>().init());

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _pageController,
//         physics: const NeverScrollableScrollPhysics(),
//         children: <Widget>[
//           CustomScrollView(
//             slivers: <Widget>[
//               const SliverAppBar.medium(),
//               Consumer<MyShopProvider>(
//                 builder: (_, MyShopProvider myShopProvider, __) {
//                   return SliverList.list(
//                     children: <Widget>[
//                       const CircleAvatar(
//                         radius: 48,
//                         child: Icon(Icons.store_outlined, size: 64),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
//                         child: Consumer<MyShopProvider>(
//                           builder: (_, MyShopProvider myShopProvider, ___) {
//                             final ShopModel? shop = myShopProvider.shop;

//                             if (shop == null) {
//                               return Center(
//                                 child: Skeletonizer(
//                                   child: Text('Memuat nama toko', style: Theme.of(context).textTheme.headlineMedium),
//                                 ),
//                               );
//                             }

//                             return Center(
//                               child: Text('${shop.name}', style: Theme.of(context).textTheme.headlineMedium),
//                             );
//                           },
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
//                         child: Card.filled(
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     Text(
//                                       '122',
//                                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
//                                     ),
//                                     Text('Pengikut', style: Theme.of(context).textTheme.bodyMedium),
//                                   ],
//                                 ),
//                                 Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     Text('67',
//                                         style:
//                                             Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
//                                     Text('Mengikuti', style: Theme.of(context).textTheme.bodyMedium),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: <Widget>[
//                                     Text('37K',
//                                         style:
//                                             Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
//                                     Text('Suka', style: Theme.of(context).textTheme.bodyMedium),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
//                         child: Card.filled(
//                           child: InkWell(
//                             onTap: () {},
//                             borderRadius: const BorderRadius.all(Radius.circular(12)),
//                             child: ListTile(
//                               leading: const Icon(Icons.store_outlined),
//                               title: const Text('Status toko'),
//                               subtitle: const Text('Yay! toko Anda sedang buka'),
//                               trailing: Switch(value: true, onChanged: (_) {}),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
//                         child: Card.filled(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               InkWell(
//                                 onTap: () {},
//                                 borderRadius: const BorderRadius.all(Radius.circular(12)),
//                                 child: const ListTile(
//                                   leading: Icon(Icons.settings_outlined),
//                                   title: Text('Ubah informasi toko'),
//                                   subtitle: Text('Atur informasi toko disini'),
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {},
//                                 borderRadius: const BorderRadius.all(Radius.circular(12)),
//                                 child: const ListTile(
//                                   leading: Icon(Icons.delivery_dining_outlined),
//                                   title: Text('Alamat pengiriman'),
//                                   subtitle: Text('Atur alamat-alamat Anda disini'),
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {},
//                                 borderRadius: const BorderRadius.all(Radius.circular(12)),
//                                 child: const ListTile(
//                                   leading: Icon(Icons.logout_outlined),
//                                   title: Text('Keluar'),
//                                   subtitle: Text('Akan menghapus data tersimpan'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//           CustomScrollView(
//             slivers: <Widget>[
//               const SliverAppBar.medium(
//                 title: Text('Produk saya'),
//               ),
//               SliverToBoxAdapter(
//                 child: AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 300),
//                   child: Consumer<BaseProvider>(
//                     builder: (_, BaseProvider baseProvider, __) {
//                       final bool isBusy = baseProvider.isBusy;
//                       return !isBusy ? const SizedBox() : const LinearProgressIndicator();
//                     },
//                   ),
//                 ),
//               ),
//               Consumer<MyShopProvider>(
//                 builder: (_, MyShopProvider myShopProvider, __) {
//                   final bool? hasShop = myShopProvider.hasShop;
//                   final List<ProductModel>? products = myShopProvider.products;

//                   if (hasShop == null) {
//                     return const SliverFillRemaining(
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   }

//                   if (!hasShop) {
//                     return SliverFillRemaining(
//                       child: Center(
//                         child: Wrap(
//                           direction: Axis.vertical,
//                           spacing: 8,
//                           crossAxisAlignment: WrapCrossAlignment.center,
//                           children: <Widget>[
//                             Text('Kamu belum memiliki toko!', style: Theme.of(context).textTheme.bodyLarge),
//                             FilledButton(
//                               onPressed: _onCreateShop,
//                               child: const Text('Buat toko'),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }

//                   if (products == null) {
//                     return SliverPadding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       sliver: SliverList.builder(
//                         itemCount: 10,
//                         itemBuilder: (_, int index) {
//                           return const Card.outlined(
//                             child: ListTile(
//                               title: Skeletonizer(
//                                 child: Text('Memuat nama produk'),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   }

//                   if (products.isEmpty) {
//                     return SliverFillRemaining(
//                       child: Center(
//                         child: Text('Kamu belum memiliki produk!', style: Theme.of(context).textTheme.bodyLarge),
//                       ),
//                     );
//                   }

//                   return SliverPadding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     sliver: SliverList.list(
//                       children: products.map((ProductModel p) {
//                         return Card.outlined(
//                           child: InkWell(
//                             onTap: () {},
//                             borderRadius: const BorderRadius.all(Radius.circular(12)),
//                             child: ListTile(
//                               leading: CircleAvatar(
//                                 child: ClipOval(
//                                   child: Image.network(image, fit: BoxFit.cover, height: double.infinity),
//                                 ),
//                               ),
//                               title: Text(p.name ?? 'Memuat nama produk'),
//                               subtitle: const Text('Placeholder detail'),
//                               trailing: const Icon(Icons.edit_outlined),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       floatingActionButton: Consumer<MyShopProvider>(
//         builder: (_, MyShopProvider myShopProvider, __) {
//           final int selectedIndex = myShopProvider.selectedIndex;
//           return AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: selectedIndex == 0
//                 ? const SizedBox()
//                 : FloatingActionButton.extended(
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ChangeNotifierProvider(
//                           create: (_) => MyShopAddProductProvider(),
//                           child: const MyShopAddProductScreen(),
//                         ),
//                       ),
//                     ),
//                     icon: const Icon(Icons.add_outlined),
//                     label: const Text('Produk'),
//                   ),
//           );
//         },
//       ),
//       bottomNavigationBar: Consumer<MyShopProvider>(
//         builder: (_, MyShopProvider myShopProvider, __) {
//           final int selectedIndex = myShopProvider.selectedIndex;
//           return NavigationBar(
//             selectedIndex: selectedIndex,
//             onDestinationSelected: _onDestinationSelected,
//             destinations: const <Widget>[
//               NavigationDestination(
//                 icon: Icon(Icons.store_outlined),
//                 selectedIcon: Icon(Icons.store),
//                 label: 'Toko',
//               ),
//               NavigationDestination(
//                 icon: Icon(Icons.dashboard_outlined),
//                 selectedIcon: Icon(Icons.dashboard),
//                 label: 'Produk',
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _onDestinationSelected(int value) {
//     context.read<MyShopProvider>().selectedIndex = value;
//     _pageController?.jumpToPage(value);
//   }

//   void _onCreateShop() {
//     final MyShopProvider myShopProvider = context.read<MyShopProvider>();
//     myShopProvider.createShop().then((String value) {
//       CommonWidgetUtility.showSnackBar(message: value);
//       myShopProvider.fetchMyShop().whenComplete(() => myShopProvider.fetchProducts());
//     });
//   }
// }
