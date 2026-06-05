import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../../domain/models/user_model.dart';
import '../../domain/models/car_model.dart';

part 'user_provider.g.dart';

@riverpod
Stream<UserModel?> currentUser(Ref ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);

  final firebaseUser = authRepo.currentUser;
  if (firebaseUser == null) {
    return Stream.value(null);
  }

  return userRepo.streamUser(firebaseUser.uid);
}

// Notifier for user state management
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserModel? build() {
    return null;
  }

  Future<void> updateUserRole(String role) async {
    final currentUserData = ref.read(currentUserProvider).value;
    if (currentUserData == null) return;

    final updatedUser = currentUserData.copyWith(role: role);
    await ref.read(userRepositoryProvider).updateUser(updatedUser);
  }

  Future<void> updateUserProfile({
    String? name,
    String? photoUrl,
    List<CarModel>? cars,
  }) async {
    final currentUserData = ref.read(currentUserProvider).value;
    if (currentUserData == null) return;

    final updatedUser = currentUserData.copyWith(
      name: name ?? currentUserData.name,
      photoUrl: photoUrl ?? currentUserData.photoUrl,
      cars: cars ?? currentUserData.cars,
    );

    await ref.read(userRepositoryProvider).updateUser(updatedUser);
  }
}
