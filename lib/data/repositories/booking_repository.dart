import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/booking_model.dart';

part 'booking_repository.g.dart';

@riverpod
BookingRepository bookingRepository(Ref ref) {
  return BookingRepository(FirebaseFirestore.instance);
}

class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository(this._firestore);

  Future<void> createBooking({
    required String rideId,
    required String userId,
    required int seats,
    required double pricePerSeat,
  }) async {
    final bookingId = _firestore.collection('bookings').doc().id;
    final totalPrice = seats * pricePerSeat;
    final booking = BookingModel(
      id: bookingId,
      rideId: rideId,
      userId: userId,
      seats: seats,
      totalPrice: totalPrice,
      status: 'confirmed', // Auto-confirm for MVP
      createdAt: DateTime.now(),
    );

    // Transaction to ensure atomicity (decrement seats)
    await _firestore.runTransaction((transaction) async {
      // 1. Get Ride Ref
      final rideRef = _firestore.collection('rides').doc(rideId);
      final rideSnapshot = await transaction.get(rideRef);

      if (!rideSnapshot.exists) throw Exception("Ride not found");

      final currentSeats = rideSnapshot.data()?['seatsAvailable'] as int? ?? 0;

      if (currentSeats < seats) {
        throw Exception("Not enough seats available");
      }

      // 2. Decrement Seats
      transaction.update(rideRef, {'seatsAvailable': currentSeats - seats});

      // 3. Save Booking
      final bookingRef = _firestore.collection('bookings').doc(bookingId);
      transaction.set(bookingRef, booking.toJson());
    });
  }

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookingModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
