import 'package:flutter/foundation.dart';
import '../../domain/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  bool hasPermission(String permission) {
    return _currentUser?.permissions.contains(permission) ?? false;
  }
}