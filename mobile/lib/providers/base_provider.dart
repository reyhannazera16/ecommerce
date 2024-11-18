import 'package:flutter/material.dart';

import '../models/data/preference_model.dart';
import '../models/utilities/task_result_model.dart';
import '../utilities/sqlite_utility.dart';
import '../utilities/task_utility.dart';

class BaseProvider with ChangeNotifier {
  bool? _isBusy;
  bool? _useLatestApp;
  List<PreferenceModel>? _preferences;
  String? _bearerToken;

  bool get isBusy => _isBusy ?? false;
  bool get useLatestApp => _useLatestApp ??= false;
  List<PreferenceModel> get preferences => _preferences ??= <PreferenceModel>[];
  String? get bearerToken => _bearerToken;

  set isBusy(bool? value) {
    _isBusy = value;
    notifyListeners();
  }

  set useLatestApp(bool? value) {
    _useLatestApp = value;
    notifyListeners();
  }

  set preferences(List<PreferenceModel>? value) {
    _preferences = value;
    notifyListeners();
  }

  set bearerToken(String? value) {
    _bearerToken = value;
    notifyListeners();
  }

  Future<void> init() async {
    await checkAppVersion();

    await getPreferencesFromSqlite();

    await loadBearerToken();
  }

  Future<void> checkAppVersion() async {}

  Future<void> getPreferencesFromSqlite() async {
    final TaskResult result =
        await TaskUtility.run(task: () => SqliteUtility.get(table: 'preferences', fromMap: PreferenceModel.fromMap));
    preferences = result.result as List<PreferenceModel>;
  }

  Future<void> loadBearerToken() async {
    bearerToken = preferences.where((PreferenceModel p) => p.key == 'token').firstOrNull?.value ?? '';
  }

  void reset() {
    _isBusy = null;
    _preferences = null;
  }
}
