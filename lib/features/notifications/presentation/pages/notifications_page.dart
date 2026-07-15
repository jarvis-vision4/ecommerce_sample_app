// Notifications Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';


class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    // Mock notifications
    final notifications = [
      {
        'id': '1',
        'type': 'order',
        'title': 'Order Confirmed',
        'message': 'Your order ORD-2024-001 has been confirmed',
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
        'read': false,
        'action': () {},
      },
      {
        'id': '2',
        'type': 'shipping',
        'title': 'Order Shipped',
        'message': 'Your order ORD-2024-002 is on the way!',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'read': false,
        'action': () {},
      },
      {
        'id': '3',
        'type': 'promotion',
        'title': 'Flash Sale - 50% Off!',
        'message': 'Limited time offer on electronics',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'read': true,
        'action': () => context.push('/products?sale=true'),
      },
      {
        'id': '4',
        'type': 'review',
        'title': 'Review Requested',
        'message': 'How was your Wireless Headphones?',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'read': true,
        'action': () {},
      },
      {
        'id': '5',
        'type': 'system',
        'title': 'Welcome!',
        'message': 'Thanks for joining E-Commerce App',
        'time': DateTime.now().subtract(const Duration(days: 30)),
        'read': true,
        'action': null,
      },
    ];

    final unreadCount = notifications.where((n) => !(n['read'] as bool)).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                // Mark all as read
              },
              child: Text('Mark All Read', style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary)),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: EdgeInsets.all(customSpacing.lg),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => SizedBox(height: customSpacing.sm),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(
                  notification: notification,
                  onTap: notification['action'] as VoidCallback?,
                ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideX(begin: 0.1);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(customSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(customSpacing.xxxl),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_none_outlined, size: 64, color: colorScheme.onPrimaryContainer),
            ),
            SizedBox(height: customSpacing.xl),
            Text('No Notifications', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: customSpacing.md),
            Text(
              'You\'re all caught up!\nWe\'ll notify you when something happens.',
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback? onTap;

  const _NotificationCard({required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final isRead = notification['read'] as bool;
    final type = notification['type'] as String;

    final (icon, iconColor) = switch (type) {
      'order' => (Icons.shopping_bag_outlined, Colors.blue),
      'shipping' => (Icons.local_shipping_outlined, Colors.purple),
      'promotion' => (Icons.local_offer_outlined, Colors.orange),
      'review' => (Icons.rate_review_outlined, Colors.green),
      'system' => (Icons.info_outline, Colors.grey),
      _ => (Icons.notifications_outlined, colorScheme.primary),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        padding: EdgeInsets.all(customSpacing.md),
        decoration: BoxDecoration(
          color: isRead ? colorScheme.surface : colorScheme.primaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(
            color: isRead ? colorScheme.outlineVariant : colorScheme.primary.withValues(alpha: 0.5),
            width: isRead ? 1 : 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(customSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            SizedBox(width: customSpacing.md),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: customSpacing.xs),
                  Text(
                    notification['message'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: customSpacing.sm),
                  Text(
                    _formatTime(notification['time']),
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}