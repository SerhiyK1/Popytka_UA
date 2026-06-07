import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/surface_card.dart';
import 'package:popytka_ua/data/repositories/ride_repository.dart';
import 'package:popytka_ua/domain/models/ride_model.dart'; // Import RideModel

class SearchResultsScreen extends ConsumerWidget {
  final String fromCity;
  final String toCity;
  final String? selectedDate;
  final String? selectedTime;
  final int requiredSeats;

  const SearchResultsScreen({
    super.key,
    required this.fromCity,
    required this.toCity,
    this.selectedDate,
    this.selectedTime,
    this.requiredSeats = 1,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;

    // We need a stream that filters.
    // Ideally we add a method to repository: searchRides(from, to)
    // For now, let's just get ALL rides and filter client side (MVP Shortcut)
    // OR add `searchRides` to repo now (Clean). Let's do client-side filter for speed on small scale.
    // Actually, I'll use the existing `streamRides` and filter in the UI builder.

    final ridesAsync = ref
        .watch(rideRepositoryProvider)
        .streamRides(); // Assuming this exists or I add it

    return Scaffold(
      appBar: AppBar(title: Text("$fromCity -> $toCity"), centerTitle: true),
      body: StreamBuilder<List<RideModel>>(
        stream: ridesAsync,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rides = snapshot.data!;
          // Client-side filtering
          final filtered = rides.where((r) {
            final fromCityClean = fromCity.split(',').first.trim().toLowerCase();
            final toCityClean = toCity.split(',').first.trim().toLowerCase();
            final rideFromCity = r.fromLocation.city.toLowerCase();
            final rideToCity = r.toLocation.city.toLowerCase();

            // Flexible city matching: either ride city is in search string, or vice versa
            final matchesFrom = fromCity.toLowerCase().contains(rideFromCity) || 
                                rideFromCity.contains(fromCityClean);
            final matchesTo = toCity.toLowerCase().contains(rideToCity) || 
                              rideToCity.contains(toCityClean);

            final matchesCity = matchesFrom && matchesTo;

            if (!matchesCity) return false;

            // Filter by required seats
            if (r.seatsAvailable < requiredSeats) return false;

            if (selectedDate != null && selectedDate!.isNotEmpty) {
              final searchDate = DateTime.tryParse(selectedDate!);
              if (searchDate != null) {
                final isSameDay =
                    r.departureTime.year == searchDate.year &&
                    r.departureTime.month == searchDate.month &&
                    r.departureTime.day == searchDate.day;

                if (!isSameDay) return false;

                if (selectedTime != null && selectedTime!.contains(':')) {
                  final parts = selectedTime!.split(':');
                  if (parts.length == 2) {
                    final searchHour = int.tryParse(parts[0]) ?? 0;
                    final searchMin = int.tryParse(parts[1]) ?? 0;

                    final rideMins =
                        r.departureTime.hour * 60 + r.departureTime.minute;
                    final searchMins = searchHour * 60 + searchMin;

                    // Show rides leaving up to 2 hours before the requested time and any time after on that day
                    if (rideMins < searchMins - 120) return false;
                  }
                }
                return true;
              }
            }

            // Exclude past rides if no specific date is searched
            return r.departureTime.isAfter(
              DateTime.now().subtract(const Duration(hours: 1)),
            );
          }).toList();

          filtered.sort((a, b) => a.departureTime.compareTo(b.departureTime));

          if (filtered.isEmpty) {
            return Center(
              child: Text(
                t.no_results,
                style: const TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final ride = filtered[index];
              return _RideResultCard(
                ride: ride,
                onTap: () {
                  context.push('/ride_details', extra: ride);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _RideResultCard extends StatelessWidget {
  final RideModel ride;
  final VoidCallback onTap;

  const _RideResultCard({required this.ride, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      child: Row(
        children: [
          // Time
          Column(
            children: [
              Text(
                _formatTime(ride.departureTime),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Icon(Icons.arrow_downward, size: 16, color: Colors.white54),
              Text(
                _formatTime(ride.departureTime.add(const Duration(hours: 2))),
                style: const TextStyle(color: Colors.white54),
              ), // Mock arrival
            ],
          ),
          const SizedBox(width: 16),

          // Route
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${ride.fromLocation.city} -> ${ride.toLocation.city}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(
                      "Водій",
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Price
          Text(
            "${ride.pricePerSeat} ₴",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
