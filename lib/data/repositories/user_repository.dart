import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/user_model.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(FirebaseFirestore.instance);
}

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  CollectionReference<UserModel?> get _usersRef => _firestore
      .collection('users')
      .withConverter<UserModel?>(
        fromFirestore: (doc, _) {
          final data = doc.data();
          if (data == null) return null;
          return UserModel.fromJson({...data, 'id': doc.id});
        },
        toFirestore: (user, _) {
          if (user == null) return {};
          final json = user.toJson();
          json.remove('id');
          return json;
        },
      );

  Future<void> createUser(UserModel user) async {
    await _usersRef.doc(user.id).set(user);
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    return doc.data();
  }

  Future<void> updateUser(UserModel user) async {
    await _usersRef.doc(user.id).update(user.toJson()..remove('id'));
  }

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await _usersRef.doc(userId).update(data);
  }

  Stream<UserModel?> streamUser(String uid) {
    return _usersRef.doc(uid).snapshots().map((doc) => doc.data());
  }
}
