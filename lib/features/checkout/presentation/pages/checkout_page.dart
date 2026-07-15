// Checkout Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Mock data
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Wireless Headphones',
      'price': 299.99,
      'quantity': 1,
      'image': null
    },
    {
      'id': '2',
      'name': 'Smart Watch',
      'price': 199.99,
      'quantity': 2,
      'image': null
    },
  ];

  String _selectedShipping = 'standard';
  String _selectedPayment = 'card';
  final String _appliedCoupon = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final subtotal = _cartItems.fold<double>(
        0, (sum, item) => sum + item['price'] * item['quantity']);
    final shipping = _selectedShipping == 'express' ? 15.99 : 0;
    final tax = subtotal * 0.08;
    final discount = _appliedCoupon.isNotEmpty ? 20.0 : 0;
    final total = subtotal + shipping + tax - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        actions: [
          // Step indicator
          Padding(
            padding: EdgeInsets.only(right: customSpacing.lg),
            child: Row(
              children: [
                _StepIndicator(
                    number: 1,
                    label: 'Shipping',
                    isActive: _currentStep >= 0,
                    isCompleted: _currentStep > 0),
                _StepConnector(isCompleted: _currentStep > 0),
                _StepIndicator(
                    number: 2,
                    label: 'Payment',
                    isActive: _currentStep >= 1,
                    isCompleted: _currentStep > 1),
                _StepConnector(isCompleted: _currentStep > 1),
                _StepIndicator(
                    number: 3,
                    label: 'Review',
                    isActive: _currentStep >= 2,
                    isCompleted: false),
              ],
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: _onContinue,
          onStepCancel: _onCancel,
          onStepTapped: (step) => setState(() => _currentStep = step),
          controlsBuilder: (context, details) => const SizedBox.shrink(),
          steps: [
            // Step 1: Shipping
            Step(
              title: const Text('Shipping Address'),
              subtitle: const Text('Where should we deliver?'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _ShippingAddressForm(
                onNext: () => _onContinue(),
              ),
            ),
            // Step 2: Shipping Method
            Step(
              title: const Text('Shipping Method'),
              subtitle: const Text('Choose delivery speed'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _ShippingMethodSelector(
                selected: _selectedShipping,
                onChanged: (value) => setState(() => _selectedShipping = value),
              ),
            ),
            // Step 3: Payment
            Step(
              title: const Text('Payment'),
              subtitle: const Text('How would you like to pay?'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _PaymentForm(
                selected: _selectedPayment,
                onChanged: (value) => setState(() => _selectedPayment = value),
              ),
            ),
            // Step 4: Review
            Step(
              title: const Text('Review Order'),
              subtitle: const Text('Confirm your order details'),
              isActive: _currentStep >= 3,
              content: _OrderReview(
                items: _cartItems,
                subtotal: subtotal,
                shipping: shipping.toDouble(),
                tax: tax.toDouble(),
                discount: discount.toDouble(),
                total: total,
                shippingMethod: _selectedShipping,
                paymentMethod: _selectedPayment,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _currentStep < 3
          ? Container(
              padding: EdgeInsets.all(customSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                    top: BorderSide(
                        color:
                            theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: SecondaryButton(
                        label: 'Back',
                        onPressed: _onCancel,
                        size: ButtonSize.lg,
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: customSpacing.md),
                  Expanded(
                    child: PrimaryButton(
                      label: _currentStep == 2 ? 'Review Order' : 'Continue',
                      onPressed: _onContinue,
                      size: ButtonSize.lg,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.all(customSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                    top: BorderSide(
                        color:
                            theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
              ),
              child: PrimaryButton(
                label: 'Place Order - \$${total.toStringAsFixed(2)}',
                onPressed: _placeOrder,
                size: ButtonSize.lg,
              ),
            ),
    );
  }

  void _onContinue() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _onCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  Future<void> _placeOrder() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green),
      );
      context.go('/orders');
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted
                ? colorScheme.primary
                : (isActive
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceContainerHighest),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted || isActive
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: 2,
            ),
          ),
          child: isCompleted
              ? Icon(Icons.check, size: 16, color: colorScheme.onPrimary)
              : Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color:
                isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.only(bottom: 32),
      color: isCompleted ? colorScheme.primary : colorScheme.outlineVariant,
    );
  }
}

class _ShippingAddressForm extends StatelessWidget {
  final VoidCallback onNext;

  const _ShippingAddressForm({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery Address',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: customSpacing.md),
        // Address card
        Container(
          padding: EdgeInsets.all(customSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(customRadius.lg),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Doe',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: customSpacing.xs),
                    Text('123 Main Street, Apt 4B',
                        style: theme.textTheme.bodyMedium),
                    Text('New York, NY 10001',
                        style: theme.textTheme.bodyMedium),
                    Text('United States', style: theme.textTheme.bodyMedium),
                    Text('+1 (555) 123-4567',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Change'),
              ),
            ],
          ),
        ),
        SizedBox(height: customSpacing.lg),
        // Add new address
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_location_outlined),
          label: const Text('Add New Address'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}

class _ShippingMethodSelector extends StatefulWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ShippingMethodSelector(
      {required this.selected, required this.onChanged});

  @override
  State<_ShippingMethodSelector> createState() => _ShippingMethodSelectorState();
}

class _ShippingMethodSelectorState extends State<_ShippingMethodSelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final methods = [
      {
        'id': 'standard',
        'name': 'Standard Shipping',
        'description': '5-7 business days',
        'price': 0.0
      },
      {
        'id': 'express',
        'name': 'Express Shipping',
        'description': '2-3 business days',
        'price': 15.99
      },
      {
        'id': 'overnight',
        'name': 'Overnight Shipping',
        'description': 'Next business day',
        'price': 29.99
      },
    ];

    return Column(
      children: methods.map((method) {
        final isSelected = widget.selected == method['id'];
        return Container(
          margin: EdgeInsets.only(bottom: customSpacing.md),
          child: InkWell(
            onTap: () => widget.onChanged(method['id'] as String),
            borderRadius: BorderRadius.circular(customRadius.lg),
            child: Container(
              padding: EdgeInsets.all(customSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(customRadius.lg),
                color: isSelected
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                    : null,
              ),
              child: Row(
                children: [

                  RadioGroup<String>(
                    groupValue: widget.selected,
                    onChanged: (value) {
                      setState(() {
                          widget.onChanged(value!);
                      });
                    },
                    child:Radio<String>(
                      value: method['id'] as String,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              method['name'] as String,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if ((method['price'] as double) > 0) ...[
                              const Spacer(),
                              Text(
                                '\$${(method['price'] as double).toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          method['description'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PaymentForm extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PaymentForm({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final methods = [
      {'id': 'card', 'name': 'Credit/Debit Card', 'icon': Icons.credit_card},
      {'id': 'apple_pay', 'name': 'Apple Pay', 'icon': Icons.apple},
      {'id': 'google_pay', 'name': 'Google Pay', 'icon': Icons.g_mobiledata},
      {'id': 'paypal', 'name': 'PayPal', 'icon': Icons.payment},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: customSpacing.md),
        ...methods.map((method) {
          final isSelected = selected == method['id'];
          return Container(
            margin: EdgeInsets.only(bottom: customSpacing.md),
            child: InkWell(
              onTap: () => onChanged(method['id'] as String),
              borderRadius: BorderRadius.circular(customRadius.lg),
              child: Container(
                padding: EdgeInsets.all(customSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(customRadius.lg),
                  color: isSelected
                      ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                      : null,
                ),
                child: Row(
                  children: [
                    Radio<String>(
                      value: method['id'] as String,
                      groupValue: selected,
                      onChanged: (value) => onChanged(value!),
                    ),
                    Icon(method['icon'] as IconData,
                        size: 28,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant),
                    SizedBox(width: customSpacing.md),
                    Text(method['name'] as String,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          );
        }),
        SizedBox(height: customSpacing.lg),
        // Saved cards
        if (selected == 'card') ...[
          Text('Saved Cards',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: customSpacing.md),
          _SavedCardTile(
              cardNumber: '4242', brand: 'Visa', isDefault: true, onTap: () {}),
          _SavedCardTile(
              cardNumber: '5555',
              brand: 'Mastercard',
              isDefault: false,
              onTap: () {}),
          SizedBox(height: customSpacing.md),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_card),
            label: const Text('Add New Card'),
            style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
          ),
        ],
      ],
    );
  }
}

class _SavedCardTile extends StatelessWidget {
  final String cardNumber;
  final String brand;
  final bool isDefault;
  final VoidCallback onTap;

  const _SavedCardTile(
      {required this.cardNumber,
      required this.brand,
      required this.isDefault,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(customRadius.lg),
      ),
      child: Row(
        children: [
          Radio<bool>(
              value: true, groupValue: isDefault, onChanged: (_) => onTap()),
          Container(
            width: 48,
            height: 30,
            decoration: BoxDecoration(
              color: brand == 'Visa' ? Colors.blue : Colors.red,
              borderRadius: BorderRadius.circular(customRadius.sm),
            ),
            child: Center(
                child: Text(brand,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700))),
          ),
          SizedBox(width: customSpacing.md),
          Text('•••• $cardNumber',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
          if (isDefault) ...[
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.sm, vertical: customSpacing.xs),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(customRadius.full),
              ),
              child: Text('Default',
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderReview extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;
  final String shippingMethod;
  final String paymentMethod;

  const _OrderReview({
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.discount,
    required this.total,
    required this.shippingMethod,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order items
        Text('Order Items',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: customSpacing.md),
        ...items.map((item) => Container(
              margin: EdgeInsets.only(bottom: customSpacing.md),
              padding: EdgeInsets.all(customSpacing.md),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(customRadius.lg),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(customRadius.sm),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Center(
                          child: Icon(Icons.image,
                              color: theme.colorScheme.onSurfaceVariant)),
                    ),
                  ),
                  SizedBox(width: customSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'],
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w500)),
                        Text('Qty: ${item['quantity']}',
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Text(
                      '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            )),
        SizedBox(height: customSpacing.xl),
        // Summary
        Container(
          padding: EdgeInsets.all(customSpacing.lg),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(customRadius.lg),
          ),
          child: Column(
            children: [
              _SummaryRow(context,
                  label: 'Subtotal', value: '\$${subtotal.toStringAsFixed(2)}'),
              _SummaryRow(context,
                  label: 'Shipping',
                  value: shipping == 0
                      ? 'Free'
                      : '\$${shipping.toStringAsFixed(2)}'),
              _SummaryRow(context,
                  label: 'Tax', value: '\$${tax.toStringAsFixed(2)}'),
              if (discount > 0)
                _SummaryRow(context,
                    label: 'Discount',
                    value: '-\$${discount.toStringAsFixed(2)}'),
              Divider(
                  height: customSpacing.lg,
                  color: theme.colorScheme.outlineVariant),
              _SummaryRow(context,
                  label: 'Total',
                  value: '\$${total.toStringAsFixed(2)}',
                  isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _SummaryRow(BuildContext context,
      {required String label, required String value, bool isTotal = false}) {
    final theme = Theme.of(context);
    final customSpacing = context.customSpacing;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: customSpacing.sm),
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
