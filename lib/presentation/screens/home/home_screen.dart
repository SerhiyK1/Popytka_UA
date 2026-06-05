import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:popytka_ua/presentation/widgets/address_autocomplete_field.dart';
import 'package:popytka_ua/data/services/search_history_service.dart';

import 'package:go_router/go_router.dart';
import 'package:popytka_ua/data/repositories/ride_repository.dart';
import 'package:popytka_ua/domain/models/ride_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _seats = 1;

  List<SearchEntry> _searchEntries = [];
  bool _isHistoryLoaded = false;
  late final AnimatedMapController _mapController;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final service = ref.read(searchHistoryServiceProvider);
    final entries = await service.getDisplayEntries();
    if (mounted) {
      setState(() {
        _searchEntries = entries;
        _isHistoryLoaded = true;
      });
    }
  }

  void _onSearch() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isNotEmpty && to.isNotEmpty) {
      // Save to search history
      final service = ref.read(searchHistoryServiceProvider);
      service.addSearchEntry(from, to).then((_) => _loadSearchHistory());

      final dateStr = _selectedDate.toIso8601String().split('T').first;
      final timeStr = "${_selectedTime.hour}:${_selectedTime.minute}";
      context.push(
        '/search_results?from=$from&to=$to&date=$dateStr&time=$timeStr&seats=$_seats',
      );
    }
  }

  void _onChipTap(SearchEntry entry) {
    setState(() {
      _fromController.text = entry.from;
      _toController.text = entry.to;
    });
    _onSearch();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // 1. MAP LAYER
          FlutterMap(
            mapController: _mapController.mapController,
            options: const MapOptions(
              initialCenter: LatLng(49.0, 31.0),
              initialZoom: 6.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              StreamBuilder<List<RideModel>>(
                stream: ref.watch(rideRepositoryProvider).streamRides(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    debugPrint('MAP STREAM ERROR: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final rides = snapshot.data!;
                  debugPrint('Rides found for map: ${rides.length}');

                  final polylines = rides
                      .map(
                        (ride) => Polyline(
                          points: [
                            LatLng(
                              ride.fromLocation.latitude,
                              ride.fromLocation.longitude,
                            ),
                            LatLng(
                              ride.toLocation.latitude,
                              ride.toLocation.longitude,
                            ),
                          ],
                          color: AppColors.secondary.withValues(alpha: 0.8),
                          strokeWidth: 4.0,
                        ),
                      )
                      .toList();

                  final markers = <Marker>[];
                  for (final ride in rides) {
                    markers.add(
                      _buildPulsingMarker(
                        ride.fromLocation.latitude,
                        ride.fromLocation.longitude,
                        isOrigin: true,
                      ),
                    );
                    markers.add(
                      _buildPulsingMarker(
                        ride.toLocation.latitude,
                        ride.toLocation.longitude,
                        isOrigin: false,
                      ),
                    );
                  }

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      PolylineLayer(polylines: polylines),
                      MarkerLayer(markers: markers),
                    ],
                  );
                },
              ),
            ],
          ),
          // 2. GRADIENT OVERLAY
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // 3. SEARCH CARD
          Positioned(
            left: 16,
            right: 16,
            bottom: 100 + MediaQuery.of(context).viewInsets.bottom,
            child: SingleChildScrollView(
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // FROM with autocomplete
                    AddressAutocompleteField(
                      hintText: t.from_label,
                      icon: Icons.my_location,
                      controller: _fromController,
                      onAddressSelected: (result) {
                        // Future: Use coordinates
                      },
                    ),
                    const Divider(color: Colors.white10),

                    // TO with autocomplete
                    AddressAutocompleteField(
                      hintText: t.to_label,
                      icon: Icons.location_on,
                      controller: _toController,
                      onAddressSelected: (result) {
                        // Future: Use coordinates
                      },
                    ),
                    const Divider(color: Colors.white10),

                    // DATE & TIME
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectDate,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _buildDateRow(
                                _formatDate(_selectedDate),
                                Icons.calendar_today,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.white10,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: _selectTime,
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _buildDateRow(
                                _selectedTime.format(context),
                                Icons.access_time,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white10),

                    // SEATS
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                t.seats_label,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_seats > 1) setState(() => _seats--);
                                },
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                "$_seats",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_seats < 8) setState(() => _seats++);
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // BUTTON
                    ElevatedButton(
                      onPressed: _onSearch,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.search_btn,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 4. RECENT SEARCHES / POPULAR ROUTES
          if (_isHistoryLoaded && _searchEntries.isNotEmpty)
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _searchEntries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildChip(entry),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime tempPickedDate = _selectedDate;
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(builder).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(builder).pop(tempPickedDate),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: tempPickedDate,
                    minimumDate: DateTime.now(),
                    maximumDate: DateTime.now().add(const Duration(days: 365)),
                    onDateTimeChanged: (DateTime newDate) {
                      tempPickedDate = newDate;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((pickedDate) {
      if (pickedDate != null && pickedDate != _selectedDate) {
        setState(() {
          _selectedDate = pickedDate as DateTime;
        });
      }
    });
  }

  Future<void> _selectTime() async {
    DateTime tempPickedTime = DateTime.now();
    tempPickedTime = DateTime(
      tempPickedTime.year,
      tempPickedTime.month,
      tempPickedTime.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext builder) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(builder).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(builder).pop(tempPickedTime),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    initialDateTime: tempPickedTime,
                    onDateTimeChanged: (DateTime newTime) {
                      tempPickedTime = newTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((pickedTime) {
      if (pickedTime != null) {
        final newTimeOfDay = TimeOfDay(
          hour: (pickedTime as DateTime).hour,
          minute: pickedTime.minute,
        );
        if (newTimeOfDay != _selectedTime) {
          setState(() {
            _selectedTime = newTimeOfDay;
          });
        }
      }
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    if (selected == today) {
      return AppLocalizations.of(context)!.today_label;
    }

    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }

  Widget _buildDateRow(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(SearchEntry entry) {
    return GestureDetector(
      onTap: () => _onChipTap(entry),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history, color: AppColors.secondary, size: 16),
            const SizedBox(width: 6),
            Text(
              entry.displayText,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
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
