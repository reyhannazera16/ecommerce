import 'package:flutter/material.dart';
import 'package:fradel_spies/models/data/shipping_address_model.dart';
import 'package:fradel_spies/providers/base_provider.dart';
import 'package:fradel_spies/providers/shipping_address_provider.dart';
import 'package:provider/provider.dart';

class ShippingAddressesScreen extends StatelessWidget {
  const ShippingAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF282828),
        elevation: .5,
        title: const Text('Alamat pengiriman'),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.only(top: 16),
        child: Consumer<ShippingAddressProvider>(
          builder: (_, ShippingAddressProvider provider, __) {
            return provider.shippingAddresses == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.shippingAddresses!.isEmpty
                    ? const Center(
                        child: Text('Belum ada alamat!'),
                      )
                    : ListView(
                        children: provider.shippingAddresses!.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              child: InkWell(
                                onTap: () => provider.onEditAddress(source: e),
                                onLongPress: () => provider.onDeleteAddress(source: e),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    child: Icon(Icons.delivery_dining_outlined),
                                  ),
                                  title: Text('${e.address}'),
                                  trailing: (e.isPrimary ?? false)
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.orange,
                                          ),
                                          child: const Text(
                                            'Primary',
                                            style: TextStyle(color: Color(0xFFFFFFFF)),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<BaseProvider>(
            builder: (_, BaseProvider provider, __) {
              return Consumer<ShippingAddressProvider>(
                builder: (_, ShippingAddressProvider providerTwo, __) {
                  return FilledButton(
                    onPressed: provider.isBusy ? null : providerTwo.onAddAddress,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Tambah alamat',
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

class AddUserShipmentAddressDialog extends StatefulWidget {
  const AddUserShipmentAddressDialog({super.key});

  @override
  State<AddUserShipmentAddressDialog> createState() => _AddUserShipmentAddressDialogState();
}

class _AddUserShipmentAddressDialogState extends State<AddUserShipmentAddressDialog> {
  GlobalKey<FormState>? _formKey;
  TextEditingController? _addressFieldController;

  ShippingAddressModel get _data {
    return ShippingAddressModel(address: _addressFieldController?.value.text);
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _addressFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _addressFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New address'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _addressFieldController,
          validator: (String? value) => value == null || value.isEmpty ? "Address can't be empty" : null,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => _formKey!.currentState!.validate() ? Navigator.pop(context, _data) : null,
          child: const Text('Save'),
        )
      ],
    );
  }
}

class EditUserShipmentAddressDialog extends StatefulWidget {
  final ShippingAddressModel data;
  const EditUserShipmentAddressDialog({super.key, required this.data});

  @override
  State<EditUserShipmentAddressDialog> createState() => _EditUserShipmentAddressDialogState();
}

class _EditUserShipmentAddressDialogState extends State<EditUserShipmentAddressDialog> {
  GlobalKey<FormState>? _formKey;
  TextEditingController? _addressFieldController;
  bool? _isPrimary;

  ShippingAddressModel get _data {
    return ShippingAddressModel(
      id: widget.data.id,
      address: _addressFieldController?.value.text != null && _addressFieldController!.value.text.isNotEmpty
          ? _addressFieldController?.value.text
          : widget.data.address,
      isPrimary: _isPrimary,
    );
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _addressFieldController = TextEditingController();
    _isPrimary = widget.data.isPrimary;
    super.initState();
  }

  @override
  void dispose() {
    _addressFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit address'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _addressFieldController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            ListTile(
              title: const Text('Is primary?'),
              trailing: Switch(value: _isPrimary ?? false, onChanged: (bool value) => setState(() => _isPrimary = value)),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => _formKey!.currentState!.validate() ? Navigator.pop(context, _data) : null,
          child: const Text('Save'),
        )
      ],
    );
  }
}
