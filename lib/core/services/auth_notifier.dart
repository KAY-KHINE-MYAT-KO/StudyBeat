import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'session_service.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn;
  late final StreamSubscription<User?> _sub;

  AuthNotifier() : _isLoggedIn = FirebaseAuth.instance.currentUser != null {
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      final loggedIn = user != null;
      if (loggedIn != _isLoggedIn) {
        _isLoggedIn = loggedIn;
        await SessionService.setLoggedIn(loggedIn);
        notifyListeners();
      }
    });
  }

  bool get isLoggedIn => _isLoggedIn;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
