// Product List Page - Category/Search results
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';


import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class ProductListPage extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? searchQuery;

  const ProductListPage({super.key, this.categoryId, this.searchQuery});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final ScrollController _scrollController = ScrollController();
  String _sortBy = 'relevance';
  String _viewMode = 'grid';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryId ?? widget.searchQuery ?? 'Products'),
        actions: [
          IconButton(
            icon: Icon(_viewMode == 'grid' ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(
                () => _viewMode = _viewMode == 'grid' ? 'list' : 'grid'),
          ),
          PopupMenuButton<String>(
            initialValue: _sortBy,
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'relevance', child: Text('Relevance')),
              const PopupMenuItem(
                  value: 'price_asc', child: Text('Price: Low to High')),
              const PopupMenuItem(
                  value: 'price_desc', child: Text('Price: High to Low')),
              const PopupMenuItem(value: 'newest', child: Text('Newest First')),
              const PopupMenuItem(
                  value: 'popular', child: Text('Most Popular')),
              const PopupMenuItem(value: 'rating', child: Text('Top Rated')),
            ],
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Filter bar
          SliverToBoxAdapter(
            child: _FilterBar(
              onFilterTap: () => _showFilterBottomSheet(),
            ),
          ),
          // Products
          _viewMode == 'grid' ? _buildGridView() : _buildListView(),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    // Mock products
    final products = List.generate(20, (index) => _mockProduct(index));

    return SliverPadding(
      padding: EdgeInsets.all(context.customSpacing.lg),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          childAspectRatio: 0.54,
          crossAxisSpacing: context.customSpacing.md,
          mainAxisSpacing: context.customSpacing.md,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _ProductCardGrid(
            product: products[index],
            onTap: () => context.push('/product/${products[index]['id']}'),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: (50 * index).ms)
              .slideY(begin: 0.1),
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildListView() {
    final products = List.generate(20, (index) => _mockProduct(index));

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _ProductCardList(
          product: products[index],
          onTap: () => context.push('/product/${products[index]['id']}'),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: (50 * index).ms)
            .slideX(begin: 0.1),
        childCount: products.length,
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(context.customRadius.xl))),
      builder: (context) => _FilterBottomSheet(),
    );
  }

  Map<String, dynamic> _mockProduct(int index) {
    final names = [
      'Wireless Headphones',
      'Smart Watch',
      'Running Shoes',
      'Coffee Maker',
      'Backpack'
    ];
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

class _FilterBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const _FilterBar({required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: customSpacing.lg, vertical: customSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
            bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withOpacity(0.5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onFilterTap,
              icon: const Icon(Icons.filter_list, size: 20),
              label: const Text('Filters'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: customSpacing.sm),
              ),
            ),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sort, size: 20),
              label: const Text('Sort'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: customSpacing.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(customRadius.xl)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: EdgeInsets.only(top: customSpacing.md),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.all(customSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filters',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      TextButton(
                          onPressed: () {}, child: const Text('Clear All')),
                    ],
                  ),
                ),
                // Filter content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
                    children: [
                      const _FilterSection(title: 'Categories', options: [
                        'Electronics',
                        'Fashion',
                        'Home',
                        'Sports',
                        'Beauty'
                      ]),
                      const _FilterSection(title: 'Price Range', options: [
                        'Under \$25',
                        '\$25 - \$50',
                        '\$50 - \$100',
                        '\$100 - \$200',
                        'Over \$200'
                      ]),
                      const _FilterSection(title: 'Brand', options: [
                        'Apple',
                        'Samsung',
                        'Nike',
                        'Adidas',
                        'Sony'
                      ]),
                      const _FilterSection(title: 'Rating', options: [
                        '4★ & Up',
                        '3★ & Up',
                        '2★ & Up',
                        '1★ & Up'
                      ]),
                      const _FilterSection(
                          title: 'Availability',
                          options: ['In Stock', 'On Sale', 'Free Shipping']),
                      SizedBox(height: customSpacing.xxl),
                      PrimaryButton(
                        label: 'Apply Filters',
                        onPressed: () => Navigator.pop(context),
                        size: ButtonSize.lg,
                      ),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;

  const _FilterSection({required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: customSpacing.md),
        Wrap(
          spacing: customSpacing.sm,
          runSpacing: customSpacing.sm,
          children: options
              .map((opt) => FilterChip(
                    label: Text(opt),
                    onSelected: (v) {},
                    selected: false,
                  ))
              .toList(),
        ),
        SizedBox(height: customSpacing.xl),
      ],
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

    final hasDiscount = product['originalPrice'] != null &&
        product['originalPrice'] > product['price'];
    final discountPercent = hasDiscount
        ? ((product['originalPrice'] - product['price']) /
                product['originalPrice'] *
                100)
            .round()
        : 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border:
              Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
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
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(customRadius.lg)),
                    child: product['image'] != null
                        ? Image.network(product['image'],
                            fit: BoxFit.cover, width: double.infinity)
                        : Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Center(
                                child: Icon(Icons.image,
                                    size: 48,
                                    color: colorScheme.onSurfaceVariant)),
                          ),
                  ),
                ),
                if (hasDiscount)
                  Positioned(
                    top: customSpacing.sm,
                    left: customSpacing.sm,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: customSpacing.sm,
                          vertical: customSpacing.xs),
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
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'],
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
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
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: customSpacing.xs),
                        Text(
                          '(${product['reviews']})',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCardList extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const _ProductCardList({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final hasDiscount = product['originalPrice'] != null &&
        product['originalPrice'] > product['price'];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: customSpacing.lg, vertical: customSpacing.sm),
        padding: EdgeInsets.all(customSpacing.md),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(customRadius.lg),
          border:
              Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(customRadius.md),
              child: product['image'] != null
                  ? Image.network(product['image'],
                      width: 100, height: 100, fit: BoxFit.cover)
                  : Container(
                      width: 100,
                      height: 100,
                      color: colorScheme.surfaceContainerHighest,
                      child: Center(
                          child: Icon(Icons.image,
                              size: 32, color: colorScheme.onSurfaceVariant)),
                    ),
            ),
            SizedBox(width: customSpacing.md),
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'],
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: customSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: customSpacing.xs),
                    Text(product['rating'].toStringAsFixed(1),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(width: customSpacing.xs),
                    Text('(${product['reviews']})',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
                SizedBox(height: customSpacing.sm),
                Row(
                  children: [
                    Text('\$${product['price'].toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary)),
                    if (hasDiscount) ...[
                      SizedBox(width: customSpacing.sm),
                      Text('\$${product['originalPrice'].toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: colorScheme.onSurfaceVariant)),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
