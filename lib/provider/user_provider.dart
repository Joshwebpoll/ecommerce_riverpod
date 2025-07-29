import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/models/user_model.dart';
import 'package:riverpod_ecommerce/services/user_service.dart';

final authServiceProvider = Provider<UserService>((ref) => UserService());
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>(
  (ref) {
    return UserNotifier(ref);
  },
);

class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  final Ref ref;
  UserNotifier(this.ref) : super(const AsyncLoading()) {
    getUser();
  }
  Future<void> getUser() async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authServiceProvider).getUser();

      state = AsyncData(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
