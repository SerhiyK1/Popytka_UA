import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/ride_request_model.dart';

part 'ride_request_repository.g.dart';

@riverpod
RideRequestRepository rideRequestRepository(Ref ref) {
  return RideRequestRepository(FirebaseFirestore.instance);
}

class RideRequestRepository {
  final FirebaseFirestore _firestore;

  RideRequestRepository(this._firestore);

  CollectionReference<RideRequestModel> get _requestsRef => _firestore
      .collection('ride_requests')
      .withConverter(
        fromFirestore: (doc, _) => RideRequestModel.fromJson({...doc.data()!, 'id': doc.id}),
        toFirestore: (request, _) => request.toJson(),
      );

  Future<void> createRequest(RideRequestModel request) async {
    await _requestsRef.add(request);
  }

  Stream<List<RideRequestModel>> getUserRequests(String userId, String status) {
    return _requestsRef
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('departureTime', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> cancelRequest(String requestId) async {
    await _requestsRef.doc(requestId).update({'status': 'cancelled'});
  }
}
