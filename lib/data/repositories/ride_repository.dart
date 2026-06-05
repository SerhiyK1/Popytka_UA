import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/ride_model.dart';

part 'ride_repository.g.dart';

@riverpod
RideRepository rideRepository(Ref ref) {
  return RideRepository(FirebaseFirestore.instance);
}

class RideRepository {
  final FirebaseFirestore _firestore;

  RideRepository(this._firestore);

  CollectionReference<RideModel> get _ridesRef => _firestore
      .collection('rides')
      .withConverter(
        fromFirestore: (doc, _) =>
            RideModel.fromJson(doc.data()!..['id'] = doc.id),
        toFirestore: (ride, _) {
          final json = <String, dynamic>{
            'riderId': ride.riderId,
            'driverId': ride.driverId,
            'fromLocation': ride.fromLocation.toJson(),
            'toLocation': ride.toLocation.toJson(),
            'status': ride.status,
            'pricePerSeat': ride.pricePerSeat,
            'seatsAvailable': ride.seatsAvailable,
            'departureTime': ride.departureTime.toIso8601String(),
            'createdAt': ride.createdAt.toIso8601String(),
          };
          return json;
        },
      );

  Future<String> createRide(RideModel ride) async {
    try {
      debugPrint('Creating ride: ${ride.toJson()}');
      final docRef = await _ridesRef.add(ride);
      debugPrint('Ride created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e, stackTrace) {
      debugPrint('Error in createRide: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Stream<List<RideModel>> streamRides() {
    return _ridesRef
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> updateRideStatus(String rideId, String status) async {
    await _ridesRef.doc(rideId).update({'status': status});
  }

  Future<void> cancelRide(String rideId) async {
    await updateRideStatus(rideId, 'cancelled');
  }

  Future<void> updateRide(RideModel ride) async {
    await _ridesRef.doc(ride.id).set(ride);
  }

  Stream<RideModel?> streamRide(String rideId) {
    return _ridesRef.doc(rideId).snapshots().map((doc) => doc.data());
  }

  Stream<List<RideModel>> getUserRides(String userId, String status) {
    return _ridesRef
        .where('riderId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('departureTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
