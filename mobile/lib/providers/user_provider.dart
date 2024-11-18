import 'package:flutter/material.dart';
import 'package:fradel_spies/models/data/user_model.dart';
import 'package:fradel_spies/services/user_service.dart';
import 'package:fradel_spies/utilities/common_widget_utility.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  // Method untuk mengambil data pengguna
  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserModel user = await UserService.get();
      _user = user;
    } catch (e) {
      // Tangani error, misalnya dengan menampilkan pesan kesalahan
      CommonWidgetUtility.showSnackBar(
          message: 'Failed to fetch user data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Method untuk memperbarui data pengguna
  Future<void> updateUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final bool result = await UserService.put(data: user);
      if (result) {
        _user = user; // Perbarui data pengguna
        CommonWidgetUtility.showSnackBar(message: 'User updated successfully');
      } else {
        CommonWidgetUtility.showSnackBar(message: 'Failed to update user');
      }
    } catch (e) {
      // Tangani error, misalnya dengan menampilkan pesan kesalahan
      CommonWidgetUtility.showSnackBar(message: 'Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
