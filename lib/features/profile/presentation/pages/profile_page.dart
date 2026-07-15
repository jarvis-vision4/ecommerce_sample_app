// Profile Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_theme.dart';


class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    // Mock user data
    final user = {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'phone': '+1 (555) 123-4567',
      'avatar': null,
      'memberSince': DateTime(2023, 6, 15),
      'ordersCount': 12,
      'wishlistCount': 8,
      'reviewsCount': 5,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Profile Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(customSpacing.xl),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: Column(
                children: [
                  // Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: colorScheme.primaryContainer,
                        backgroundImage: user['avatar'] != null ? NetworkImage(user['avatar'] as String) : null,
                        child: user['avatar'] == null
                            ? Text(
                                (user['name'] as String).split(' ').map((n) => n[0]).join(),
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(customSpacing.xs),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: colorScheme.surface, width: 3),
                          ),
                          child: Icon(Icons.camera_alt_outlined, size: 16, color: colorScheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: customSpacing.md),
                  // Name
                  Text(
                    user['name'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: customSpacing.xs),
                  // Email
                  Text(
                    user['email'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: customSpacing.xs),
                  // Member since
                  Text(
                    'Member since ${_formatDate(user['memberSince'] as DateTime)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: customSpacing.lg),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(label: 'Orders', value: user['ordersCount'].toString()),
                      _StatItem(label: 'Wishlist', value: user['wishlistCount'].toString()),
                      _StatItem(label: 'Reviews', value: user['reviewsCount'].toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Menu Sections
          SliverList(
            delegate: SliverChildListDelegate([
              const _SectionHeader(title: 'Account'),
              _MenuItem(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update personal information',
                onTap: () => context.push('/profile/edit'),
              ),
              _MenuItem(
                icon: Icons.location_on_outlined,
                title: 'Addresses',
                subtitle: 'Manage shipping & billing addresses',
                onTap: () => context.push('/profile/addresses'),
              ),
              _MenuItem(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Manage cards & payment options',
                onTap: () => {},
              ),
              _MenuItem(
                icon: Icons.favorite_outline,
                title: 'Wishlist',
                subtitle: 'View saved items',
                onTap: () => context.push('/profile/wishlist'),
              ),

              SizedBox(height: customSpacing.lg),
              const _SectionHeader(title: 'Activity'),
              _MenuItem(
                icon: Icons.receipt_long_outlined,
                title: 'Order History',
                subtitle: 'View past orders & track shipments',
                onTap: () => context.push('/orders'),
              ),
              _MenuItem(
                icon: Icons.rate_review_outlined,
                title: 'My Reviews',
                subtitle: 'Manage product reviews',
                onTap: () {},
              ),

              SizedBox(height: customSpacing.lg),
              const _SectionHeader(title: 'Support'),
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                subtitle: 'FAQs, guides & contact support',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.policy_outlined,
                title: 'Terms & Privacy',
                subtitle: 'Read our policies',
                onTap: () {},
              ),

              SizedBox(height: customSpacing.lg),
              // Danger zone
              _MenuItem(
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Log out of your account',
                onTap: () => _showSignOutDialog(),
                isDestructive: true,
              ),
              SizedBox(height: customSpacing.xxxl),
            ]),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
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

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: customSpacing.lg, vertical: customSpacing.md),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5))),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(customSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(customRadius.md),
              ),
              child: Icon(icon, color: iconColor, size: 22),
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
    );
  }
}