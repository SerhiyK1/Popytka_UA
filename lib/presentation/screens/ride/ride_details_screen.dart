import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/surface_card.dart';
import 'package:popytka_ua/domain/models/ride_model.dart';
import 'package:popytka_ua/domain/models/booking_model.dart';
import 'package:popytka_ua/domain/models/chat_model.dart';
import 'package:popytka_ua/data/repositories/booking_repository.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';
import 'package:popytka_ua/data/repositories/ride_repository.dart';
import 'package:popytka_ua/data/repositories/chat_repository.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/data/services/osrm_routing_service.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';

class RideDetailsScreen extends ConsumerStatefulWidget {
  final RideModel ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  ConsumerState<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends ConsumerState<RideDetailsScreen> with TickerProviderStateMixin {
  bool _isBooking = false;
  int _bookSeats = 1;
  late AnimationController _pulseController;
  late final AnimatedMapController _mapController;
  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = true;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    // Initial route points (straight line until OSRM loads)
    _routePoints = [
      LatLng(widget.ride.fromLocation.latitude, widget.ride.fromLocation.longitude),
      LatLng(widget.ride.toLocation.latitude, widget.ride.toLocation.longitude),
    ];
    
    _loadRealRoute();
  }

  Future<void> _loadRealRoute() async {
    final start = LatLng(widget.ride.fromLocation.latitude, widget.ride.fromLocation.longitude);
    final end = LatLng(widget.ride.toLocation.latitude, widget.ride.toLocation.longitude);
    
    final points = await ref.read(osrmRoutingServiceProvider).getRoute(
      start,
      end,
      waypoints: widget.ride.waypoints.map((w) => LatLng(w.latitude, w.longitude)).toList(),
    );
    
    if (mounted) {
      setState(() {
        _routePoints = points;
        _isLoadingRoute = false;
      });
      
      // Auto-fit bounds with animation
      if (points.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints(points);
        _mapController.animatedFitCamera(
          cameraFit: CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 150),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          t.cancel_ride_title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    
    final user = ref.watch(authRepositoryProvider).currentUser;

    return StreamBuilder<RideModel?>(
      stream: ref.watch(rideRepositoryProvider).streamRide(widget.ride.id),
      initialData: widget.ride,
      builder: (context, snapshot) {
        final ride = snapshot.data ?? widget.ride;
        final isOwner = user != null && ride.riderId == user.uid;

        final fromLatLng = LatLng(ride.fromLocation.latitude, ride.fromLocation.longitude);
        final toLatLng = LatLng(ride.toLocation.latitude, ride.toLocation.longitude);

        return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.ride_details_title,
          style: TextStyle(color: onSurface),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // 1. Map Background with dynamic real route
          FlutterMap(
            mapController: _mapController.mapController,
            options: MapOptions(
              initialCenter: LatLng(
                (fromLatLng.latitude + toLatLng.latitude) / 2,
                (fromLatLng.longitude + toLatLng.longitude) / 2,
              ),
              initialZoom: 7.0,
            ),
            children: [
              TileLayer(
                urlTemplate: isDark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: AppColors.secondary.withValues(alpha: 0.8),
                    strokeWidth: 4.0,
                    pattern: _isLoadingRoute 
                        ? const StrokePattern.dotted() 
                        : const StrokePattern.solid(), // Dotted while loading real route
                  ),
                ],
              ),
               MarkerLayer(
                markers: [
                  _buildPulsingMarker(fromLatLng.latitude, fromLatLng.longitude, isOrigin: true),
                  for (var wp in ride.waypoints)
                    Marker(
                      point: LatLng(wp.latitude, wp.longitude),
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary.withValues(alpha: 0.8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.place,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  _buildPulsingMarker(toLatLng.latitude, toLatLng.longitude, isOrigin: false),
                ],
              ),
            ],
          ),

          if (_isLoadingRoute)
             const Positioned(
               top: kToolbarHeight + 50,
               left: 0,
               right: 0,
               child: Center(
                 child: Card(
                   child: Padding(
                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     child: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         SizedBox(
                           width: 14,
                           height: 14,
                           child: CircularProgressIndicator(strokeWidth: 2),
                         ),
                         SizedBox(width: 12),
                         Text("Завантаження маршруту...", style: TextStyle(fontSize: 12)),
                       ],
                     ),
                   ),
                 ),
               ),
             ),

          // 2. Info Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(
                                  ride.waypoints.isEmpty
                                      ? "${ride.fromLocation.city} -> ${ride.toLocation.city}"
                                      : "${ride.fromLocation.city} -> ${ride.waypoints.map((w) => w.city).join(' -> ')} -> ${ride.toLocation.city}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                                ),
                                Text(
                                  t.today_label,
                                  style: TextStyle(
                                    color: onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.event_seat,
                                      color: AppColors.secondary,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Вільних місць: ${ride.seatsAvailable}",
                                      style: TextStyle(
                                        color: onSurface.withValues(alpha: 0.8),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: onSurface.withValues(alpha: 0.5),
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
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: onSurface,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: _bookSeats < ride.seatsAvailable
                                            ? AppColors.primary
                                            : onSurface.withValues(alpha: 0.2),
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
                      // Driver Info
                      Consumer(
                        builder: (context, ref, child) {
                          final driverId = ride.driverId ?? ride.riderId;
                          final driverAsync = ref.watch(userByIdProvider(driverId));

                          return driverAsync.when(
                            data: (driver) {
                              if (driver == null) {
                                return const SizedBox.shrink();
                              }

                              // Find the specific car assigned to the ride
                              final car = driver.cars.isEmpty
                                  ? null
                                  : (driver.cars.firstWhere(
                                      (c) => c.id == ride.carId,
                                      orElse: () => driver.cars.first,
                                    ));

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SurfaceCard(
                                    padding: const EdgeInsets.all(12),
                                    color: onSurface.withValues(alpha: 0.05),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                                          backgroundImage: driver.photoUrl != null
                                              ? NetworkImage(driver.photoUrl!)
                                              : null,
                                          child: driver.photoUrl == null
                                              ? const Icon(Icons.person, color: AppColors.secondary)
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                t.driver_info,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: onSurface.withValues(alpha: 0.6),
                                                ),
                                              ),
                                              Text(
                                                isOwner ? t.you_label : driver.name,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: onSurface,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          driver.numberOfRatings > 0
                                              ? driver.averageRating.toStringAsFixed(1)
                                              : "5.0",
                                          style: TextStyle(color: onSurface),
                                        ),
                                        if (!isOwner) ...[
                                          const SizedBox(width: 8),
                                          IconButton(
                                            icon: const Icon(Icons.chat_bubble_outline, color: AppColors.primary),
                                            onPressed: () async {
                                              final currentUserId = ref.read(authRepositoryProvider).currentUser?.uid;
                                              if (currentUserId == null) {
                                                context.push('/login');
                                                return;
                                              }
                                              
                                              try {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) => const Center(
                                                    child: CircularProgressIndicator(),
                                                  ),
                                                );
                                                
                                                final chatId = await ref.read(chatRepositoryProvider).createChat(currentUserId, driverId);
                                                
                                                if (context.mounted) {
                                                  Navigator.of(context).pop(); // Close loading dialog
                                                }
                                                
                                                final sortedIds = [currentUserId, driverId]..sort();
                                                final chat = ChatModel(
                                                  id: chatId,
                                                  participantIds: sortedIds,
                                                  lastMessageTime: DateTime.now(),
                                                );
                                                
                                                if (context.mounted) {
                                                  context.push('/chat_room', extra: chat);
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  Navigator.of(context).pop(); // Close loading dialog
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text("Помилка створення чату: $e")),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (car != null) ...[
                                    const SizedBox(height: 8),
                                    SurfaceCard(
                                      padding: const EdgeInsets.all(12),
                                      color: onSurface.withValues(alpha: 0.03),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.directions_car,
                                            color: AppColors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Автомобіль",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: onSurface.withValues(alpha: 0.5),
                                                  ),
                                                ),
                                                Text(
                                                  "${car.brand} ${car.model}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: onSurface,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  "${car.color} • ${car.plate} • ${car.year} р.",
                                                  style: TextStyle(
                                                    color: onSurface.withValues(alpha: 0.6),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            error: (e, _) => Center(child: Text("Помилка завантаження водія: $e")),
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                      Text(
                        "Пасажири поїздки",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<List<BookingModel>>(
                        stream: ref.read(bookingRepositoryProvider).getRideBookings(ride.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                          }
                          if (snapshot.hasError) {
                            return Text("Помилка: ${snapshot.error}");
                          }
                          final bookings = snapshot.data ?? [];
                          if (bookings.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                "Пасажири ще не долучилися",
                                style: TextStyle(
                                  color: onSurface.withValues(alpha: 0.5),
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13,
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              final booking = bookings[index];
                              return Consumer(
                                builder: (context, ref, child) {
                                  final userAsync = ref.watch(userByIdProvider(booking.userId));
                                  return userAsync.when(
                                    data: (passenger) {
                                      if (passenger == null) return const SizedBox.shrink();
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: SurfaceCard(
                                          padding: const EdgeInsets.all(8),
                                          color: onSurface.withValues(alpha: 0.02),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 16,
                                                backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                                                backgroundImage: passenger.photoUrl != null
                                                    ? NetworkImage(passenger.photoUrl!)
                                                    : null,
                                                child: passenger.photoUrl == null
                                                    ? const Icon(Icons.person, size: 16, color: AppColors.secondary)
                                                    : null,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  passenger.name,
                                                  style: TextStyle(
                                                    color: onSurface,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              if (isOwner) ...[
                                                IconButton(
                                                  icon: const Icon(Icons.chat_bubble_outline, size: 18, color: AppColors.primary),
                                                  onPressed: () async {
                                                    final currentUserId = ref.read(authRepositoryProvider).currentUser?.uid;
                                                    if (currentUserId == null) return;
                                                    
                                                    try {
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (context) => const Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      );
                                                      
                                                      final chatId = await ref.read(chatRepositoryProvider).createChat(currentUserId, passenger.id);
                                                      
                                                      if (context.mounted) {
                                                        Navigator.of(context).pop(); // Close loading dialog
                                                      }
                                                      
                                                      final sortedIds = [currentUserId, passenger.id]..sort();
                                                      final chat = ChatModel(
                                                        id: chatId,
                                                        participantIds: sortedIds,
                                                        lastMessageTime: DateTime.now(),
                                                      );
                                                      
                                                      if (context.mounted) {
                                                        context.push('/chat_room', extra: chat);
                                                      }
                                                    } catch (e) {
                                                      if (context.mounted) {
                                                        Navigator.of(context).pop(); // Close loading dialog
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("Помилка створення чату: $e")),
                                                        );
                                                      }
                                                    }
                                                  },
                                                ),
                                                const SizedBox(width: 8),
                                                if (ride.status == 'completed') ...[
                                                  IconButton(
                                                    icon: const Icon(Icons.star_outline, size: 18, color: Colors.amber),
                                                    onPressed: () {
                                                      context.push('/rate_ride', extra: {
                                                        'rideId': ride.id,
                                                        'ratedId': passenger.id,
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 8),
                                                ],
                                              ],
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "${booking.seats} місць",
                                                  style: const TextStyle(
                                                    color: AppColors.primary,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    loading: () => const SizedBox(
                                      height: 40,
                                      child: Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 1.5))),
                                    ),
                                    error: (e, _) => Text("Помилка: $e"),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: isOwner
                            ? _buildDriverActions(ride, t, onSurface)
                            : _buildPassengerActions(ride, t, onSurface),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildDriverActions(RideModel ride, AppLocalizations t, Color onSurface) {
    if (ride.status == 'pending') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                try {
                  await ref.read(rideRepositoryProvider).updateRideStatus(ride.id, 'active');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Поїздку розпочато!")),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Помилка початку поїздки: $e")),
                    );
                  }
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Почати поїздку"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/edit_ride', extra: ride);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(t.btn_edit),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _cancelRide,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
                    foregroundColor: Colors.redAccent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(t.cancel),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (ride.status == 'active') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              await ref.read(rideRepositoryProvider).updateRideStatus(ride.id, 'completed');
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Поїздку завершено!")),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Помилка завершення поїздки: $e")),
                );
              }
            }
          },
          icon: const Icon(Icons.check),
          label: const Text("Завершити поїздку"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    } else if (ride.status == 'completed') {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Поїздку завершено! Дякуємо за поїздку.",
          style: TextStyle(
            color: onSurface.withValues(alpha: 0.54),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Поїздку скасовано",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }
  }

  Widget _buildPassengerActions(RideModel ride, AppLocalizations t, Color onSurface) {
    if (ride.status == 'pending') {
      return ElevatedButton(
        onPressed: _isBooking || ride.seatsAvailable < 1 || _bookSeats < 1 ? null : _bookRide,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isBooking
            ? const CircularProgressIndicator(color: Colors.black)
            : Text(
                ride.seatsAvailable > 0 ? "Забронювати ($_bookSeats)" : t.no_seats,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
      );
    } else if (ride.status == 'active') {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Поїздка в дорозі...",
          style: TextStyle(
            color: onSurface.withValues(alpha: 0.54),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    } else if (ride.status == 'completed') {
      return ElevatedButton.icon(
        onPressed: () {
          context.push('/rate_ride', extra: {
            'rideId': ride.id,
            'ratedId': ride.driverId ?? ride.riderId,
          });
        },
        icon: const Icon(Icons.star),
        label: const Text("Оцінити водія"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "Поїздку скасовано",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }
  }

  Marker _buildPulsingMarker(double lat, double lng, {bool isOrigin = true}) {
    final color = isOrigin ? AppColors.primary : AppColors.secondary;
    return Marker(
      point: LatLng(lat, lng),
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer pulsing ring
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final val = _pulseController.value;
              return Opacity(
                opacity: 1.0 - val,
                child: Transform.scale(
                  scale: 1.0 + (val * 1.5),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              );
            },
          ),
          // Inner dot
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.8),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
