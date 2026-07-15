// Wishlist Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    // Mock wishlist items
    final wishlistItems = [
      {'id': '1', 'name': 'Wireless Headphones', 'price': 299.99, 'originalPrice': 399.99, 'rating': 4.7, 'reviews': 1248, 'inStock': true, 'image': null},
      {'id': '2', 'name': 'Smart Watch Series 5', 'price': 199.99, 'originalPrice': null, 'rating': 4.5, 'reviews': 892, 'inStock': true, 'image': null},
      {'id': '3', 'name': 'Running Shoes Pro', 'price': 149.99, 'originalPrice': 179.99, 'rating': 4.8, 'reviews': 567, 'inStock': false, 'image': null},
      {'id': '4', 'name': 'Coffee Maker Deluxe', 'price': 89.99, 'originalPrice': null, 'rating': 4.3, 'reviews': 234, 'inStock': true, 'image': null},
      {'id': '5', 'name': 'Backpack Travel', 'price': 79.99, 'originalPrice': 99.99, 'rating': 4.6, 'reviews': 445, 'inStock': true, 'image': null},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist (${wishlistItems.length})'),
        actions: [
          if (wishlistItems.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'clear') {
                  // Clear wishlist
                } else if (value == 'share') {
                  // Share wishlist
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'share', child: Text('Share Wishlist')),
                const PopupMenuItem(value: 'clear', child: Text('Clear All')),
              ],
            ),
        ],
      ),
      body: wishlistItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                // Bulk actions
                Container(
                  padding: EdgeInsets.all(customSpacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
                  ),
                  child: Row(
                    children: [
                      Text('${wishlistItems.length} items', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('Add All to Cart'),
                      ),
                    ],
                  ),
                ),
                // Items list
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(customSpacing.lg),
                    itemCount: wishlistItems.length,
                    separatorBuilder: (_, __) => SizedBox(height: customSpacing.md),
                    itemBuilder: (context, index) {
                      final item = wishlistItems[index];
                      return _WishlistItemCard(
                        item: item,
                        onRemove: () {},
                        onAddToCart: () {},
                      ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideX(begin: 0.1);
                    },
                  ),
                ),
              ],
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
              child: Icon(Icons.favorite_outline, size: 64, color: colorScheme.onPrimaryContainer),
            ),
            SizedBox(height: customSpacing.xl),
            Text('Your Wishlist is Empty', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: customSpacing.md),
            Text(
              'Save items you love for later.\nThey\'ll be here when you\'re ready.',
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
}

class _WishlistItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistItemCard({required this.item, required this.onRemove, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final hasDiscount = item['originalPrice'] != null && item['originalPrice'] > item['price'];
    final discountPercent = hasDiscount ? ((item['originalPrice'] - item['price']) / item['originalPrice'] * 100).round() : 0;

    return Container(
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(customRadius.lg),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(customRadius.md),
            child: item['image'] != null
                ? Image.network(item['image'], width: 80, height: 80, fit: BoxFit.cover)
                : Container(
                    width: 80,
                    height: 80,
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(child: Icon(Icons.image, size: 32, color: colorScheme.onSurfaceVariant)),
                  ),
          ),
          SizedBox(width: customSpacing.md),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 20, color: colorScheme.onSurfaceVariant),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: customSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: customSpacing.xs),
                    Text(item['rating'].toStringAsFixed(1), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(width: customSpacing.xs),
                    Text('(${item['reviews']})', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
                SizedBox(height: customSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.primary),
                    ),
                    if (hasDiscount) ...[
                      SizedBox(height: customSpacing.sm),
                      Row(
                        children: [
                          Text(
                            '\$${item['originalPrice'].toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall?.copyWith(decoration: TextDecoration.lineThrough, color: colorScheme.onSurfaceVariant),
                          ),
                          SizedBox(width: customSpacing.sm),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: customSpacing.xs, vertical: 2),
                            decoration: BoxDecoration(color: colorScheme.error, borderRadius: BorderRadius.circular(customRadius.full)),
                            child: Text('-$discountPercent%', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onError, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      )
                    ],
                  ],
                ),
                if (!item['inStock']) ...[
                  SizedBox(height: customSpacing.xs),
                  Text('Out of Stock', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.error, fontWeight: FontWeight.w500)),
                ],
              ],
            ),
          ),
          // Actions
          Column(
            children: [
              PrimaryButton(
                label: item['inStock'] ? 'Add to Cart' : 'Notify Me',
                onPressed: item['inStock'] ? onAddToCart : () {},
                size: ButtonSize.sm,
                isFullWidth: false,
              ),
              SizedBox(height: customSpacing.xs),
              GhostButton(
                label: 'Move to Cart',
                onPressed: item['inStock'] ? onAddToCart : null,
                size: ButtonSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}