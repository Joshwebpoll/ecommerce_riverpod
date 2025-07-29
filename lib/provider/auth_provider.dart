import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<String>>((
  ref,
) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<String>> {
  final Ref ref;
  AuthNotifier(this.ref) : super(const AsyncValue.data(''));

  Future<void> checkLogin() async {
    try {
      final token = ref.read(authProvider.notifier).checkLogin();
      // print(token);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final message = await ref
          .read(authServiceProvider)
          .login(email, password);

      state = AsyncValue.data(message);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      final message = await ref.read(authServiceProvider).passwordReset(email);
      state = AsyncValue.data(message);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authServiceProvider).deleteToken();
      state = AsyncValue.data('Logout successfully');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> verifyResetPassword(String emailCode) async {
    state = const AsyncValue.loading();
    try {
      final message = await ref
          .read(authServiceProvider)
          .verifyPasswordReset(emailCode);
      state = AsyncValue.data(message);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updatePassord(
    String password,
    String confirmpassword,
    String resetCode,
  ) async {
    state = const AsyncValue.loading();
    try {
      final message = await ref
          .read(authServiceProvider)
          .updateResentPassword(password, confirmpassword, resetCode);
      state = AsyncValue.data(message);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> verifyEmail(String emailCode) async {
    state = const AsyncValue.loading();
    try {
      final message = await ref
          .read(authServiceProvider)
          .verifyEmail(emailCode);
      state = AsyncValue.data(message);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> register(
    String email,

    // String confirmPassword,
    // String username,
    String name,
    String password,
    // String phoneNumber,
  ) async {
    state = const AsyncValue.loading();
    try {
      final message = await ref
          .read(authServiceProvider)
          .register(
            email,
            name,
            password,
            // confirmPassword,
            // username,
            // phoneNumber,
          );
      state = AsyncValue.data(message);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<bool> logOut() async {
    try {
      await ref.read(authServiceProvider).deleteTokens();
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(""); // ✅ Reset state after success
  }
}
