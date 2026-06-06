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
    
    final points = await ref.read(osrmRoutingServiceProvider).getRoute(start, end);
    
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
    
    final ride = widget.ride;
    final user = ref.watch(authRepositoryProvider).currentUser;
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
                                  "${ride.fromLocation.city} -> ${ride.toLocation.city}",
                                  style: TextStyle(
                                    fontSize: 20,
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
                      SurfaceCard(
                        padding: const EdgeInsets.all(12),
                        color: onSurface.withValues(alpha: 0.05),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                              child: const Icon(Icons.person, color: AppColors.secondary),
                            ),
                            const SizedBox(width: 12),
                            Column(
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
                                  isOwner ? t.you_label : t.driver_placeholder,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "4.9",
                              style: TextStyle(color: onSurface),
                            ),
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
                                        context.push('/edit_ride', extra: ride);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColors.primary,
                                        ),
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
                                        backgroundColor: Colors.redAccent
                                            .withValues(alpha: 0.2),
                                        foregroundColor: Colors.redAccent,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                                        ride.seatsAvailable > 0
                                            ? "Забронювати ($_bookSeats)"
                                            : t.no_seats,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                              ),
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
