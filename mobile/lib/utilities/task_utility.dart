import 'dart:async';

import 'package:provider/provider.dart';

import '../main.dart';
import '../models/utilities/task_result_model.dart';
import '../providers/base_provider.dart';
import 'common_widget_utility.dart';

class TaskUtility {
  static Future<TaskResult> run<T>({required Future Function() task}) async {
    late final DateTime startedAt;
    late final DateTime endedAt;
    late TaskResult result;

    navigatorKey.currentContext!.read<BaseProvider>().isBusy = true;
    startedAt = DateTime.now().toUtc();
    result = TaskResult();

    try {
      result.result = await task().timeout(const Duration(seconds: 10));
      result.isError = false;
      result.message = '';
    } on TimeoutException {
      result.isError = true;
      result.message = 'Timeout';
    } catch (e) {
      result.isError = true;
      result.message = e.toString();
    } finally {
      endedAt = DateTime.now().toUtc();
      result.elapsedTime = endedAt.difference(startedAt).inSeconds;
      navigatorKey.currentContext!.read<BaseProvider>().isBusy = false;
    }

    if (result.isError != null && result.isError! && (result.message ?? '').isNotEmpty) {
      await CommonWidgetUtility.showError(message: result.message!);
    }

    return result;
  }
}
