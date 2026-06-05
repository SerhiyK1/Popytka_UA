// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'9f88f8bfb6e9143cc1329fec50166b3d67fbb275';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeStreamProvider<UserModel?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeStreamProviderRef<UserModel?>;
String _$userNotifierHash() => r'539f55e5724cae19629419e7f33375502516cf05';

/// See also [UserNotifier].
@ProviderFor(UserNotifier)
final userNotifierProvider =
    AutoDisposeNotifierProvider<UserNotifier, UserModel?>.internal(
      UserNotifier.new,
      name: r'userNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserNotifier = AutoDisposeNotifier<UserModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
