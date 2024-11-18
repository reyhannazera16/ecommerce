import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/base_provider.dart';
import 'package:provider/provider.dart';

class BelowAppBarLoadingWidget extends StatelessWidget {
  const BelowAppBarLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: !context.watch<BaseProvider>().isBusy ? 0 : null,
      child: const LinearProgressIndicator(),
    );
  }
}
