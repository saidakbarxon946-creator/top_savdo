import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  CurrentUserNotifier() : super(null) {
    loadSavedUser();
  }

  Future<void> loadSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('logged_in_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      final savedName = prefs.getString('logged_in_name') ?? savedEmail.split('@').first;
      final savedRole = prefs.getString('logged_in_role') ?? (savedEmail.toLowerCase() == 'admen@gmail.com' ? 'admin' : 'user');

      state = UserModel(
        id: 'active_session',
        name: savedName,
        email: savedEmail,
        role: savedRole,
        createdAt: DateTime.now(),
      );
    }
  }

  void setUser(UserModel user) {
    state = user;
  }

  Future<void> setLoggedInUser(String name, String email) async {
    final cleanEmail = email.trim().toLowerCase();
    final String role = cleanEmail == 'admen@gmail.com' ? 'admin' : 'user';
    final String cleanName = name.trim().isNotEmpty ? name.trim() : cleanEmail.split('@').first;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_email', cleanEmail);
    await prefs.setString('logged_in_name', cleanName);
    await prefs.setString('logged_in_role', role);

    state = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: cleanName,
      email: cleanEmail,
      role: role,
      createdAt: DateTime.now(),
    );
  }

  Future<void> logout() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_email');
    await prefs.remove('logged_in_name');
    await prefs.remove('logged_in_role');
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  return CurrentUserNotifier();
});

final currentUserModelProvider = Provider<UserModel?>((ref) {
  return ref.watch(currentUserProvider);
});
