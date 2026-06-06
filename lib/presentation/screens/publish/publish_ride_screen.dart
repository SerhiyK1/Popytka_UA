import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/address_autocomplete_field.dart';
import 'package:popytka_ua/domain/models/ride_model.dart';
import 'package:popytka_ua/domain/models/location_model.dart';
import 'package:popytka_ua/data/repositories/ride_repository.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/data/services/nominatim_service.dart';
import 'package:popytka_ua/data/services/osrm_routing_service.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class PublishRideScreen extends ConsumerStatefulWidget {
  final RideModel? existingRide;

  const PublishRideScreen({super.key, this.existingRide});

  @override
  ConsumerState<PublishRideScreen> createState() => _PublishRideScreenState();
}

class _PublishRideScreenState extends ConsumerState<PublishRideScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _priceController = TextEditingController(text: "500");
  int _seats = 3;
  bool _isLoading = false;

  NominatimResult? _fromResult;
  NominatimResult? _toResult;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCarId;

  TimeOfDay _roundTo5Minutes(TimeOfDay time) {
    final roundedMinute = (time.minute / 5).round() * 5;
    if (roundedMinute == 60) {
      return TimeOfDay(hour: (time.hour + 1) % 24, minute: 0);
    }
    return TimeOfDay(hour: time.hour, minute: roundedMinute);
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingRide != null) {
      final ride = widget.existingRide!;
      _fromController.text = ride.fromLocation.address;
      _toController.text = ride.toLocation.address;
      _priceController.text = ride.pricePerSeat.toStringAsFixed(0);
      _seats = ride.seatsAvailable;
      _selectedDate = ride.departureTime;
      _selectedTime = _roundTo5Minutes(TimeOfDay.fromDateTime(ride.departureTime));
      _selectedCarId = ride.carId;
    } else {
      // Set default date to tomorrow
      _selectedDate = DateTime.now().add(const Duration(days: 1));
      // Set default time to current time + 1 hour
      final now = DateTime.now().add(const Duration(hours: 1));
      _selectedTime = _roundTo5Minutes(TimeOfDay(hour: now.hour, minute: now.minute));
    }
  }

  Future<void> _selectDate() async {
    DateTime tempPickedDate =
        _selectedDate ?? DateTime.now().add(const Duration(days: 1));
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    await showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
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
                      style: TextStyle(color: onSurface.withValues(alpha: 0.54)),
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
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: onSurface,
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
    if (_selectedTime != null) {
      final roundedTime = _roundTo5Minutes(_selectedTime!);
      tempPickedTime = DateTime(
        tempPickedTime.year,
        tempPickedTime.month,
        tempPickedTime.day,
        roundedTime.hour,
        roundedTime.minute,
      );
    } else {
      final roundedTime = _roundTo5Minutes(TimeOfDay.fromDateTime(tempPickedTime));
      tempPickedTime = DateTime(
        tempPickedTime.year,
        tempPickedTime.month,
        tempPickedTime.day,
        roundedTime.hour,
        roundedTime.minute,
      );
    }
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    await showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
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
                      style: TextStyle(color: onSurface.withValues(alpha: 0.54)),
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
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        color: onSurface,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    use24hFormat: true,
                    minuteInterval: 5,
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

  DateTime? get _departureDateTime {
    if (_selectedDate == null || _selectedTime == null) return null;

    final combined = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    return combined;
  }

  void _publishRide() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }

    // Validate addresses
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter From and To addresses")),
      );
      return;
    }

    // Validate price
    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid price")),
      );
      return;
    }

    // Validate date and time
    final departureDateTime = _departureDateTime;
    if (departureDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.date_time_required),
        ),
      );
      return;
    }

    if (departureDateTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.invalid_date)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isEditing = widget.existingRide != null;
      
      final fromLat = _fromResult?.latitude ?? (isEditing ? widget.existingRide!.fromLocation.latitude : 50.45);
      final fromLng = _fromResult?.longitude ?? (isEditing ? widget.existingRide!.fromLocation.longitude : 30.52);
      final toLat = _toResult?.latitude ?? (isEditing ? widget.existingRide!.toLocation.latitude : 49.83);
      final toLng = _toResult?.longitude ?? (isEditing ? widget.existingRide!.toLocation.longitude : 24.02);

      // Fetch real road route geometry before saving
      final routePoints = await ref.read(osrmRoutingServiceProvider).getRoute(
        LatLng(fromLat, fromLng),
        LatLng(toLat, toLng),
      );

      final ride = RideModel(
        id: isEditing ? widget.existingRide!.id : '',
        riderId: user.uid,
        driverId: user.uid,
        carId: _selectedCarId,
        fromLocation: LocationModel(
          city:
              _fromResult?.city ?? _fromController.text.split(',').first.trim(),
          latitude: fromLat,
          longitude: fromLng,
          address: _fromController.text.trim(),
        ),
        toLocation: LocationModel(
          city: _toResult?.city ?? _toController.text.split(',').first.trim(),
          latitude: toLat,
          longitude: toLng,
          address: _toController.text.trim(),
        ),
        routePoints: routePoints,
        pricePerSeat: price,
        seatsAvailable: _seats,
        departureTime: departureDateTime,
        createdAt: isEditing ? widget.existingRide!.createdAt : DateTime.now(),
        status: isEditing ? widget.existingRide!.status : 'pending',
      );

      if (isEditing) {
        await ref.read(rideRepositoryProvider).updateRide(ride);
      } else {
        await ref.read(rideRepositoryProvider).createRide(ride);
      }

      if (mounted) {
        // Clear the form right away so next time this tab is opened it's fresh
        if (!isEditing) {
          _fromController.clear();
          _toController.clear();
          _priceController.text = "500";
          _seats = 3;
          _selectedDate = DateTime.now().add(const Duration(days: 1));
          final now = DateTime.now().add(const Duration(hours: 1));
          _selectedTime = _roundTo5Minutes(TimeOfDay(hour: now.hour, minute: now.minute));
          _fromResult = null;
          _toResult = null;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? "Поїздку оновлено!" : "Поїздку опубліковано!"),
          ),
        );
        context.go('/');
      }
    } catch (e, stackTrace) {
      debugPrint('Error creating ride: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.existingRide != null ? "Редагувати поїздку" : t.publish_title,
          style: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Car Selection
            Consumer(
              builder: (context, ref, child) {
                final userModel = ref.watch(currentUserProvider).value;
                if (userModel == null ||
                    userModel.role != 'driver' ||
                    userModel.cars.isEmpty) {
                  return const SizedBox.shrink();
                }

                if (_selectedCarId == null && userModel.cars.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _selectedCarId == null) {
                      setState(() {
                        _selectedCarId = userModel.cars.first.id;
                      });
                    }
                  });
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Оберіть автомобіль', onSurface),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: onSurface.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: theme.colorScheme.surface,
                          value: _selectedCarId,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.secondary,
                          ),
                          style: TextStyle(
                            color: onSurface,
                            fontSize: 16,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCarId = newValue;
                            });
                          },
                          items: userModel.cars.map<DropdownMenuItem<String>>((
                            car,
                          ) {
                            return DropdownMenuItem<String>(
                              value: car.id,
                              child: Text(
                                '${car.brand} ${car.model} (${car.plate})',
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),

            // FROM input with autocomplete
            _buildSectionHeader(t.from_label, onSurface),
            AddressAutocompleteField(
              hintText: t.from_label,
              icon: Icons.location_on,
              controller: _fromController,
              filled: true,
              fillColor: onSurface.withValues(alpha: 0.05),
              onAddressSelected: (result) {
                setState(() => _fromResult = result);
              },
            ),

            const SizedBox(height: 16),

            // TO input with autocomplete
            _buildSectionHeader(t.to_label, onSurface),
            AddressAutocompleteField(
              hintText: t.to_label,
              icon: Icons.near_me,
              controller: _toController,
              filled: true,
              fillColor: onSurface.withValues(alpha: 0.05),
              onAddressSelected: (result) {
                setState(() => _toResult = result);
              },
            ),

            const SizedBox(height: 16),

            // Seats
            _buildSectionHeader(t.seats_label, onSurface),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: onSurface.withValues(alpha: 0.12)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.person, color: AppColors.secondary),
                  Text("$_seats", style: TextStyle(fontSize: 18, color: onSurface)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _seats++),
                        icon: Icon(Icons.add, color: onSurface),
                      ),
                      IconButton(
                        onPressed: () => setState(() {
                          if (_seats > 1) _seats--;
                        }),
                        icon: Icon(Icons.remove, color: onSurface),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Date and Time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(t.departure_date, onSurface),
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: onSurface.withValues(alpha: 0.12)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDate != null
                                      ? DateFormat(
                                          'dd.MM.yyyy',
                                        ).format(_selectedDate!)
                                      : t.select_date,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedDate != null
                                        ? onSurface
                                        : onSurface.withValues(alpha: 0.54),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(t.departure_time, onSurface),
                      InkWell(
                        onTap: _selectTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: onSurface.withValues(alpha: 0.12)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedTime != null
                                      ? "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}"
                                      : t.select_time,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedTime != null
                                        ? onSurface
                                        : onSurface.withValues(alpha: 0.54),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Price
            _buildSectionHeader(t.price_label, onSurface),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: onSurface),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.money, color: AppColors.secondary),
                filled: true,
                fillColor: onSurface.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Button
            ElevatedButton(
              onPressed: _isLoading ? null : _publishRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      widget.existingRide != null
                          ? "Зберегти зміни"
                          : t.publish_action,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: TextStyle(color: onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w500)),
    );
  }
}
