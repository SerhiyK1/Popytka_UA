import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:popytka_ua/data/providers/user_provider.dart';
import 'package:popytka_ua/data/repositories/auth_repository.dart';
import 'package:popytka_ua/data/repositories/rating_repository.dart';
import 'package:popytka_ua/domain/models/rating_model.dart';
import 'package:intl/intl.dart';
import 'package:popytka_ua/data/providers/statistics_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isUpdatingRole = false;

  Future<void> _toggleUserRole(String newRole) async {
    setState(() => _isUpdatingRole = true);

    try {
      await ref.read(userNotifierProvider.notifier).updateUserRole(newRole);

      if (mounted) {
        final message = newRole == 'driver'
            ? AppLocalizations.of(context)!.switch_to_driver
            : AppLocalizations.of(context)!.switch_to_passenger;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
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
        setState(() => _isUpdatingRole = false);
      }
    }
  }

  Future<void> _signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    if (t == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.profile_title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.close, color: onSurface),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: Icon(Icons.settings_outlined, color: onSurface),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND DECORATIONS
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.1),
              ),
            ),
          ),

          // 2. MAIN CONTENT
          currentUserAsync.when(
            data: (user) {
              if (user == null) {
                return Center(
                  child: Text('Please login', style: TextStyle(color: onSurface)),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 70,
                  16,
                  30,
                ),
                child: Column(
                  children: [
                    // USER HEADER CARD
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 24,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: AppColors.primary,
                                    backgroundImage: user.photoUrl != null
                                        ? NetworkImage(user.photoUrl!)
                                        : null,
                                    child: user.photoUrl == null
                                        ? const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.black,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${user.averageRating.toStringAsFixed(1)} (${user.numberOfRatings} ${t.ratings_and_reviews})",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.push('/edit_profile', extra: user),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                t.edit_profile,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // WALLET CARD
                    _buildBalanceCard(t, user, onSurface),

                    const SizedBox(height: 24),

                    // ROLE TOGGLE
                    _buildRoleToggle(t, user, onSurface),

                    const SizedBox(height: 24),
                    _buildStatisticsSection(t, user, onSurface),

                    if (user.role == 'driver') ...[
                      const SizedBox(height: 24),
                      _buildVehicleSection(t, user, onSurface),
                    ],

                    const SizedBox(height: 24),

                    _buildRatingsSection(t, user.id, onSurface),

                    const SizedBox(height: 40),

                    // ACTIONS
                    _buildActionButton(
                      icon: Icons.history,
                      label: t.my_rides,
                      onTap: () => context.push('/my_rides'),
                      onSurface: onSurface,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.settings,
                      label: t.settings_title,
                      onTap: () => context.push('/settings'),
                      onSurface: onSurface,
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.logout,
                      label: 'Вийти',
                      isDanger: true,
                      onTap: _signOut,
                      onSurface: onSurface,
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e', style: TextStyle(color: onSurface))),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(AppLocalizations t, dynamic user, Color onSurface) {
    final statsAsync = ref.watch(statisticsProvider(user.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            t.statistics_title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
        ),
        statsAsync.when(
          data: (stats) {
            final isDriver = user.role == 'driver';
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: isDriver
                  ? _buildDriverStats(t, stats, onSurface)
                  : _buildPassengerStats(t, stats, onSurface),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(child: Text("Error loading stats", style: TextStyle(color: onSurface))),
        ),
      ],
    );
  }

  Widget _buildDriverStats(AppLocalizations t, dynamic stats, Color onSurface) {
    return GlassContainer(
      key: const ValueKey('driver_stats'),
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInteractiveStatCard(
                  icon: Icons.drive_eta,
                  label: t.stat_total_rides,
                  value: stats.totalRidesPublished.toString(),
                  color: AppColors.primary,
                  onSurface: onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInteractiveStatCard(
                  icon: Icons.people_alt,
                  label: t.stat_passengers,
                  value: stats.passengersCarried.toString(),
                  color: AppColors.secondary,
                  onSurface: onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInteractiveStatCard(
            icon: Icons.account_balance_wallet,
            label: t.stat_total_earned,
            value: "${stats.totalEarned.toStringAsFixed(2)} ₴",
            color: Colors.greenAccent,
            isWide: true,
            onSurface: onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerStats(AppLocalizations t, dynamic stats, Color onSurface) {
    return GlassContainer(
      key: const ValueKey('passenger_stats'),
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInteractiveStatCard(
                  icon: Icons.directions_car_filled,
                  label: t.stat_total_rides,
                  value: stats.totalRidesAsPassenger.toString(),
                  color: AppColors.primary,
                  onSurface: onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInteractiveStatCard(
                  icon: Icons.shopping_bag,
                  label: t.stat_total_spent,
                  value: "${stats.totalSpent.toStringAsFixed(2)} ₴",
                  color: Colors.redAccent,
                  onSurface: onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color onSurface,
    bool isWide = false,
  }) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: GestureDetector(
            onTapDown: (_) => setState(() => isHovered = true),
            onTapUp: (_) => setState(() => isHovered = false),
            onTapCancel: () => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHovered
                    ? color.withValues(alpha: 0.2)
                    : onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHovered
                      ? color.withValues(alpha: 0.5)
                      : Colors.transparent,
                  width: 1.5,
                ),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: isWide
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: color, size: 28),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              value,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: onSurface,
                              ),
                            ),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 12,
                                color: onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: color, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRatingsSection(AppLocalizations t, String userId, Color onSurface) {
    final ratingsStream = ref
        .watch(ratingRepositoryProvider)
        .getUserRatings(userId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            t.ratings_and_reviews,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
        ),
        GlassContainer(
          padding: const EdgeInsets.all(16),
          borderRadius: 20,
          child: StreamBuilder<List<RatingModel>>(
            stream: ratingsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: onSurface)));
              }
              final ratings = snapshot.data ?? [];
              if (ratings.isEmpty) {
                return Center(child: Text(t.no_ratings_yet, style: TextStyle(color: onSurface.withValues(alpha: 0.5))));
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ratings.length,
                separatorBuilder: (context, index) =>
                    Divider(color: onSurface.withValues(alpha: 0.12)),
                itemBuilder: (context, index) {
                  return _buildRatingItem(ratings[index], onSurface);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRatingItem(RatingModel rating, Color onSurface) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  i < rating.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat.yMMMd().format(rating.createdAt),
                style: TextStyle(color: onSurface.withValues(alpha: 0.54), fontSize: 12),
              ),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              rating.comment!,
              style: TextStyle(color: onSurface.withValues(alpha: 0.7)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBalanceCard(AppLocalizations t, dynamic user, Color onSurface) {
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.wallet_balance,
                  style: TextStyle(fontSize: 12, color: onSurface.withValues(alpha: 0.54)),
                ),
                Text(
                  "${user.balance.toStringAsFixed(2)} ₴",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/wallet'),
            child: Text(
              t.view_wallet,
              style: const TextStyle(color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleToggle(AppLocalizations t, dynamic user, Color onSurface) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildRoleTab(
            t.passenger_label,
            user.role == 'rider',
            () => _toggleUserRole('rider'),
            onSurface,
          ),
          _buildRoleTab(
            t.driver_label,
            user.role == 'driver',
            () => _toggleUserRole('driver'),
            onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTab(String label, bool isActive, VoidCallback onTap, Color onSurface) {
    return Expanded(
      child: GestureDetector(
        onTap: _isUpdatingRole ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.black : onSurface.withValues(alpha: 0.54),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSection(AppLocalizations t, dynamic user, Color onSurface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            t.car_details,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
        ),
        if (user.cars.isEmpty)
          Center(
            child: Text(
              t.car_info_required,
              style: TextStyle(color: onSurface.withValues(alpha: 0.38), fontSize: 12),
            ),
          )
        else
          ...user.cars.map<Widget>((car) {
            return GlassContainer(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              borderRadius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_car,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${car.brand} ${car.model}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildDetailBox(
                        t.car_year,
                        car.year,
                        onSurface,
                        width: (MediaQuery.of(context).size.width - 96) / 3,
                      ),
                      _buildDetailBox(
                        t.car_plate,
                        car.plate,
                        onSurface,
                        width: (MediaQuery.of(context).size.width - 72) / 2,
                      ),
                      _buildDetailBox(
                        t.car_color,
                        car.color,
                        onSurface,
                        width: (MediaQuery.of(context).size.width - 96) / 3,
                      ),
                    ],
                  ),
                  if (car.photos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: car.photos.length,
                        itemBuilder: (context, index) => Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(car.photos[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildDetailBox(
    String label,
    String value,
    Color onSurface, {
    bool isGold = false,
    double? width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isGold
            ? AppColors.primary.withValues(alpha: 0.1)
            : onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGold
              ? AppColors.primary.withValues(alpha: 0.3)
              : onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: onSurface.withValues(alpha: 0.54)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isGold ? AppColors.primary : onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color onSurface,
    bool isDanger = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        borderRadius: 16,
        child: Row(
          children: [
            Icon(
              icon,
              color: isDanger ? Colors.redAccent : AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isDanger ? Colors.redAccent : onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: onSurface.withValues(alpha: 0.24)),
          ],
        ),
      ),
    );
  }
}
