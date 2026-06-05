import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/domain/models/user_model.dart';
import 'package:popytka_ua/domain/models/car_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  bool _isLoading = false;
  List<CarModel> _cars = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _cars = List.from(widget.user.cars);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() => _isLoading = true);

      try {
        const newPhotoUrl = 'https://via.placeholder.com/150x150?text=Profile';

        await ref
            .read(userNotifierProvider.notifier)
            .updateUserProfile(photoUrl: newPhotoUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.profile_updated),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.error_updating_profile,
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.name_label} is required',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(userNotifierProvider.notifier)
          .updateUserProfile(name: _nameController.text.trim(), cars: _cars);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profile_updated),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error_updating_profile),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showAddCarBottomSheet([CarModel? existingCar, int? index]) {
    final brandCtrl = TextEditingController(text: existingCar?.brand ?? '');
    final modelCtrl = TextEditingController(text: existingCar?.model ?? '');
    final yearCtrl = TextEditingController(text: existingCar?.year ?? '');
    final plateCtrl = TextEditingController(text: existingCar?.plate ?? '');
    final colorCtrl = TextEditingController(text: existingCar?.color ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                existingCar == null ? 'Додати авто' : 'Редагувати авто',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Марка', brandCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Модель', modelCtrl)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildTextField('Рік', yearCtrl)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTextField('Колір', colorCtrl)),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField('Держ. Номер', plateCtrl),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (brandCtrl.text.isEmpty || modelCtrl.text.isEmpty) {
                    return; // simple validation
                  }
                  final newCar = CarModel(
                    id:
                        existingCar?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    brand: brandCtrl.text,
                    model: modelCtrl.text,
                    year: yearCtrl.text,
                    plate: plateCtrl.text,
                    color: colorCtrl.text,
                    photos: existingCar?.photos ?? [],
                  );

                  setState(() {
                    if (index != null) {
                      _cars[index] = newCar;
                    } else {
                      _cars.add(newCar);
                    }
                  });
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Зберегти'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDriver = widget.user.role == 'driver';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(t.edit_profile_title),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    t.save_changes,
                    style: const TextStyle(color: AppColors.primary),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    backgroundImage: widget.user.photoUrl != null
                        ? NetworkImage(widget.user.photoUrl!)
                        : null,
                    child: widget.user.photoUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.black,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.black),
                        onPressed: _pickProfileImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.name_label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.phone_number,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: widget.user.phone),
                    style: const TextStyle(color: Colors.white54),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isDriver) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Мої автомобілі',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showAddCarBottomSheet(),
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_cars.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'У вас поки немає авто',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
              ..._cars.asMap().entries.map((entry) {
                final index = entry.key;
                final car = entry.value;
                return GlassContainer(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${car.brand} ${car.model}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${car.plate} • ${car.color} • ${car.year}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showAddCarBottomSheet(car, index),
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white54,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _cars.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white10,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }
}
