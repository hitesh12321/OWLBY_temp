import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_model.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/db/project_database.dart';

class AppUserProvider extends ChangeNotifier {
  AppUserModel? _user;
  bool _isLoading = true; // Started as true

  AppUserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  /// Load user on app start
  Future<void> loadUser() async {
    try {
      _user = await OwlbyDatabase.instance.getUser();
      print('🟢 loadUser() fetched: $_user');
    } catch (e) {
      print('🔴 loadUser() error: $e');
      _user = null;
    } finally {
      // ✅ FIX: You must turn off loading here!
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save user after login
  Future<void> login(AppUserModel user) async {
    print('🟡 Saving user to DB: ${user.id}');
    await OwlbyDatabase.instance.saveUser(user);
    _user = user;
    notifyListeners();
  }

  /// Clear user on logout
  Future<void> logout() async {
    await OwlbyDatabase.instance.deleteUser();
    _user = null;
    notifyListeners();
  }
}
