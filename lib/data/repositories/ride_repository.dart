import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
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
        fromFirestore: (doc, _) {
          final data = doc.data()!;
          // Convert Firestore List of Maps back to List<LatLng>
          final List<dynamic>? routePointsJson = data['routePoints'];
          final List<LatLng> routePoints = routePointsJson != null
              ? routePointsJson.map((p) => LatLng(p['lat'], p['lng'])).toList()
              : [];
          
          return RideModel.fromJson({
            ...data, 
            'id': doc.id,
            'routePoints': [], // temporary, will be set via copyWith below
          }).copyWith(routePoints: routePoints);
        },
        toFirestore: (ride, _) {
          final json = <String, dynamic>{
            'riderId': ride.riderId,
            'driverId': ride.driverId,
            'fromLocation': ride.fromLocation.toJson(),
            'toLocation': ride.toLocation.toJson(),
            'routePoints': ride.routePoints.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
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

  /// Get rides where user is a passenger (via bookings)
  Stream<List<RideModel>> getPassengerRides(String userId, String status) {
    // 1. Get user bookings with specific status
    // Note: status here refers to ride status
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((bookingSnapshot) async {
      final List<RideModel> rides = [];
      
      for (var bookingDoc in bookingSnapshot.docs) {
        final rideId = bookingDoc.data()['rideId'] as String;
        final rideDoc = await _ridesRef.doc(rideId).get();
        
        if (rideDoc.exists) {
          final ride = rideDoc.data()!;
          if (ride.status == status) {
            rides.add(ride);
          }
        }
      }
      
      // Sort by departure time descending
      rides.sort((a, b) => b.departureTime.compareTo(a.departureTime));
      return rides;
    });
  }
}
