// Order Detail Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class OrderDetailPage extends ConsumerWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;

    // Mock order data
    final order = {
      'id': orderId,
      'orderNumber': 'ORD-2024-001',
      'status': 'delivered',
      'paymentStatus': 'paid',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'items': [
        {'id': '1', 'name': 'Premium Wireless Headphones', 'variant': 'Black', 'price': 299.99, 'quantity': 1, 'image': null},
        {'id': '2', 'name': 'Smart Watch Series 5', 'variant': 'Silver / 44mm', 'price': 199.99, 'quantity': 1, 'image': null},
      ],
      'shippingAddress': {'name': 'John Doe', 'street': '123 Main St, Apt 4B', 'city': 'New York', 'state': 'NY', 'zip': '10001', 'country': 'USA', 'phone': '+1 (555) 123-4567'},
      'billingAddress': {'name': 'John Doe', 'street': '123 Main St, Apt 4B', 'city': 'New York', 'state': 'NY', 'zip': '10001', 'country': 'USA'},
      'shippingMethod': {'name': 'Standard Shipping', 'price': 0.0, 'estimatedDays': '5-7 business days'},
      'paymentMethod': {'type': 'card', 'brand': 'Visa', 'last4': '4242'},
      'subtotal': 499.98,
      'shipping': 0.0,
      'tax': 39.99,
      'discount': 0.0,
      'total': 539.97,
      'trackingNumber': '1Z999AA10123456784',
      'trackingUrl': 'https://tracking.example.com/1Z999AA10123456784',
    };

    final status = order['status'] as String;
    final statusConfig = _getStatusConfig(status);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order['orderNumber']}'),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Status Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(customSpacing.lg),
              decoration: BoxDecoration(
                color: statusConfig.color.withValues(alpha: 0.1),
                border: Border(bottom: BorderSide(color: statusConfig.color.withValues(alpha: 0.3))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(customSpacing.md),
                        decoration: BoxDecoration(
                          color: statusConfig.color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(statusConfig.icon, color: Colors.white, size: 24),
                      ),
                      SizedBox(width: customSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              statusConfig.label,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: statusConfig.color,
                              ),
                            ),
                            Text(
                              'Placed on ${_formatDate(order['date'] as DateTime)}',
                              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: customSpacing.lg),
                  // Progress steps
                  _OrderProgressSteps(
                    currentStatus: status,
                    steps: const ['pending', 'confirmed', 'processing', 'shipped', 'delivered'],
                  ),
                ],
              ),
            ),
          ),

          // Order Items
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(customSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Items', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: customSpacing.md),
                  ...(order['items'] as List).map((item) => _OrderItemCard(item: item, onTap: () => context.push('/product/${item['id']}'))),
                  SizedBox(height: customSpacing.xl),
                ],
              ),
            ),
          ),

          // Shipping Address
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Shipping Address',
              icon: Icons.local_shipping_outlined,
              child: _AddressCard(address: order['shippingAddress'] as Map<String, dynamic>),
            ),
          ),

          // Billing Address
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Billing Address',
              icon: Icons.credit_card_outlined,
              child: _AddressCard(address: order['billingAddress'] as Map<String, dynamic>),
            ),
          ),

          // Shipping Method
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Shipping Method',
              icon: Icons.local_shipping_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((order['shippingMethod'] as Map)['name'] as String, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: customSpacing.xs),
                  Text((order['shippingMethod'] as Map)['estimatedDays'] as String, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  SizedBox(height: customSpacing.sm),
                  if (order['trackingNumber'] != null) ...[
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    SizedBox(height: customSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tracking Number', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                              Text(order['trackingNumber'] as String, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 1)),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text('Track Package'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Payment Method
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Payment Method',
              icon: Icons.payment_outlined,
              child: Row(
                children: [
                  Icon(_getPaymentIcon((order['paymentMethod'] as Map)['type'] as String), color: colorScheme.onSurfaceVariant, size: 28),
                  SizedBox(width: customSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${(order['paymentMethod'] as Map)['brand']} ending in ${(order['paymentMethod'] as Map)['last4']}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        Text('Payment Status: ${(order['paymentStatus'] as String).toUpperCase()}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.green, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Order Summary
          SliverToBoxAdapter(
            child: _SectionCard(
              title: 'Order Summary',
              icon: Icons.receipt_long_outlined,
              child: Column(
                children: [
                  _SummaryRow(label: 'Subtotal', value: '\$${(order['subtotal'] as num).toStringAsFixed(2)}'),
                  _SummaryRow(label: 'Shipping', value: (order['shipping'] as num) == 0 ? 'Free' : '\$${(order['shipping'] as num).toStringAsFixed(2)}'),
                  _SummaryRow(label: 'Tax', value: '\$${(order['tax'] as num).toStringAsFixed(2)}'),
                  if ((order['discount'] as num) > 0) _SummaryRow(label: 'Discount', value: '-\$${(order['discount'] as num).toStringAsFixed(2)}', isDiscount: true),
                  Divider(height: 1, color: colorScheme.outlineVariant),
                  _SummaryRow(label: 'Total', value: '\$${(order['total'] as num).toStringAsFixed(2)}', isTotal: true),
                ],
              ),
            ),
          ),

          // Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(customSpacing.lg),
              child: Column(
                children: [
                  if (status == 'delivered') ...[
                    Row(
                      children: [
                        Flexible(
                          child: SecondaryButton(
                            label: 'Buy Again',
                            onPressed: () {},
                            size: ButtonSize.lg,
                            leadingIcon: Icons.refresh,
                          ),
                        ),
                        SizedBox(width: customSpacing.md),
                        Flexible(
                          child: PrimaryButton(
                            label: 'Write Review',
                            onPressed: () {},
                            size: ButtonSize.lg,
                            leadingIcon: Icons.rate_review,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: customSpacing.md),

                    Row(
                      children: [
                        Flexible(
                          child: GhostButton(
                            label: 'Return Item',
                            onPressed: () {},
                            size: ButtonSize.lg,
                            leadingIcon: Icons.assignment_return,
                          ),
                        ),
                        SizedBox(width: customSpacing.md),
                        Flexible(
                          child: GhostButton(
                            label: 'Track Package',
                            onPressed: () {},
                            size: ButtonSize.lg,
                            leadingIcon: Icons.local_shipping,
                          ),
                        ),
                      ],
                    ),
                  ] else if (status == 'shipped') ...[
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        label: 'Track Package',
                        onPressed: () {},
                        size: ButtonSize.lg,
                        leadingIcon: Icons.local_shipping,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: customSpacing.xxxl)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'pending':
        return _StatusConfig(icon: Icons.schedule, color: Colors.orange, label: 'Pending');
      case 'confirmed':
        return _StatusConfig(icon: Icons.check_circle, color: Colors.blue, label: 'Confirmed');
      case 'processing':
        return _StatusConfig(icon: Icons.inventory_2, color: Colors.purple, label: 'Processing');
      case 'shipped':
        return _StatusConfig(icon: Icons.local_shipping, color: Colors.indigo, label: 'Shipped');
      case 'delivered':
        return _StatusConfig(icon: Icons.check_circle_outline, color: Colors.green, label: 'Delivered');
      case 'cancelled':
        return _StatusConfig(icon: Icons.cancel, color: Colors.red, label: 'Cancelled');
      case 'returned':
        return _StatusConfig(icon: Icons.assignment_return, color: Colors.grey, label: 'Returned');
      default:
        return _StatusConfig(icon: Icons.help, color: Colors.grey, label: status);
    }
  }

  IconData _getPaymentIcon(String type) {
    switch (type) {
      case 'card':
        return Icons.credit_card;
      case 'apple_pay':
        return Icons.apple;
      case 'google_pay':
        return Icons.g_mobiledata;
      case 'paypal':
        return Icons.payment;
      default:
        return Icons.payment;
    }
  }
}

class _OrderProgressSteps extends StatelessWidget {
  final String currentStatus;
  final List<String> steps;

  const _OrderProgressSteps({required this.currentStatus, required this.steps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;

    final currentIndex = steps.indexOf(currentStatus);
    final stepLabels = ['Pending', 'Confirmed', 'Processing', 'Shipped', 'Delivered'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final isCompleted = index < currentIndex;
          final isCurrent = index == currentIndex;

          return SizedBox(
            width: 72,
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index <= currentIndex ? colorScheme.primary : colorScheme.outlineVariant,
                        ),
                      ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted || isCurrent ? colorScheme.primary : colorScheme.outlineVariant,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? Icon(Icons.check, size: 16, color: colorScheme.onPrimary)
                          : Center(
                              child: Text(
                                '${index + 1}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isCurrent ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: customSpacing.xs),
                Text(
                  stepLabels[index],
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isCompleted || isCurrent ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    fontWeight: isCompleted || isCurrent ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _OrderItemCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        margin: EdgeInsets.only(bottom: customSpacing.md),
        padding: EdgeInsets.all(customSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(customRadius.md),
              child: item['image'] != null
                  ? Image.network(item['image'], width: 60, height: 60, fit: BoxFit.cover)
                  : Container(
                      width: 60,
                      height: 60,
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(child: Icon(Icons.image, size: 24, color: colorScheme.onSurfaceVariant)),
                    ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (item['variant'] != null) ...[
                    SizedBox(height: customSpacing.xs),
                    Text(item['variant'], style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                  SizedBox(height: customSpacing.sm),
                  Row(
                    children: [
                      Text('\$${item['price'].toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary)),
                      const Spacer(),
                      Text('Qty: ${item['quantity']}', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Container(
      margin: EdgeInsets.fromLTRB(customSpacing.lg, 0, customSpacing.lg, customSpacing.lg),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(customRadius.lg),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colorScheme.primary, size: 22),
              SizedBox(width: customSpacing.sm),
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: customSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(address['name'], style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: customSpacing.xs),
        Text(address['street'], style: theme.textTheme.bodyMedium),
        Text('${address['city']}, ${address['state']} ${address['zip']}', style: theme.textTheme.bodyMedium),
        Text(address['country'], style: theme.textTheme.bodyMedium),
        if (address['phone'] != null) ...[
          SizedBox(height: customSpacing.xs),
          Text(address['phone'], style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isDiscount;

  const _SummaryRow({required this.label, required this.value, this.isTotal = false, this.isDiscount = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: customSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
                : theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary)
                : isDiscount
                    ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.green)
                    : theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _StatusConfig {
  final IconData icon;
  final Color color;
  final String label;

  _StatusConfig({required this.icon, required this.color, required this.label});
}