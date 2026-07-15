// Search Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';


class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  final List<String> _recentSearches = [
    'headphones',
    'smart watch',
    'running shoes',
    'coffee maker'
  ];
  List<String> _suggestions = [];
  bool _showSuggestions = false;
  bool _isSearching = false;
  Map<String, dynamic> _searchResults = {};

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _showSuggestions = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
        _searchResults = {};
      });
      return;
    }

    setState(() => _isSearching = true);
    // Simulate search suggestions
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _searchController.text == query) {
        setState(() {
          _suggestions = [
            '$query wireless',
            '$query pro',
            '$query sale',
            '$query review',
            '$query price'
          ];
          _isSearching = false;
        });
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    _focusNode.unfocus();
    setState(() {
      _showSuggestions = false;
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) _recentSearches.removeLast();
      _searchResults = {
        'products': List.generate(6, (i) => _mockProduct(query, i)),
        'categories': [
          {'name': 'Electronics', 'icon': Icons.devices, 'count': 45},
          {'name': 'Accessories', 'icon': Icons.headphones, 'count': 23},
        ],
      };
    });
  }

  void _clearRecentSearches() {
    setState(() => _recentSearches.clear());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        automaticallyImplyLeading: false,
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = {};
                  _showSuggestions = true;
                });
              },
            ),
        ],
      ),
      body: _searchResults.isNotEmpty ? _buildResults() : _buildInitialView(),
    );
  }

  Widget _buildSearchField() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(customRadius.md),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Search products...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: customSpacing.md, vertical: customSpacing.sm),
        ),
        onChanged: _onSearchChanged,
        onSubmitted: _performSearch,
        autofocus: true,
      ),
    );
  }

  Widget _buildInitialView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return SingleChildScrollView(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Searches',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                TextButton(
                    onPressed: _clearRecentSearches,
                    child: const Text('Clear All')),
              ],
            ),
            SizedBox(height: customSpacing.md),
            Wrap(
              spacing: customSpacing.sm,
              runSpacing: customSpacing.sm,
              children: _recentSearches
                  .map((search) => InputChip(
                        label: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.history,
                              size: 16, color: colorScheme.onSurfaceVariant),
                          SizedBox(width: customSpacing.xs),
                          Text(search),
                        ]),
                        onPressed: () => _performSearch(search),
                        onDeleted: () =>
                            setState(() => _recentSearches.remove(search)),
                        backgroundColor: colorScheme.surfaceContainerHighest,
                      ))
                  .toList(),
            ),
            SizedBox(height: customSpacing.xl),
          ],

          // Popular categories
          Text('Popular Categories',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: customSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.md,
            mainAxisSpacing: customSpacing.md,
            childAspectRatio: 1,
            children: const [
              _PopularCategoryCard(
                  name: 'Electronics',
                  icon: Icons.devices,
                  color: Colors.blue,
                  count: '245 items'),
              _PopularCategoryCard(
                  name: 'Fashion',
                  icon: Icons.checkroom,
                  color: Colors.pink,
                  count: '512 items'),
              _PopularCategoryCard(
                  name: 'Home & Garden',
                  icon: Icons.home,
                  color: Colors.green,
                  count: '189 items'),
              _PopularCategoryCard(
                  name: 'Sports',
                  icon: Icons.sports_soccer,
                  color: Colors.orange,
                  count: '98 items'),
              _PopularCategoryCard(
                  name: 'Beauty',
                  icon: Icons.face,
                  color: Colors.purple,
                  count: '334 items'),
              _PopularCategoryCard(
                  name: 'Toys',
                  icon: Icons.toys,
                  color: Colors.red,
                  count: '156 items'),
            ],
          ),
          SizedBox(height: customSpacing.xl),

          // Trending searches
          Text('Trending Now',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: customSpacing.md),
          ...[
            'wireless earbuds',
            'smart watch deals',
            'running shoes sale',
            'coffee machines',
            'backpacks'
          ]
              .map((trend) => Container(
                    margin: EdgeInsets.only(bottom: customSpacing.sm),
                    padding: EdgeInsets.all(customSpacing.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(customRadius.lg),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: colorScheme.primary),
                        SizedBox(width: customSpacing.md),
                        Expanded(
                            child: Text(trend,
                                style: theme.textTheme.titleMedium)),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ))
              ,
        ],
      ),
    );
  }

  Widget _buildResults() {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;

    final products = _searchResults['products'] as List? ?? [];
    final categories = _searchResults['categories'] as List? ?? [];

    return CustomScrollView(
      slivers: [
        // Categories
        if (categories.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(customSpacing.lg),
                  child: Text('Categories',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(width: customSpacing.md),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return _CategoryCard(
                        name: cat['name'],
                        icon: cat['icon'],
                        color: Colors.blue,
                        count: cat['count'],
                        onTap: () {},
                      );
                    },
                  ),
                ),
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
              ),
              childCount: products.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: customSpacing.xxxl)),
      ],
    );
  }

  Map<String, dynamic> _mockProduct(String query, int index) {
    final prices = [199.99, 299.99, 129.99, 89.99, 79.99];
    return {
      'id': 'search_${query}_$index',
      'name': '$query ${["Pro", "Plus", "Max", "Lite", "Air"][index % 5]}',
      'price': prices[index % prices.length],
      'originalPrice': prices[index % prices.length] * 1.3,
      'image': null,
      'rating': 4.0 + (index % 10) / 10,
      'reviews': (index + 1) * 50,
    };
  }
}

class _PopularCategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String count;

  const _PopularCategoryCard(
      {required this.name,
      required this.icon,
      required this.color,
      required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(customRadius.lg),
      child: Container(
        padding: EdgeInsets.all(customSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(customRadius.lg),
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
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: customSpacing.md),
            Text(name,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,),
            Text(count,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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

  const _CategoryCard(
      {required this.name,
      required this.icon,
      required this.color,
      required this.count,
      required this.onTap});

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
          border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
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
            Text(name,
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text('$count items',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
                                    color: colorScheme.onSurfaceVariant))),
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
                          borderRadius:
                              BorderRadius.circular(customRadius.full)),
                      child: Text('-$discountPercent%',
                          style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onError,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(customSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['name'],
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: customSpacing.xs),
                  Row(children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: customSpacing.xs),
                    Text(product['rating'].toStringAsFixed(1),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(width: customSpacing.xs),
                    Text('(${product['reviews']})',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant))
                  ]),
                  SizedBox(height: customSpacing.sm),
                  Row(children: [
                    Text('\$${product['price'].toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary)),
                    if (hasDiscount) ...[
                      SizedBox(width: customSpacing.sm),
                      Text('\$${product['originalPrice'].toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: colorScheme.onSurfaceVariant))
                    ]
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
