import 'package:flutter/material.dart';

import '../main.dart';

class CommonWidgetUtility {
  static void navigateTo({required Widget page}) {
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (_) => page));
  }

  static void navigateAndRemoveTo({required Widget page}) {
    Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, MaterialPageRoute(builder: (_) => page), (_) => false);
  }

  static Future<void> showLoading({bool canInterupt = true, String title = 'Loading'}) {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (_) => CommonLoadingWidget(canInterupt: canInterupt, title: title),
    );
  }

  static Future<void> showError({String title = 'Error', required String message}) {
    return showDialog<void>(
      context: navigatorKey.currentContext!,
      builder: (_) => CommonErrorWidget(title: title, message: message),
    );
  }

  static void showSnackBar({required String message}) {
    final SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  static Future<T?> showEditDialog<T>({required String id, required String value}) {
    return showDialog<T?>(
      context: navigatorKey.currentContext!,
      builder: (_) => CommonEditDialogWidget(id: id, value: value),
    );
  }
}

class CommonLoadingWidget extends StatelessWidget {
  final bool canInterupt;
  final String title;
  const CommonLoadingWidget({super.key, this.canInterupt = true, this.title = 'Loading'});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canInterupt,
      child: AlertDialog(
        title: Text(title),
        content: const LinearProgressIndicator(),
      ),
    );
  }
}

class CommonErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  const CommonErrorWidget({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text('Terjadi kesalahan! $message'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}

class CommonEditDialogWidget extends StatefulWidget {
  final String id;
  final String value;
  const CommonEditDialogWidget({super.key, required this.id, required this.value});

  @override
  State<CommonEditDialogWidget> createState() => _CommonEditDialogWidgetState();
}

class _CommonEditDialogWidgetState extends State<CommonEditDialogWidget> {
  GlobalKey<FormState>? _formKey;
  TextEditingController? _inputFieldController;

  String get _value => _inputFieldController?.value.text ?? widget.value;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _inputFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _inputFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.id}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _inputFieldController,
          validator: (String? value) => value == null || value.isEmpty ? 'Please fill in ${widget.id}' : null,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, _value),
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save'),
        )
      ],
    );
  }
}
