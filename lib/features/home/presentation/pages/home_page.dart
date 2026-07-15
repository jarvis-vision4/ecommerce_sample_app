// Home Page - Main landing screen
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';


class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;
    final customSizes = context.customSizes;

    // Mock data for demonstration
    final featuredCategories = [
      {'name': 'Electronics', 'icon': Icons.devices, 'color': Colors.blue, 'count': 245},
      {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink, 'count': 512},
      {'name': 'Home & Garden', 'icon': Icons.home, 'color': Colors.green, 'count': 189},
      {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Colors.orange, 'count': 98},
      {'name': 'Beauty', 'icon': Icons.face, 'color': Colors.purple, 'count': 334},
      {'name': 'Toys', 'icon': Icons.toys, 'color': Colors.red, 'count': 156},
    ];

    final flashSaleProducts = List.generate(5, (index) => _mockProduct(index));
    final newArrivals = List.generate(5, (index) => _mockProduct(index + 5));
    final bestSellers = List.generate(5, (index) => _mockProduct(index + 10));

    return CustomScrollView(
      slivers: [
        // App Bar / Search
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: false,
          surfaceTintColor: Colors.transparent,
          title: _SearchBar(onTap: () => context.push('/search')),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push('/profile/notifications'),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () => context.push('/cart'),
            ),
          ],
        ),

        // Categories
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: customSpacing.md, vertical: customSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shop by Category', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    TextButton(
                      onPressed: () => context.push('/products'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 130,
              //   child: ListView.separated(
              //     scrollDirection: Axis.horizontal,
              //     padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
              //     itemCount: featuredCategories.length,
              //     separatorBuilder: (_, __) => SizedBox(width: customSpacing.md),
              //     itemBuilder: (context, index) {
              //       final cat = featuredCategories[index];
              //       return _CategoryCard(
              //         name: cat['name'] as String,
              //         icon: cat['icon'] as IconData,
              //         color: cat['color'] as Color,
              //         count: cat['count'] as int,
              //         onTap: () => context.push('/products?category=${cat['name']}'),
              //       ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideX(begin: 0.2);
              //     },
              //   ),
              // ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 600;

                  final cardHeight = isTablet ? 160.0 : 130.0;
                  final cardWidth = isTablet ? 150.0 : 120.0;

                  return SizedBox(
                    height: cardHeight,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: customSpacing.lg,
                      ),
                      itemCount: featuredCategories.length,
                      separatorBuilder: (_, __) => SizedBox(
                        width: customSpacing.md,
                      ),
                      itemBuilder: (context, index) {
                        final cat = featuredCategories[index];

                        return SizedBox(
                          width: cardWidth,
                          child: _CategoryCard(
                            name: cat['name'] as String,
                            icon: cat['icon'] as IconData,
                            color: cat['color'] as Color,
                            count: cat['count'] as int,
                            onTap: () => context.push(
                              '/products?category=${cat['name']}',
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(
                          duration: 400.ms,
                          delay: (100 * index).ms,
                        )
                            .slideX(begin: 0.2);
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: customSpacing.xl),
            ],
          ),
        ),

        // Flash Sale Banner
        SliverToBoxAdapter(
          child: _FlashSaleBanner(
            endTime: DateTime.now().add(const Duration(hours: 4)),
            onTap: () => context.push('/products?sale=true'),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
        ),

        // Flash Sale Products
        SliverToBoxAdapter(
          child: _ProductSection(
            title: 'Flash Sale',
            subtitle: 'Ends in 4 hours',
            products: flashSaleProducts,
            onViewAll: () => context.push('/products?sale=true'),
          ),
        ),

        // New Arrivals
        SliverToBoxAdapter(
          child: _ProductSection(
            title: 'New Arrivals',
            subtitle: 'Just landed',
            products: newArrivals,
            onViewAll: () => context.push('/products?sort=newest'),
          ),
        ),

        // Best Sellers
        SliverToBoxAdapter(
          child: _ProductSection(
            title: 'Best Sellers',
            subtitle: 'Trending now',
            products: bestSellers,
            onViewAll: () => context.push('/products?sort=popular'),
          ),
        ),

        // Bottom padding
        SliverToBoxAdapter(child: SizedBox(height: customSpacing.xxxl)),
      ],
    );
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

class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.md),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: customSpacing.md, vertical: customSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(customRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 22),
            SizedBox(width: customSpacing.sm),
            Text(
              'Search products...',
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int count;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(customSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.all(customSpacing.md),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: Icon(icon, color: color, size: 24)
                ),
              ),
            ),
            SizedBox(height: customSpacing.sm),
            Text(
              name,
              style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '$count items',
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _FlashSaleBanner extends StatelessWidget {
  final DateTime endTime;
  final VoidCallback onTap;

  const _FlashSaleBanner({required this.endTime, required this.onTap});

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
        margin: EdgeInsets.symmetric(horizontal: customSpacing.lg),
        padding: EdgeInsets.all(customSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(customRadius.lg),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FLASH SALE',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: customSpacing.xs),
                  Text(
                    'Up to 70% Off',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: customSpacing.sm),
                  _CountdownTimer(endTime: endTime),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.flash_on, color: colorScheme.onPrimary, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownTimer extends StatefulWidget {
  final DateTime endTime;

  const _CountdownTimer({required this.endTime});

  @override
  State<_CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<_CountdownTimer> {
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        _updateRemaining();
        return _remaining.inSeconds > 0;
      }
      return false;
    });
  }

  void _updateRemaining() {
    final remaining = widget.endTime.difference(DateTime.now());
    if (remaining.inSeconds > 0 && mounted) {
      setState(() => _remaining = remaining);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        _TimeUnit(value: h, label: 'H'),
        const Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        _TimeUnit(value: m, label: 'M'),
        const Text(':', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        _TimeUnit(value: s, label: 'S'),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final String value;
  final String label;

  const _TimeUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.onPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}

class _ProductSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> products;
  final VoidCallback onViewAll;

  const _ProductSection({
    required this.title,
    required this.subtitle,
    required this.products,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: customSpacing.lg, vertical: customSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
              TextButton(onPressed: onViewAll, child: const Text('View All')),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
            itemCount: products.length,
            separatorBuilder: (_, __) => SizedBox(width: customSpacing.md),
            itemBuilder: (context, index) {
              final p = products[index];
              return _ProductCardMini(
                name: p['name'],
                price: p['price'],
                originalPrice: p['originalPrice'],
                rating: p['rating'],
                reviewCount: p['reviews'],
                image: p['image'],
                onTap: () => context.push('/product/${p['id']}'),
              ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideX(begin: 0.2);
            },
          ),
        ),
      ],
    );
  }
}

class _ProductCardMini extends StatelessWidget {
  final String name;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String? image;
  final VoidCallback onTap;

  const _ProductCardMini({
    required this.name,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final hasDiscount = originalPrice != null && originalPrice! > price;
    final discountPercent = hasDiscount ? ((originalPrice! - price) / originalPrice! * 100).round() : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(customRadius.lg)),
                    child: image != null
                        ? Image.network(image!, fit: BoxFit.cover, width: double.infinity)
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
            // Content
            Padding(
              padding: EdgeInsets.all(customSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
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
                        rating.toStringAsFixed(1),
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: customSpacing.xs),
                      Text(
                        '($reviewCount)',
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  SizedBox(height: customSpacing.sm),
                  Row(
                    children: [
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: customSpacing.sm),
                        Text(
                          '\$${originalPrice!.toStringAsFixed(2)}',
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