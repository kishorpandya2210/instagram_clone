import 'package:flutter/foundation.dart';
import 'package:social_media/models/user.dart';
import 'package:social_media/resources/auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  final Auth _authMethods = Auth();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
