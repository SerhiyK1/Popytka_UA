import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/transaction_model.dart';
import 'auth_repository.dart';

part 'wallet_repository.g.dart';

class WalletRepository {
  final FirebaseFirestore _firestore;
  final String? _currentUserId;

  WalletRepository(this._firestore, this._currentUserId);

  Stream<List<TransactionModel>> getTransactions() {
    if (_currentUserId == null) return Stream.value([]);

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  Future<void> topUp(double amount) async {
    if (_currentUserId == null) return;

    final batch = _firestore.batch();
    final transactionRef = _firestore.collection('transactions').doc();
    final userRef = _firestore.collection('users').doc(_currentUserId);

    batch.set(transactionRef, {
      'userId': _currentUserId,
      'amount': amount,
      'type': 'topup',
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'completed',
    });

    batch.update(userRef, {
      'balance': FieldValue.increment(amount),
    });

    await batch.commit();
  }

  Future<void> withdraw(double amount) async {
    if (_currentUserId == null) return;

    final batch = _firestore.batch();
    final transactionRef = _firestore.collection('transactions').doc();
    final userRef = _firestore.collection('users').doc(_currentUserId);

    batch.set(transactionRef, {
      'userId': _currentUserId,
      'amount': -amount,
      'type': 'withdrawal',
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'completed',
    });

    batch.update(userRef, {
      'balance': FieldValue.increment(-amount),
    });

    await batch.commit();
  }
}

@riverpod
WalletRepository walletRepository(Ref ref) {
  final firestore = FirebaseFirestore.instance;
  final authRepo = ref.watch(authRepositoryProvider);
  return WalletRepository(firestore, authRepo.currentUser?.uid);
}
