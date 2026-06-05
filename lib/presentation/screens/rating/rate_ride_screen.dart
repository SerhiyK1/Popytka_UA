import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/domain/models/rating_model.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/data/repositories/rating_repository.dart';

class RateRideScreen extends ConsumerStatefulWidget {
  final String rideId;
  final String ratedId;

  const RateRideScreen({
    super.key,
    required this.rideId,
    required this.ratedId,
  });

  @override
  RateRideScreenState createState() => RateRideScreenState();
}

class RateRideScreenState extends ConsumerState<RateRideScreen> {
  double _rating = 0;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final currentUser = ref.watch(currentUserProvider).value;

    if (localizations == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.rate_your_trip),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.how_was_your_trip, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 40,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: localizations.leave_a_comment,
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (currentUser != null && _rating > 0)
                    ? () async {
                        final newRating = RatingModel(
                          id: '', // Firestore will generate it
                          rideId: widget.rideId,
                          raterId: currentUser.id,
                          ratedId: widget.ratedId,
                          rating: _rating,
                          comment: _commentController.text.isNotEmpty
                              ? _commentController.text
                              : null,
                          createdAt: DateTime.now(),
                        );
                        await ref.read(ratingRepositoryProvider).createRating(newRating);
                        if (mounted) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                child: Text(localizations.submit_rating),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
