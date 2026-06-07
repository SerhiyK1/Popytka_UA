import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/domain/models/user_model.dart';
import 'package:popytka_ua/domain/models/car_model.dart';

const Map<String, List<String>> _carBrandsAndModels = {
  'Volkswagen': ['Golf', 'Passat', 'Jetta', 'Tiguan', 'Polo', 'Touran', 'Caddy', 'Touareg'],
  'Renault': ['Megane', 'Scenic', 'Logan', 'Duster', 'Kangoo', 'Clio', 'Kadjar', 'Sandero'],
  'Skoda': ['Octavia', 'Fabia', 'Superb', 'Kodiaq', 'Rapid', 'Karoq', 'Scala'],
  'Opel': ['Astra', 'Insignia', 'Vectra', 'Corsa', 'Zafira', 'Vivaro', 'Meriva'],
  'Ford': ['Focus', 'Fiesta', 'Mondeo', 'Fusion', 'Kuga', 'Transit', 'C-Max', 'Escape'],
  'Toyota': ['Corolla', 'Camry', 'RAV4', 'Land Cruiser', 'Avensis', 'Prius', 'Yaris', 'Auris'],
  'BMW': ['3 Series', '5 Series', 'X5', 'X3', '7 Series', '1 Series'],
  'Mercedes-Benz': ['C-Class', 'E-Class', 'S-Class', 'Sprinter', 'Vito', 'GLC', 'GLE', 'A-Class'],
  'Audi': ['A4', 'A6', 'Q5', 'A3', 'Q7', 'A8', '100', 'A5'],
  'Hyundai': ['Tucson', 'Elantra', 'Sonata', 'Santa Fe', 'Accent', 'i30', 'Getz', 'Kona'],
  'Kia': ['Sportage', 'Ceed', 'Rio', 'Optima', 'Sorento', 'Cerato', 'Soul'],
  'Nissan': ['Qashqai', 'Leaf', 'Rogue', 'X-Trail', 'Juke', 'Almera', 'Tiida', 'Micra'],
  'Mazda': ['6', '3', 'CX-5', '323', '626', 'CX-7', 'CX-9'],
  'Honda': ['Civic', 'Accord', 'CR-V', 'HR-V', 'Jazz', 'Fit'],
  'Mitsubishi': ['Lancer', 'Outlander', 'ASX', 'Pajero', 'Galant', 'Colt'],
  'Chevrolet': ['Lacetti', 'Aveo', 'Cruze', 'Captiva', 'Niva', 'Epica', 'Bolt'],
  'Daewoo': ['Lanos', 'Sens', 'Matiz', 'Nexia', 'Nubira'],
  'Lada': ['Vesta', 'Granta', 'Niva', 'Priora', 'Kalina', '2109', '2107', '2110'],
  'Peugeot': ['308', '206', '3008', 'Partner', '5008', '207', '407'],
  'Citroen': ['C4', 'Berlingo', 'C5', 'C3', 'Jumpy', 'C4 Picasso'],
  'Volvo': ['XC60', 'XC90', 'V50', 'S60', 'S80', 'V60'],
  'Lexus': ['RX', 'ES', 'NX', 'LX', 'GS', 'IS'],
  'Subaru': ['Forester', 'Outback', 'Legacy', 'Impreza', 'Tribeca'],
  'Suzuki': ['Grand Vitara', 'Swift', 'Vitara', 'Sx4', 'Jimny'],
};

const List<String> _carColors = [
  'Чорний',
  'Білий',
  'Сірий',
  'Сріблястий',
  'Синій',
  'Червоний',
  'Зелений',
  'Коричневий',
  'Бежевий',
  'Жовтий',
  'Оранжевий',
  'Бордовий',
  'Золотистий',
];

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

  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _modelFocusNode = FocusNode();
  final FocusNode _colorFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _cars = List.from(widget.user.cars);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandFocusNode.dispose();
    _modelFocusNode.dispose();
    _colorFocusNode.dispose();
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
    final List<String> carPhotos = List.from(existingCar?.photos ?? []);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final halfWidth = (MediaQuery.of(ctx).size.width - 40) / 2;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildAutocompleteField(
                          label: 'Марка',
                          controller: brandCtrl,
                          focusNode: _brandFocusNode,
                          dropdownWidth: halfWidth,
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return _carBrandsAndModels.keys;
                            }
                            return _carBrandsAndModels.keys.where((String brand) {
                              return brand.toLowerCase().contains(textEditingValue.text.toLowerCase());
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildAutocompleteField(
                          label: 'Модель',
                          controller: modelCtrl,
                          focusNode: _modelFocusNode,
                          dropdownWidth: halfWidth,
                          optionsBuilder: (textEditingValue) {
                            final selectedBrand = brandCtrl.text.trim();
                            final models = _carBrandsAndModels[selectedBrand] ?? [];
                            if (textEditingValue.text.isEmpty) {
                              return models;
                            }
                            return models.where((String model) {
                              return model.toLowerCase().contains(textEditingValue.text.toLowerCase());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildTextField('Рік', yearCtrl)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildAutocompleteField(
                          label: 'Колір',
                          controller: colorCtrl,
                          focusNode: _colorFocusNode,
                          dropdownWidth: halfWidth,
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return _carColors;
                            }
                            return _carColors.where((String color) {
                              return color.toLowerCase().contains(textEditingValue.text.toLowerCase());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTextField('Держ. Номер', plateCtrl),
                  const SizedBox(height: 16),
                  
                  // Photos section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Фото автомобіля (необов\'язково)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 1024,
                            maxHeight: 1024,
                            imageQuality: 85,
                          );
                          if (image != null) {
                            setSheetState(() {
                              carPhotos.add(image.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.add_a_photo, size: 18, color: AppColors.primary),
                        label: const Text(
                          'Додати',
                          style: TextStyle(color: AppColors.primary, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  if (carPhotos.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: carPhotos.length,
                        itemBuilder: (context, photoIndex) {
                          final path = carPhotos[photoIndex];
                          final isUrl = path.startsWith('http');
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 80,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: kIsWeb || isUrl
                                      ? Image.network(
                                          path,
                                          width: 100,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          io.File(path),
                                          width: 100,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      setSheetState(() {
                                        carPhotos.removeAt(photoIndex);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (brandCtrl.text.isEmpty || modelCtrl.text.isEmpty) {
                        return; // simple validation
                      }
                      final newCar = CarModel(
                        id: existingCar?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        brand: brandCtrl.text,
                        model: modelCtrl.text,
                        year: yearCtrl.text,
                        plate: plateCtrl.text,
                        color: colorCtrl.text,
                        photos: carPhotos,
                      );

                      setState(() {
                        if (index != null) {
                          _cars[index] = newCar;
                        } else {
                          _cars.add(newCar);
                        }
                      });
                      ref.read(userNotifierProvider.notifier).updateUserProfile(cars: _cars);
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final isDriver = widget.user.role == 'driver';
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: onSurface),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: onSurface.withValues(alpha: 0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t.phone_number,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: false,
                    controller: TextEditingController(text: widget.user.phone),
                    style: TextStyle(color: onSurface.withValues(alpha: 0.5)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: onSurface.withValues(alpha: 0.03),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'У вас поки немає авто',
                      style: TextStyle(color: onSurface.withValues(alpha: 0.5)),
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
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: onSurface.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: car.photos.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: kIsWeb || car.photos.first.startsWith('http')
                                    ? Image.network(
                                        car.photos.first,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        io.File(car.photos.first),
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : const Icon(
                                Icons.directions_car,
                                color: AppColors.secondary,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${car.brand} ${car.model}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: onSurface,
                              ),
                            ),
                            Text(
                              '${car.plate} • ${car.color} • ${car.year}',
                              style: TextStyle(
                                color: onSurface.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showAddCarBottomSheet(car, index),
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _cars.removeAt(index);
                          });
                          ref.read(userNotifierProvider.notifier).updateUserProfile(cars: _cars);
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

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    FocusNode? focusNode,
  }) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: onSurface.withValues(alpha: 0.7)),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(color: onSurface, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: onSurface.withValues(alpha: 0.05),
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

  Widget _buildAutocompleteField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required Iterable<String> Function(TextEditingValue) optionsBuilder,
    double dropdownWidth = 160,
  }) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: optionsBuilder,
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (context, textEditingController, fieldFocusNode, onFieldSubmitted) {
        return _buildTextField(label, textEditingController, focusNode: fieldFocusNode);
      },
      optionsViewBuilder: (context, onSelected, options) {
        final theme = Theme.of(context);
        final onSurface = theme.colorScheme.onSurface;
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: dropdownWidth,
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.brightness == Brightness.dark
                    ? const Color(0xFF2A2F35)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: onSurface.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return InkWell(
                      onTap: () => onSelected(option),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: onSurface.withValues(alpha: 0.05),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(color: onSurface, fontSize: 13),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
