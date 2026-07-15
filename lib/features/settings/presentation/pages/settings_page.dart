// Settings Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final currency = ref.watch(currencyProvider);
    final pushEnabled = ref.watch(pushNotificationsProvider);
    final emailEnabled = ref.watch(emailNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(customSpacing.lg),
        children: [
          // Appearance
          const _SectionHeader(title: 'Appearance'),
          _SettingsTile(
            leading: Icons.palette_outlined,
            title: 'Theme',
            subtitle: _getThemeLabel(themeMode),
            trailing: _ThemeSelector(
              value: themeMode,
              onChanged: (mode) => ref.read(themeModeProvider.notifier).setThemeMode(mode),
            ),
          ),
          _SettingsTile(
            leading: Icons.language_outlined,
            title: 'Language',
            subtitle: _getLanguageLabel(language),
            trailing: _LanguageSelector(
              value: language,
              onChanged: (lang) => ref.read(languageProvider.notifier).setLanguage(lang.languageCode),
            ),
          ),
          _SettingsTile(
            leading: Icons.attach_money_outlined,
            title: 'Currency',
            subtitle: currency,
            trailing: _CurrencySelector(
              value: currency,
              onChanged: (curr) => ref.read(currencyProvider.notifier).setCurrency(curr),
            ),
          ),

          SizedBox(height: customSpacing.xl),
          // Notifications
          const _SectionHeader(title: 'Notifications'),
          _SwitchTile(
            leading: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive order updates & promotions',
            value: pushEnabled,
            onChanged: (val) => ref.read(pushNotificationsProvider.notifier).setPushEnabled(val),
          ),
          _SwitchTile(
            leading: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: 'Order confirmations & newsletters',
            value: emailEnabled,
            onChanged: (val) => ref.read(emailNotificationsProvider.notifier).setEmailEnabled(val),
          ),

          SizedBox(height: customSpacing.xl),
          // Privacy & Data
          const _SectionHeader(title: 'Privacy & Data'),
          _SettingsTile(
            leading: Icons.analytics_outlined,
            title: 'Analytics',
            subtitle: 'Help improve the app with usage data',
            trailing: Switch(
              value: ref.watch(analyticsConsentProvider),
              onChanged: (val) => ref.read(analyticsConsentProvider.notifier).state = val,
            ),
          ),
          _ActionTile(
            leading: Icons.delete_outline,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            onTap: () => _clearCache(context),
            isDestructive: false,
          ),
          _ActionTile(
            leading: Icons.download_outlined,
            title: 'Download My Data',
            subtitle: 'Request a copy of your personal data',
            onTap: () {},
          ),
          _ActionTile(
            leading: Icons.delete_forever_outlined,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account and data',
            onTap: () => _showDeleteAccountDialog(context),
            isDestructive: true,
          ),

          SizedBox(height: customSpacing.xl),
          // About
          const _SectionHeader(title: 'About'),
          const _SettingsTile(
            leading: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0 (Build 1)',
          ),
          _ActionTile(
            leading: Icons.star_outline,
            title: 'Rate App',
            subtitle: 'Share your feedback on the store',
            onTap: () => _rateApp(),
          ),
          _ActionTile(
            leading: Icons.share_outlined,
            title: 'Share App',
            subtitle: 'Invite friends to shop with us',
            onTap: () => _shareApp(),
          ),
          _ActionTile(
            leading: Icons.policy_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: () => _launchUrl('https://example.com/terms'),
          ),
          _ActionTile(
            leading: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we protect your data',
            onTap: () => _launchUrl('https://example.com/privacy'),
          ),
          _ActionTile(
            leading: Icons.contact_support_outlined,
            title: 'Contact Support',
            subtitle: 'Get help with your account',
            onTap: () => _launchUrl('mailto:support@example.com'),
          ),

          SizedBox(height: customSpacing.xxxl),
        ],
      ),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'Light';
      case ThemeMode.dark: return 'Dark';
      case ThemeMode.system: return 'System Default';
    }
  }

  String _getLanguageLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'en': return 'English';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      case 'de': return 'Deutsch';
      case 'zh': return '中文';
      case 'ja': return '日本語';
      case 'ko': return '한국어';
      default: return locale.languageCode;
    }
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear temporary files and may log you out. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () { Navigator.pop(context); /* TODO: clear cache */ }, child: const Text('Clear')),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action is irreversible. All your data will be permanently deleted. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () { Navigator.pop(context); /* TODO: delete account */ },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    // TODO: Launch store rating
  }

  void _shareApp() {
    // TODO: Share app
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;

    return Padding(
      padding: EdgeInsets.fromLTRB(customSpacing.lg, customSpacing.lg, customSpacing.lg, customSpacing.sm),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(customRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(customRadius.md),
            ),
            child: Icon(leading, color: theme.colorScheme.onPrimaryContainer, size: 22),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(customRadius.lg),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(customRadius.md),
            ),
            child: Icon(leading, color: theme.colorScheme.onPrimaryContainer, size: 22),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final iconColor = isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant;
    final textColor = isDestructive ? colorScheme.error : colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(customRadius.lg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(customRadius.lg),
        child: Padding(
          padding: EdgeInsets.all(customSpacing.md),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(customRadius.md),
                ),
                child: Icon(leading, color: iconColor, size: 22),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.w500)),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  const _ThemeSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ThemeMode>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => [
        const PopupMenuItem(value: ThemeMode.light, child: Row(children: [Icon(Icons.light_mode), SizedBox(width: 8), Text('Light')])),
        const PopupMenuItem(value: ThemeMode.dark, child: Row(children: [Icon(Icons.dark_mode), SizedBox(width: 8), Text('Dark')])),
        const PopupMenuItem(value: ThemeMode.system, child: Row(children: [Icon(Icons.settings_system_daydream), SizedBox(width: 8), Text('System')])),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_getLabel(value), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  String _getLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'Light';
      case ThemeMode.dark: return 'Dark';
      default: return 'System';
    }
  }
}

class _LanguageSelector extends StatelessWidget {
  final Locale value;
  final ValueChanged<Locale> onChanged;

  const _LanguageSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const languages = [
      Locale('en', 'US'),
      Locale('es', 'ES'),
      Locale('fr', 'FR'),
      Locale('de', 'DE'),
      Locale('zh', 'CN'),
      Locale('ja', 'JP'),
      Locale('ko', 'KR'),
    ];

    return PopupMenuButton<Locale>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => languages.map((lang) {
        final label = _getLabel(lang);
        return PopupMenuItem(value: lang, child: Text(label));
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_getLabel(value), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  String _getLabel(Locale locale) {
    switch (locale.languageCode) {
      case 'en': return 'English';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      case 'de': return 'Deutsch';
      case 'zh': return '中文';
      case 'ja': return '日本語';
      case 'ko': return '한국어';
      default: return locale.languageCode;
    }
  }
}

class _CurrencySelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CurrencySelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CNY', 'CAD', 'AUD'];

    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      itemBuilder: (context) => currencies.map((curr) => PopupMenuItem(value: curr, child: Text(curr))).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}