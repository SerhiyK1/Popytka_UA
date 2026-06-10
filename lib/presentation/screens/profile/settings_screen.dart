import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:popytka_ua/l10n/app_localizations.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';
import 'package:popytka_ua/presentation/widgets/glass_container.dart';
import 'package:popytka_ua/data/providers/locale_provider.dart';
import 'package:popytka_ua/data/providers/theme_provider.dart';
import 'package:popytka_ua/data/providers/app_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context);
    if (t == null) return const SizedBox.shrink();

    final currentLocale = ref.watch(localeNotifierProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    final isDarkMode = currentTheme == ThemeMode.dark;

    final settings = ref.watch(appSettingsProvider);
    String languageName = 'Українська';
    if (currentLocale.languageCode == 'en') languageName = 'English';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          t.settings_title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.chevron_left,
            size: 30,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Popytka_UA',
                style: TextStyle(
                  color: AppColors.secondary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // GENERAL
            _buildSection(
              title: t.settings_general,
              context: context,
              children: [
                _buildSettingRow(
                  label: t.settings_language,
                  context: context,
                  onTap: () => _showLanguageDialog(
                    context,
                    currentLocale.languageCode,
                    ref,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        languageName,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: isDarkMode ? Colors.white54 : Colors.black45,
                      ),
                    ],
                  ),
                ),
                _buildSettingRow(
                  label: t.settings_theme,
                  context: context,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: isDarkMode,
                        onChanged: (v) {
                          ref.read(themeNotifierProvider.notifier).toggleTheme(v);
                        },
                        activeThumbColor: AppColors.secondary,
                      ),
                      Text(
                        t.settings_dark_mode,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // NOTIFICATIONS
            _buildSection(
              title: t.settings_notifications,
              context: context,
              children: [
                _buildSettingRow(
                  label: t.settings_ride_updates,
                  context: context,
                  trailing: Switch(
                    value: settings.notifyRideUpdates,
                    onChanged: (v) => ref
                        .read(appSettingsProvider.notifier)
                        .toggleRideUpdates(v),
                    activeThumbColor: AppColors.secondary,
                  ),
                ),
                _buildSettingRow(
                  label: t.settings_new_messages,
                  context: context,
                  trailing: Switch(
                    value: settings.notifyNewMessages,
                    onChanged: (v) => ref
                        .read(appSettingsProvider.notifier)
                        .toggleNewMessages(v),
                    activeThumbColor: AppColors.secondary,
                  ),
                ),
                _buildSettingRow(
                  label: t.settings_promotions,
                  context: context,
                  trailing: Switch(
                    value: settings.notifyPromotions,
                    onChanged: (v) => ref
                        .read(appSettingsProvider.notifier)
                        .togglePromotions(v),
                    activeThumbColor: AppColors.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // PRIVACY
            _buildSection(
              title: t.settings_privacy,
              context: context,
              children: [
                _buildSettingRow(
                  label: t.settings_data_sharing,
                  context: context,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Вибірково',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: isDarkMode ? Colors.white54 : Colors.black45,
                      ),
                    ],
                  ),
                ),
                _buildSettingRow(
                  label: t.settings_profile_visibility,
                  context: context,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        settings.profilePublic
                            ? t.settings_visibility_public
                            : 'Приватний',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      Switch(
                        value: settings.profilePublic,
                        onChanged: (v) => ref
                            .read(appSettingsProvider.notifier)
                            .toggleProfileVisibility(v),
                        activeThumbColor: AppColors.secondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // SECURITY
            _buildSection(
              title: t.settings_security,
              context: context,
              children: [
                _buildSettingRow(
                  label: t.settings_change_password,
                  context: context,
                  isLink: true,
                  onTap: () => context.push(
                    '/placeholder?title=${Uri.encodeComponent(t.settings_change_password)}',
                  ),
                ),
                _buildSettingRow(
                  label: t.settings_two_factor,
                  context: context,
                  trailing: Switch(
                    value: settings.twoFactorEnabled,
                    onChanged: (v) => ref
                        .read(appSettingsProvider.notifier)
                        .toggleTwoFactor(v),
                    activeThumbColor: AppColors.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // SUPPORT
            _buildSection(
              title: t.settings_support,
              context: context,
              children: [
                _buildSettingRow(
                  label: t.settings_help_center,
                  context: context,
                  icon: Icons.help_outline,
                  isLink: true,
                  onTap: () => context.push(
                    '/placeholder?title=${Uri.encodeComponent(t.settings_help_center)}',
                  ),
                ),
                _buildSettingRow(
                  label: t.settings_contact_us,
                  context: context,
                  icon: Icons.mail_outline,
                  isLink: true,
                  onTap: () => context.push(
                    '/placeholder?title=${Uri.encodeComponent(t.settings_contact_us)}',
                  ),
                ),
                _buildSettingRow(
                  label: t.settings_about,
                  context: context,
                  icon: Icons.info_outline,
                  isLink: true,
                  onTap: () => context.push(
                    '/placeholder?title=${Uri.encodeComponent(t.settings_about)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    String currentCode,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            AppLocalizations.of(context)?.settings_language ?? 'Language',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                'Українська',
                'uk',
                currentCode,
                ref,
              ),
              _buildLanguageOption(context, 'English', 'en', currentCode, ref),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String name,
    String code,
    String currentCode,
    WidgetRef ref,
  ) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      trailing: currentCode == code
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        ref.read(localeNotifierProvider.notifier).setLocale(code);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSection({
    required String title,
    required BuildContext context,
    required List<Widget> children,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
        GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          borderRadius: 20,
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required String label,
    required BuildContext context,
    Widget? trailing,
    IconData? icon,
    bool isLink = false,
    VoidCallback? onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (isLink && trailing == null)
              Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.white54 : Colors.black45,
              ),
          ],
        ),
      ),
    );
  }
}
