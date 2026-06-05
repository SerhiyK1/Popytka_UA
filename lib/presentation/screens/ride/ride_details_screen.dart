import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/surface_card.dart';
import 'package:popytka_ua/domain/models/ride_model.dart';
import 'package:popytka_ua/data/repositories/booking_repository.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';
import 'package:popytka_ua/data/repositories/ride_repository.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RideDetailsScreen extends ConsumerStatefulWidget {
  final RideModel ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  ConsumerState<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends ConsumerState<RideDetailsScreen> {
  bool _isBooking = false;
  int _bookSeats = 1;

  void _bookRide() async {
    setState(() => _isBooking = true);

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      context.push('/login');
      return;
    }

    try {
      await ref
          .read(bookingRepositoryProvider)
          .createBooking(
            rideId: widget.ride.id,
            userId: user.uid,
            seats: _bookSeats,
            pricePerSeat: widget.ride.pricePerSeat,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.booking_success),
          ),
        );
        context.pop(); // Go back to results
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
        setState(() => _isBooking = false);
      }
    }
  }

  void _cancelRide() async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          t.cancel_ride_title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(t.cancel_ride_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.no),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.yes, style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(rideRepositoryProvider).cancelRide(widget.ride.id);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(t.ride_cancelled)));
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("${t.error_prefix}$e")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final ride = widget.ride;
    final user = ref.watch(authRepositoryProvider).currentUser;
    final isOwner = user != null && ride.riderId == user.uid;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(t.ride_details_title),
      ),
      body: Stack(
        children: [
          // 1. Map Background (Route visualization mocked)
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(49.0, 31.0), // Center of UA
              initialZoom: 6.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              // MarkerLayer would go here
            ],
          ),

          // 2. Info Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${ride.fromLocation.city} -> ${ride.toLocation.city}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              t.today_label,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${(ride.pricePerSeat * _bookSeats).toStringAsFixed(0)} ₴",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            if (!isOwner && ride.seatsAvailable > 0)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      if (_bookSeats > 1) {
                                        setState(() => _bookSeats--);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      '$_bookSeats',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      Icons.add_circle_outline,
                                      color: _bookSeats < ride.seatsAvailable
                                          ? AppColors.primary
                                          : Colors.white24,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      if (_bookSeats < ride.seatsAvailable) {
                                        setState(() => _bookSeats++);
                                      }
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SurfaceCard(
                      padding: const EdgeInsets.all(12),
                      color: Colors.white10,
                      child: Row(
                        children: [
                          const CircleAvatar(child: Icon(Icons.person)),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.driver_info,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                isOwner ? t.you_label : t.driver_placeholder,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const Text("4.9"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: isOwner
                          ? Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      context.push('/publish', extra: ride);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                      foregroundColor: AppColors.primary,
                                    ),
                                    child: Text(t.btn_edit),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _cancelRide,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent
                                          .withValues(alpha: 0.2),
                                      foregroundColor: Colors.redAccent,
                                      elevation: 0,
                                    ),
                                    child: Text(t.cancel),
                                  ),
                                ),
                              ],
                            )
                          : ElevatedButton(
                              onPressed:
                                  _isBooking ||
                                      ride.seatsAvailable < 1 ||
                                      _bookSeats < 1
                                  ? null
                                  : _bookRide,
                              child: _isBooking
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      ride.seatsAvailable > 0
                                          ? "Забронювати ($_bookSeats)"
                                          : t.no_seats,
                                    ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
