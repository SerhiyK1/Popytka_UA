import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/domain/models/rating_model.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/data/repositories/rating_repository.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';

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
  bool _hasAlreadyRated = false;
  bool _checkingRating = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyRated();
  }

  Future<void> _checkIfAlreadyRated() async {
    final currentUserId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (currentUserId == null) {
      setState(() => _checkingRating = false);
      return;
    }
    
    try {
      final hasRated = await ref.read(ratingRepositoryProvider).hasRated(
        widget.rideId,
        currentUserId,
        widget.ratedId,
      );
      setState(() {
        _hasAlreadyRated = hasRated;
        _checkingRating = false;
      });
    } catch (e) {
      debugPrint("Error checking rating status: $e");
      setState(() => _checkingRating = false);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final currentUser = ref.watch(currentUserProvider).value;
    final ratedUserAsync = ref.watch(userByIdProvider(widget.ratedId));

    if (localizations == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.rate_your_trip),
      ),
      body: _checkingRating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ratedUserAsync.when(
                    data: (ratedUser) {
                      if (ratedUser == null) {
                        return Text(
                          localizations.how_was_your_trip,
                          style: theme.textTheme.titleLarge,
                        );
                      }
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.1),
                            backgroundImage: ratedUser.photoUrl != null
                                ? NetworkImage(ratedUser.photoUrl!)
                                : null,
                            child: ratedUser.photoUrl == null
                                ? Icon(Icons.person, size: 30, color: theme.colorScheme.secondary)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Як пройшла ваша поїздка з",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ratedUser.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (_, __) => Text(
                      localizations.how_was_your_trip,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_hasAlreadyRated) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Ви вже залишили оцінку для цього користувача за цю поїздку.",
                              style: TextStyle(
                                color: onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ] else ...[
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < _rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 44,
                            ),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1.0;
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _commentController,
                      style: TextStyle(color: onSurface),
                      decoration: InputDecoration(
                        labelText: localizations.leave_a_comment,
                        labelStyle: TextStyle(color: onSurface.withValues(alpha: 0.6)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: theme.colorScheme.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: onSurface.withValues(alpha: 0.12)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (currentUser != null && _rating > 0 && !_isSubmitting)
                            ? () async {
                                setState(() => _isSubmitting = true);
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
                                final navigator = Navigator.of(context);
                                final scaffoldMessenger = ScaffoldMessenger.of(context);
                                try {
                                  await ref.read(ratingRepositoryProvider).createRating(newRating);
                                  if (mounted) {
                                    navigator.pop();
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    setState(() => _isSubmitting = false);
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(content: Text("Помилка відправки оцінки: $e")),
                                    );
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSubmitting
                            ? const CircularProgressIndicator(color: Colors.black)
                            : Text(
                                localizations.submit_rating,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
