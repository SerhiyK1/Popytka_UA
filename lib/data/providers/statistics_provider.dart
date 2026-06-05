import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/statistics_model.dart';

final statisticsProvider = FutureProvider.family<StatisticsModel, String>((
  ref,
  userId,
) async {
  final firestore = FirebaseFirestore.instance;
  int totalRidesPublished = 0;
  int passengersCarried = 0;
  double totalEarned = 0.0;

  int totalRidesAsPassenger = 0;
  double totalSpent = 0.0;

  try {
    // 1. Calculate Passenger Stats
    final passengerBookingsSnapshot = await firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'confirmed')
        .get();

    for (var doc in passengerBookingsSnapshot.docs) {
      final data = doc.data();
      totalRidesAsPassenger++;
      totalSpent += (data['totalPrice'] as num?)?.toDouble() ?? 0.0;
    }

    // 2. Calculate Driver Stats
    final driverRidesSnapshot = await firestore
        .collection('rides')
        .where('driverId', isEqualTo: userId)
        .get();

    totalRidesPublished = driverRidesSnapshot.docs.length;

    for (var rideDoc in driverRidesSnapshot.docs) {
      // Find bookings for this ride
      final rideBookingsSnapshot = await firestore
          .collection('bookings')
          .where('rideId', isEqualTo: rideDoc.id)
          .where('status', isEqualTo: 'confirmed')
          .get();

      for (var bookingDoc in rideBookingsSnapshot.docs) {
        final bookingData = bookingDoc.data();
        passengersCarried += (bookingData['seats'] as num?)?.toInt() ?? 1;
        totalEarned += (bookingData['totalPrice'] as num?)?.toDouble() ?? 0.0;
      }
    }

    return StatisticsModel(
      totalRidesPublished: totalRidesPublished,
      totalRidesAsPassenger: totalRidesAsPassenger,
      totalSpent: totalSpent,
      totalEarned: totalEarned,
      passengersCarried: passengersCarried,
    );
  } catch (e) {
    return const StatisticsModel();
  }
});
