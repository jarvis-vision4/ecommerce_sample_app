// Orders Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customSpacing = context.customSpacing;

    // Mock orders
    final orders = [
      {
        'id': 'ORD-2024-001',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'status': 'delivered',
        'items': 3,
        'total': 549.97,
        'tracking': '1Z999AA10123456784',
      },
      {
        'id': 'ORD-2024-002',
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'status': 'shipped',
        'items': 1,
        'total': 299.99,
        'tracking': '1Z999AA10123456785',
      },
      {
        'id': 'ORD-2024-003',
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'status': 'cancelled',
        'items': 2,
        'total': 199.98,
        'tracking': null,
      },
      {
        'id': 'ORD-2024-004',
        'date': DateTime.now().subtract(const Duration(days: 30)),
        'status': 'delivered',
        'items': 1,
        'total': 89.99,
        'tracking': '1Z999AA10123456786',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: orders.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: EdgeInsets.all(customSpacing.lg),
              itemCount: orders.length,
              separatorBuilder: (_, __) => SizedBox(height: customSpacing.md),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(
                  order: order,
                  onTap: () => context.push('/orders/${order['id']}'),
                  onReorder: order['status'] == 'delivered' ? () {} : null,
                  onReturn: order['status'] == 'delivered' ? () {} : null,
                  onTrack: order['tracking'] != null ? () {} : null,
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
              child: Icon(Icons.receipt_long_outlined, size: 64, color: colorScheme.onPrimaryContainer),
            ),
            SizedBox(height: customSpacing.xl),
            Text('No Orders Yet', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: customSpacing.md),
            Text(
              'Your order history will appear here\nonce you make a purchase.',
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: customSpacing.xxl),
            PrimaryButton(
              label: 'Start Shopping',
              onPressed: () => context.go('/'),
              leadingIcon: Icons.shopping_bag_outlined,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(context.customRadius.xl))),
      builder: (context) => Container(
        padding: EdgeInsets.all(context.customSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Orders', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: context.customSpacing.lg),
            Wrap(
              spacing: context.customSpacing.sm,
              runSpacing: context.customSpacing.sm,
              children: ['All', 'Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Returned']
                  .map((status) => FilterChip(
                        label: Text(status),
                        selected: false,
                        onSelected: (_) {},
                      ))
                  .toList(),
            ),
            SizedBox(height: context.customSpacing.xl),
            PrimaryButton(label: 'Apply Filters', onPressed: () => Navigator.pop(context), size: ButtonSize.lg),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;
  final VoidCallback? onReorder;
  final VoidCallback? onReturn;
  final VoidCallback? onTrack;

  const _OrderCard({
    required this.order,
    required this.onTap,
    this.onReorder,
    this.onReturn,
    this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final status = order['status'] as String;
    final statusConfig = _getStatusConfig(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        padding: EdgeInsets.all(customSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['id'],
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: customSpacing.sm, vertical: customSpacing.xs),
                  decoration: BoxDecoration(
                    color: statusConfig.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(customRadius.full),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusConfig.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: customSpacing.xs),
            Text(
              'Placed on ${_formatDate(order['date'])}',
              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: customSpacing.md),
            Divider(height: 1, color: colorScheme.outlineVariant),
            SizedBox(height: customSpacing.md),
            // Order summary
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${order['items']} items', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: customSpacing.xs),
                      Text(
                        '\$${order['total'].toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions
                Wrap(
                  children: [
                    if (onTrack != null)
                      TextButton.icon(
                        onPressed: onTrack,
                        icon: const Icon(Icons.local_shipping_outlined, size: 18),
                        label: const Text('Track'),
                      ),
                    if (onReorder != null)
                      TextButton.icon(
                        onPressed: onReorder,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text('Reorder'),
                      ),
                    if (onReturn != null)
                      TextButton.icon(
                        onPressed: onReturn,
                        icon: const Icon(Icons.assignment_return_outlined, size: 18),
                        label: const Text('Return'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'pending':
        return _StatusConfig(icon: Icons.schedule, color: Colors.orange);
      case 'processing':
        return _StatusConfig(icon: Icons.inventory_2, color: Colors.blue);
      case 'shipped':
        return _StatusConfig(icon: Icons.local_shipping, color: Colors.purple);
      case 'delivered':
        return _StatusConfig(icon: Icons.check_circle, color: Colors.green);
      case 'cancelled':
        return _StatusConfig(icon: Icons.cancel, color: Colors.red);
      case 'returned':
        return _StatusConfig(icon: Icons.assignment_return, color: Colors.grey);
      default:
        return _StatusConfig(icon: Icons.help, color: Colors.grey);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusConfig {
  final IconData icon;
  final Color color;

  _StatusConfig({required this.icon, required this.color});
}