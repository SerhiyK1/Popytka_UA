import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/rating_model.dart';
import 'user_repository.dart';

part 'rating_repository.g.dart';

@riverpod
RatingRepository ratingRepository(Ref ref) {
  return RatingRepository(FirebaseFirestore.instance, ref);
}

class RatingRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;

  RatingRepository(this._firestore, this._ref);

  CollectionReference<RatingModel> get _ratingsRef => _firestore
      .collection('ratings')
      .withConverter(
        fromFirestore: (doc, _) {
          final data = Map<String, dynamic>.from(doc.data()!);
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          return RatingModel.fromJson({...data, 'id': doc.id});
        },
        toFirestore: (rating, _) => rating.toJson(),
      );

  Future<void> createRating(RatingModel rating) async {
    await _ratingsRef.add(rating);
    // After adding a new rating, update the user's average rating
    await _updateUserRating(rating.ratedId);
  }

  Stream<List<RatingModel>> getUserRatings(String userId) {
    return _ratingsRef
        .where('ratedId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> _updateUserRating(String userId) async {
    final ratingsSnapshot = await _ratingsRef
        .where('ratedId', isEqualTo: userId)
        .get();

    if (ratingsSnapshot.docs.isEmpty) {
      return;
    }

    final ratings = ratingsSnapshot.docs.map((doc) => doc.data()).toList();
    final double totalRating = ratings.fold(
      0.0,
      (total, item) => total + item.rating,
    );
    final double averageRating = totalRating / ratings.length;
    final int numberOfRatings = ratings.length;

    await _ref.read(userRepositoryProvider).updateUserData(userId, {
      'averageRating': averageRating,
      'numberOfRatings': numberOfRatings,
    });
  }
}
