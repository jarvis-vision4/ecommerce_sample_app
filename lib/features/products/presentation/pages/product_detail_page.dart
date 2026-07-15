// Product Detail Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/models.dart';
import '../../../../shared/widgets/ui_components.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _selectedImageIndex = 0;
  String? _selectedVariant;
  int _quantity = 1;
  bool _isInWishlist = false;

  // Mock product data
  final Map<String, dynamic> _product = {
    'id': 'prod_1',
    'name': 'Premium Wireless Headphones',
    'description':
        'Experience crystal-clear sound with our premium wireless headphones. Featuring active noise cancellation, 30-hour battery life, and premium comfort for all-day listening.',
    'shortDescription': 'Premium wireless headphones with ANC',
    'price': 299.99,
    'originalPrice': 399.99,
    'images': [],
    'rating': 4.7,
    'reviews': 1248,
    'variants': [
      {'id': 'var_1', 'name': 'Black', 'color': Colors.black, 'stock': 50},
      {'id': 'var_2', 'name': 'Silver', 'color': Colors.grey, 'stock': 30},
      {'id': 'var_3', 'name': 'Blue', 'color': Colors.blue, 'stock': 15},
      {
        'id': 'var_4',
        'name': 'Rose Gold',
        'color': const Color(0xFFE8B4B8),
        'stock': 8
      },
    ],
    'features': [
      'Active Noise Cancellation',
      '30-hour battery life',
      'Premium comfort ear cushions',
      'Bluetooth 5.3 connectivity',
      'Quick charge: 5 min = 1 hour',
      'Voice assistant support',
    ],
    'specs': {
      'Driver Size': '40mm',
      'Frequency Response': '20Hz - 20kHz',
      'Impedance': '32Ω',
      'Bluetooth Version': '5.3',
      'Battery Life': '30 hours (ANC on)',
      'Charge Time': '2 hours',
      'Weight': '250g',
    },
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;
    final customSizes = context.customSizes;

    final hasDiscount = _product['originalPrice'] != null &&
        _product['originalPrice'] > _product['price'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with images
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            surfaceTintColor: Colors.transparent,
            leading: Container(
              margin: EdgeInsets.all(customSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(customSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                      _isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: _isInWishlist ? colorScheme.error : null),
                  onPressed: () =>
                      setState(() => _isInWishlist = !_isInWishlist),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                children: [
                  // Main image
                  PageView.builder(
                    itemCount: 4,
                    onPageChanged: (index) =>
                        setState(() => _selectedImageIndex = index),
                    itemBuilder: (context, index) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(Icons.headphones,
                            size: 120, color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  // Image indicators
                  Positioned(
                    bottom: customSpacing.lg,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          4,
                          (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(
                                    horizontal: customSpacing.xs),
                                width: _selectedImageIndex == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _selectedImageIndex == index
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                  borderRadius:
                                      BorderRadius.circular(customRadius.full),
                                ),
                              )),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(customSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating & Title
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 20, color: Colors.amber),
                                SizedBox(width: customSpacing.xs),
                                Text(
                                  _product['rating'].toStringAsFixed(1),
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                SizedBox(width: customSpacing.sm),
                                Text(
                                  '(${_product['reviews']} reviews)',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            SizedBox(height: customSpacing.xs),
                            Text(
                              _product['name'],
                              style: theme.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      // Share button
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: customSpacing.lg),

                  // Price
                  Row(
                    children: [
                      Text(
                        '\$${_product['price'].toStringAsFixed(2)}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (hasDiscount) ...[
                        SizedBox(width: customSpacing.md),
                        Text(
                          '\$${_product['originalPrice'].toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: customSpacing.sm),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: customSpacing.sm,
                              vertical: customSpacing.xs),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            borderRadius:
                                BorderRadius.circular(customRadius.full),
                          ),
                          child: Text(
                            'Save ${((_product['originalPrice'] - _product['price']) / _product['originalPrice'] * 100).round()}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onError,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: customSpacing.lg),

                  // Short Description
                  Text(
                    _product['shortDescription'],
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: customSpacing.xl),

                  // Variants
                  if (_product['variants'] != null) ...[
                    Text('Color',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: customSpacing.md),
                    Wrap(
                      spacing: customSpacing.sm,
                      runSpacing: customSpacing.sm,
                      children: (_product['variants'] as List).map((variant) {
                        final isSelected = _selectedVariant == variant['id'];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedVariant = variant['id']),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.all(customSpacing.xs),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.outlineVariant,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: variant['color'],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: customSpacing.xl),
                  ],

                  // Quantity Selector
                  Row(
                    children: [
                      Text('Quantity',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      _QuantitySelector(
                        quantity: _quantity,
                        onChanged: (value) => setState(() => _quantity = value),
                      ),
                    ],
                  ),
                  SizedBox(height: customSpacing.xl),

                  // Features
                  Text('Key Features',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: customSpacing.md),
                  Column(
                    children: (_product['features'] as List)
                        .map((feature) => Padding(
                              padding:
                                  EdgeInsets.only(bottom: customSpacing.sm),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle,
                                      size: 20, color: colorScheme.primary),
                                  SizedBox(width: customSpacing.sm),
                                  Expanded(
                                      child: Text(feature,
                                          style: theme.textTheme.bodyMedium)),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: customSpacing.xl),

                  // Specifications
                  Text('Specifications',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: customSpacing.md),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(customRadius.lg),
                    ),
                    child: Column(
                      children: (_product['specs'] as Map<String, String>)
                          .entries
                          .map((entry) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: customSpacing.md,
                                    vertical: customSpacing.sm),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: colorScheme.outlineVariant
                                              .withValues(alpha: 0.5))),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(entry.key,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500)),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(entry.value,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant)),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: customSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom Bar
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(customSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2))
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Expanded(
                child: GhostButton(
                  label: 'Add to Wishlist',
                  leadingIcon:
                      _isInWishlist ? Icons.favorite : Icons.favorite_border,
                  onPressed: () =>
                      setState(() => _isInWishlist = !_isInWishlist),
                  size: ButtonSize.lg,
                ),
              ),
              SizedBox(width: customSpacing.md),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Add to Cart',
                  onPressed: _addToCart,
                  size: ButtonSize.lg,
                  leadingIcon: Icons.add_shopping_cart_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart() {
    ref.read(cartProvider.notifier).addItem(AddToCartRequest(
          productId: _product['id'] as String,
          quantity: _quantity,
          variantName: _selectedVariant,
        ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Added to cart!'), duration: Duration(seconds: 1)),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customRadius = context.customRadius;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(customRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          Text('$quantity',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}
