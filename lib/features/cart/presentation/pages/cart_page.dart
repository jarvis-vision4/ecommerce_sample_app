// Cart Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';
import '../../../../shared/models/models.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  final _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cartProvider.notifier).loadCart());
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.items;
    final subtotal = cartState.subtotal;
    final shipping = cartState.shipping;
    final tax = cartState.tax;
    final total = cartState.total;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart (${cartItems.length})'),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: _clearCart,
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context)
          : Column(
              children: [
                // Items List
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(customSpacing.lg),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: customSpacing.md),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return _CartItemCard(
                        item: item,
                        onQuantityChanged: (qty) =>
                            _updateQuantity(item.id, qty),
                        onRemove: () => _removeItem(item.id),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                          .slideX(begin: 0.2);
                    },
                  ),
                ),

                // Promo Code
                Container(
                  padding: EdgeInsets.all(customSpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                        top: BorderSide(color: colorScheme.outlineVariant)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          hint: 'Promo code',
                          prefixIcon: const Icon(Icons.local_offer_outlined),
                          controller: _couponController,
                          suffixIcon: InkWell(
                              onTap: _applyCoupon, child: const Text('Apply')),
                        ),
                      ),
                    ],
                  ),
                ),

                // Order Summary
                Container(
                  padding: EdgeInsets.all(customSpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                        top: BorderSide(color: colorScheme.outlineVariant)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order Summary',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      SizedBox(height: customSpacing.md),
                      _SummaryRow(
                          label: 'Subtotal',
                          value: '\$${subtotal.toStringAsFixed(2)}'),
                      _SummaryRow(
                          label: 'Shipping',
                          value: shipping == 0
                              ? 'Free'
                              : '\$${shipping.toStringAsFixed(2)}'),
                      _SummaryRow(
                          label: 'Tax (8%)',
                          value: '\$${tax.toStringAsFixed(2)}'),
                      Divider(height: customSpacing.lg),
                      _SummaryRow(
                        label: 'Total',
                        value: '\$${total.toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                      SizedBox(height: customSpacing.lg),
                      PrimaryButton(
                        label: 'Proceed to Checkout',
                        onPressed: () => context.push('/checkout'),
                        size: ButtonSize.lg,
                      ),


                      SizedBox(height: customSpacing.md),
                      Text(
                        'Secure checkout • Free returns within 30 days',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _updateQuantity(String itemId, int newQuantity) {
    ref.read(cartProvider.notifier).updateQuantity(itemId, newQuantity);
  }

  void _removeItem(String itemId) {
    ref.read(cartProvider.notifier).removeItem(itemId);
  }

  void _clearCart() {
    ref.read(cartProvider.notifier).clearCart();
  }

  void _applyCoupon() {
    final code = _couponController.text.trim();
    if (code.isNotEmpty) {
      ref.read(cartProvider.notifier).applyCoupon(code);
    }
  }

  Widget _buildEmptyCart(BuildContext context) {
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
              child: Icon(Icons.shopping_cart_outlined,
                  size: 64, color: colorScheme.onPrimaryContainer),
            ),
            SizedBox(height: customSpacing.xl),
            Text('Your Cart is Empty',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: customSpacing.md),
            Text(
              'Looks like you haven\'t added anything yet.\nStart shopping to fill your cart!',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: customSpacing.xxl),
            PrimaryButton(
              label: 'Start Shopping',
              onPressed: () => context.go('/'),
              leadingIcon: Icons.arrow_back,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Container(
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(customRadius.lg),
        border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(customRadius.md),
            child: item.imageUrl != null
                ? Image.network(item.imageUrl!,
                    width: 80, height: 80, fit: BoxFit.cover)
                : Container(
                    width: 80,
                    height: 80,
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                        child: Icon(Icons.image,
                            size: 32, color: colorScheme.onSurfaceVariant)),
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
                        item.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          size: 20, color: colorScheme.onSurfaceVariant),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                if (item.variantName != null) ...[
                  SizedBox(height: customSpacing.xs),
                  Text(item.variantName!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
                SizedBox(height: customSpacing.sm),
                // Price & Quantity
                Row(
                  children: [
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary),
                    ),
                    const Spacer(),
                    _QuantitySelector(
                      quantity: item.quantity,
                      onChanged: onQuantityChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
            icon: const Icon(Icons.remove, size: 18),
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: Text('$quantity',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => onChanged(quantity + 1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow(
      {required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: customSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)
                : theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary)
                : theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
