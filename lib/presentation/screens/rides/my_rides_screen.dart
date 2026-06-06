import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:popytka_ua/data/repositories/ride_repository.dart';
import 'package:popytka_ua/data/repositories/ride_request_repository.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/domain/models/ride_model.dart';
import 'package:popytka_ua/domain/models/ride_request_model.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_transform/stream_transform.dart';

class MyRidesScreen extends ConsumerStatefulWidget {
  const MyRidesScreen({super.key});

  @override
  ConsumerState<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends ConsumerState<MyRidesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDriverMode = true; // Toggle between Driver and Passenger

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.my_rides,
          style: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Role Toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _buildRoleOption(t.driver_label, _isDriverMode, () {
                        setState(() => _isDriverMode = true);
                      }, onSurface),
                      _buildRoleOption(t.passenger_label, !_isDriverMode, () {
                        setState(() => _isDriverMode = false);
                      }, onSurface),
                    ],
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: onSurface.withValues(alpha: 0.54),
                indicatorWeight: 3,
                tabs: [
                  Tab(text: t.tab_active),
                  Tab(text: t.tab_planned),
                  Tab(text: t.tab_completed),
                ],
              ),
            ],
          ),
        ),
      ),
      body: currentUser.when(
        data: (user) => user == null
            ? Center(child: Text(t.please_login, style: TextStyle(color: onSurface)))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildRidesList('active', user.id, onSurface),
                  _buildRidesList('pending', user.id, onSurface),
                  _buildRidesList('completed', user.id, onSurface),
                ],
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '${t.error_prefix}$error',
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String label, bool isActive, VoidCallback onTap, Color onSurface) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : onSurface.withValues(alpha: 0.54),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRidesList(String status, String userId, Color onSurface) {
    final t = AppLocalizations.of(context)!;
    
    if (_isDriverMode) {
      return StreamBuilder<List<RideModel>>(
        stream: ref.read(rideRepositoryProvider).getUserRides(userId, status),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return _buildErrorState(snapshot.error, t);
          final rides = snapshot.data ?? [];
          if (rides.isEmpty) return _buildEmptyState(status, onSurface);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rides.length,
            itemBuilder: (context, index) => _buildRideCard(rides[index], onSurface),
          );
        },
      );
    } else {
      // Passenger mode combines real Bookings AND Search Requests
      return StreamBuilder<List<dynamic>>(
        stream: _getPassengerActivityStream(userId, status),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return _buildErrorState(snapshot.error, t);
          final items = snapshot.data ?? [];
          if (items.isEmpty) return _buildEmptyState(status, onSurface);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (item is RideModel) return _buildRideCard(item, onSurface);
              if (item is RideRequestModel) return _buildRequestCard(item, onSurface);
              return const SizedBox.shrink();
            },
          );
        },
      );
    }
  }

  Stream<List<dynamic>> _getPassengerActivityStream(String userId, String status) {
    // Combine real bookings and search requests using stream_transform
    final bookingsStream = ref.read(rideRepositoryProvider).getPassengerRides(userId, status);
    final requestsStream = ref.read(rideRequestRepositoryProvider).getUserRequests(userId, status);

    return bookingsStream.combineLatest(requestsStream, (List<RideModel> rides, List<RideRequestModel> requests) {
      final combined = <dynamic>[...rides, ...requests];
      // Sort by time
      combined.sort((a, b) {
        final timeA = a is RideModel ? a.departureTime : (a as RideRequestModel).departureTime;
        final timeB = b is RideModel ? b.departureTime : (b as RideRequestModel).departureTime;
        return timeB.compareTo(timeA);
      });
      return combined;
    });
  }

  Widget _buildErrorState(Object? error, AppLocalizations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text('${t.error_prefix}$error', style: const TextStyle(color: Colors.redAccent), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String status, Color onSurface) {
    final t = AppLocalizations.of(context)!;
    String message;
    IconData icon;

    if (_isDriverMode) {
      switch (status) {
        case 'active': message = t.no_active_rides; icon = Icons.directions_car; break;
        case 'pending': message = t.no_planned_rides; icon = Icons.schedule; break;
        case 'completed': message = t.no_completed_rides; icon = Icons.check_circle_outline; break;
        default: message = t.no_rides_found; icon = Icons.directions_car_outlined;
      }
    } else {
      message = "У вас немає активності пасажира у цьому розділі";
      icon = Icons.bookmark_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: onSurface.withValues(alpha: 0.12)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.54),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard(RideModel ride, Color onSurface) {
    final t = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_isDriverMode)
             Padding(
               padding: const EdgeInsets.only(bottom: 8),
               child: Row(
                 children: [
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                     decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                     child: const Text("ЗАБРОНЬОВАНО", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                   ),
                 ],
               ),
             ),
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${ride.fromLocation.city} → ${ride.toLocation.city}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface),
                ),
              ),
              _buildStatusChip(ride.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateFormat.format(ride.departureTime), style: TextStyle(color: onSurface.withValues(alpha: 0.7))),
                    const SizedBox(height: 4),
                    Text(
                      _isDriverMode ? '${ride.seatsAvailable} ${t.seats_available}' : 'Поїздка підтверджена',
                      style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text('₴${ride.pricePerSeat.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.push('/ride_details', extra: ride),
                child: Text(t.btn_details, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              if (_isDriverMode && ride.status == 'pending') ...[
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _showEditRideDialog(ride),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(t.btn_edit),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(RideRequestModel request, Color onSurface) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return GlassContainer(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                  child: const Text("ЗАПИТ НА ПОШУК", style: TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.search, color: AppColors.secondary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${request.fromCity} → ${request.toCity}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface),
                ),
              ),
              _buildStatusChip(request.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateFormat.format(request.departureTime), style: TextStyle(color: onSurface.withValues(alpha: 0.7))),
                    const SizedBox(height: 4),
                    Text("Шукаємо водіїв для вас...", style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => ref.read(rideRequestRepositoryProvider).cancelRequest(request.id),
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final dateStr = request.departureTime.toIso8601String().split('T').first;
                final timeStr = "${request.departureTime.hour}:${request.departureTime.minute}";
                context.push('/search_results?from=${request.fromCity}&to=${request.toCity}&date=$dateStr&time=$timeStr&seats=${request.seatsRequired}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary, 
                foregroundColor: Colors.white,
              ),
              child: const Text("Повторити пошук", style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final t = AppLocalizations.of(context)!;
    Color color;
    String text;

    switch (status) {
      case 'active': color = Colors.green; text = t.tab_active; break;
      case 'pending': color = Colors.orange; text = t.tab_planned; break;
      case 'completed': color = Colors.blue; text = t.tab_completed; break;
      case 'cancelled': color = Colors.red; text = t.status_cancelled; break;
      default: color = Colors.grey; text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.5))),
      child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  void _showEditRideDialog(RideModel ride) {
    context.push('/edit_ride', extra: ride);
  }
}
