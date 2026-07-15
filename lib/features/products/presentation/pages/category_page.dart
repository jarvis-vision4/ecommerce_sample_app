// Category Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

class CategoryPage extends ConsumerWidget {
  final String categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final category = _getCategory(categoryId);
    final subcategories = category['subcategories'] as List? ?? [];
    final products = List.generate(12, (index) => _mockProduct(index));

    return Scaffold(
      appBar: AppBar(
        title: Text(category['name']),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: const Icon(Icons.sort), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Category header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(customSpacing.lg),
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.1),
                border: Border(bottom: BorderSide(color: category['color'].withOpacity(0.3))),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(customSpacing.md),
                    decoration: BoxDecoration(
                      color: category['color'],
                      borderRadius: BorderRadius.circular(customRadius.lg),
                    ),
                    child: Icon(category['icon'], color: Colors.white, size: 28),
                  ),
                  SizedBox(width: customSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category['name'], style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text(category['description'], style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Subcategories
          if (subcategories.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(customSpacing.lg),
                    child: Text('Shop by Type', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
                      itemCount: subcategories.length,
                      separatorBuilder: (_, __) => SizedBox(width: customSpacing.md),
                      itemBuilder: (context, index) {
                        final sub = subcategories[index];
                        return _SubcategoryCard(
                          name: sub['name'],
                          icon: sub['icon'],
                          color: category['color'],
                          onTap: () {},
                        ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideX(begin: 0.2);
                      },
                    ),
                  ),
                  SizedBox(height: customSpacing.xl),
                ],
              ),
            ),

          // Products
          SliverPadding(
            padding: EdgeInsets.all(customSpacing.lg),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: customSpacing.md,
                mainAxisSpacing: customSpacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ProductCardGrid(
                  product: products[index],
                  onTap: () => context.push('/product/${products[index]['id']}'),
                ).animate().fadeIn(duration: 400.ms, delay: (50 * index).ms).slideY(begin: 0.1),
                childCount: products.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: customSpacing.xxxl)),
        ],
      ),
    );
  }

  Map<String, dynamic> _getCategory(String id) {
    final categories = {
      'electronics': {
        'name': 'Electronics',
        'icon': Icons.devices,
        'count': 245,
        'description': 'Latest gadgets & tech',
        'color': Colors.blue,
        'subcategories': [
          {'name': 'Phones', 'icon': Icons.phone_android},
          {'name': 'Laptops', 'icon': Icons.laptop},
          {'name': 'Audio', 'icon': Icons.headphones},
          {'name': 'Cameras', 'icon': Icons.camera_alt},
          {'name': 'Smart Home', 'icon': Icons.home_max},
        ],
      },
      'fashion': {
        'name': 'Fashion',
        'icon': Icons.checkroom,
        'count': 512,
        'description': 'Trending styles for everyone',
        'color': Colors.pink,
        'subcategories': [
          {'name': 'Men', 'icon': Icons.man},
          {'name': 'Women', 'icon': Icons.woman},
          {'name': 'Kids', 'icon': Icons.child_care},
          {'name': 'Accessories', 'icon': Icons.diamond},
        ],
      },
      'home': {
        'name': 'Home & Garden',
        'icon': Icons.home,
        'count': 189,
        'description': 'Decor, furniture & more',
        'color': Colors.green,
        'subcategories': [
          {'name': 'Furniture', 'icon': Icons.chair},
          {'name': 'Decor', 'icon': Icons.weekend},
          {'name': 'Kitchen', 'icon': Icons.kitchen},
          {'name': 'Garden', 'icon': Icons.grass},
        ],
      },
      'sports': {
        'name': 'Sports',
        'icon': Icons.sports_soccer,
        'count': 98,
        'description': 'Gear for every athlete',
        'color': Colors.orange,
        'subcategories': [
          {'name': 'Fitness', 'icon': Icons.fitness_center},
          {'name': 'Outdoor', 'icon': Icons.hiking},
          {'name': 'Team Sports', 'icon': Icons.sports_basketball},
          {'name': 'Water Sports', 'icon': Icons.pool},
        ],
      },
    };
    return categories[id] ?? {
      'name': 'Category',
      'icon': Icons.category,
      'count': 0,
      'description': '',
      'color': Colors.grey,
      'subcategories': [],
    };
  }

  Map<String, dynamic> _mockProduct(int index) {
    final names = ['Wireless Headphones', 'Smart Watch', 'Running Shoes', 'Coffee Maker', 'Backpack'];
    final prices = [199.99, 299.99, 129.99, 89.99, 79.99];
    return {
      'id': 'prod_$index',
      'name': names[index % names.length],
      'price': prices[index % prices.length],
      'originalPrice': prices[index % prices.length] * 1.3,
      'image': null,
      'rating': 4.0 + (index % 10) / 10,
      'reviews': (index + 1) * 50,
    };
  }
}

class _SubcategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SubcategoryCard({required this.name, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        width: 90,
        padding: EdgeInsets.all(customSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(customSpacing.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: customSpacing.sm),
            Text(
              name,
              style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCardGrid extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _ProductCardGrid({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final hasDiscount = product['originalPrice'] != null && product['originalPrice'] > product['price'];
    final discountPercent = hasDiscount ? ((product['originalPrice'] - product['price']) / product['originalPrice'] * 100).round() : 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(customRadius.lg)),
                    child: product['image'] != null
                        ? Image.network(product['image'], fit: BoxFit.cover, width: double.infinity)
                        : Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Center(child: Icon(Icons.image, size: 48, color: colorScheme.onSurfaceVariant)),
                          ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: customSpacing.sm,
                    left: customSpacing.sm,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: customSpacing.sm, vertical: customSpacing.xs),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(customRadius.full),
                      ),
                      child: Text(
                        '-$discountPercent%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onError,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(customSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: customSpacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: customSpacing.xs),
                      Text(
                        product['rating'].toStringAsFixed(1),
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: customSpacing.xs),
                      Text(
                        '(${product['reviews']})',
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  SizedBox(height: customSpacing.sm),
                  Row(
                    children: [
                      Text(
                        '\$${product['price'].toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: customSpacing.sm),
                        Text(
                          '\$${product['originalPrice'].toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
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