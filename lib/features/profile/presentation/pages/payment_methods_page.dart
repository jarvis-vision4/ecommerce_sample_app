// Payment Methods Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class PaymentMethodsPage extends ConsumerWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock payment methods
    final paymentMethods = [
      {
        'id': '1',
        'type': 'card',
        'brand': 'Visa',
        'last4': '4242',
        'expMonth': 12,
        'expYear': 2027,
        'isDefault': true,
        'nickname': 'Primary Card',
      },
      {
        'id': '2',
        'type': 'card',
        'brand': 'Mastercard',
        'last4': '5555',
        'expMonth': 6,
        'expYear': 2026,
        'isDefault': false,
        'nickname': 'Backup Card',
      },
      {
        'id': '3',
        'type': 'apple_pay',
        'brand': 'Apple Pay',
        'last4': '',
        'expMonth': null,
        'expYear': null,
        'isDefault': false,
        'nickname': 'iPhone 15 Pro',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddPaymentMethodSheet(context),
          ),
        ],
      ),
      body: paymentMethods.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                // Cards
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: paymentMethods.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final method = paymentMethods[index];
                      return _PaymentMethodCard(
                        method: method,
                        onSetDefault:
                            (method['isDefault'] as bool) ? null : () {},
                        onDelete: () =>
                            _showDeleteDialog(context, method['id'] as String),
                      );
                    },
                  ),
                ),

                // Other payment options
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: Border(
                        top: BorderSide(color: colorScheme.outlineVariant)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Other Payment Options',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          _OtherPaymentOption(
                            icon: Icons.apple,
                            label: 'Apple Pay',
                            onTap: () {},
                          ),
                          _OtherPaymentOption(
                            icon: Icons.g_mobiledata,
                            label: 'Google Pay',
                            onTap: () {},
                          ),
                          _OtherPaymentOption(
                            icon: Icons.payment,
                            label: 'PayPal',
                            onTap: () {},
                          ),
                          _OtherPaymentOption(
                            icon: Icons.account_balance_wallet_outlined,
                            label: 'Bank Transfer',
                            onTap: () {},
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.credit_card_outlined,
                  size: 64, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('No Payment Methods',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Add a payment method for faster\ncheckout on your next order.',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: 'Add Payment Method',
              onPressed: () => _showAddPaymentMethodSheet(context),
              leadingIcon: Icons.add,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPaymentMethodSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (context) => const _AddPaymentMethodSheet(),
    );
  }

  void _showAddCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (context) => _AddCardSheet(),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Payment Method'),
        content:
            const Text('Are you sure you want to remove this payment method?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete payment method
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _AddPaymentMethodSheet extends ConsumerStatefulWidget {
  const _AddPaymentMethodSheet();

  @override
  ConsumerState<_AddPaymentMethodSheet> createState() =>
      _AddPaymentMethodSheetState();
}

class _AddPaymentMethodSheetState
    extends ConsumerState<_AddPaymentMethodSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.7,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.md),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Payment Method',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                ),
                // Options
                Expanded(
                  child: ListView(
                    controller: PrimaryScrollController.of(context),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    children: [
                      _OtherPaymentOption(
                        icon: Icons.credit_card,
                        label: 'Credit/Debit Card',
                        subtitle: 'Enter card details manually',
                        onTap: () {
                          Navigator.pop(context);
                          _showAddCardSheet(context);
                        },
                      ),
                      _OtherPaymentOption(
                        icon: Icons.apple,
                        label: 'Apple Pay',
                        subtitle: 'Use cards saved to Apple Wallet',
                        onTap: () {
                          // TODO: Apple Pay
                        },
                      ),
                      _OtherPaymentOption(
                        icon: Icons.g_mobiledata,
                        label: 'Google Pay',
                        subtitle: 'Use cards saved to Google Wallet',
                        onTap: () {
                          // TODO: Google Pay
                        },
                      ),
                      _OtherPaymentOption(
                        icon: Icons.payment,
                        label: 'PayPal',
                        subtitle: 'Link your PayPal account',
                        onTap: () {
                          // TODO: PayPal
                        },
                      ),
                      _OtherPaymentOption(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'Bank Transfer',
                        subtitle: 'Link your bank account',
                        onTap: () {
                          // TODO: Bank Transfer
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _showAddCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (context) => _AddCardSheet(),
    );
  }
}

class _AddCardSheet extends StatefulWidget {
  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isDefault = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const customSpacing = AppSpacing.lg;
    const customRadius = AppRadius.xl;

    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(customRadius)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.md),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2)),
                ),
                Padding(
                  padding: const EdgeInsets.all(customSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Card',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      controller: PrimaryScrollController.of(context),
                      padding: const EdgeInsets.symmetric(horizontal: customSpacing),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card preview
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(customSpacing),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade800,
                                  Colors.blue.shade600
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CARD HOLDER NAME',
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(color: Colors.white70)),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                    _nameController.text.isEmpty
                                        ? 'JOHN DOE'
                                        : _nameController.text.toUpperCase(),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2)),
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                    _cardNumberController.text.isEmpty
                                        ? '•••• •••• •••• ••••'
                                        : _formatCardNumber(
                                            _cardNumberController.text),
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2)),
                                const SizedBox(height: AppSpacing.md),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('EXPIRES',
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                    color: Colors.white70)),
                                        Text(
                                            _expiryController.text.isEmpty
                                                ? 'MM/YY'
                                                : _expiryController.text,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('CVV',
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                    color: Colors.white70)),
                                        Text(
                                            _cvvController.text.isEmpty
                                                ? '***'
                                                : _cvvController.text,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Card number
                          AppTextField(
                            label: 'Card Number',
                            controller: _cardNumberController,
                            keyboardType: TextInputType.number,
                            maxLength: 19,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (v.replaceAll(' ', '').length < 15) {
                                return 'Invalid card number';
                              }
                              return null;
                            },
                            onChanged: (v) => setState(() {}),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Expiry and CVV
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Expiry (MM/YY)',
                                  controller: _expiryController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Required';
                                    }
                                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) {
                                      return 'Invalid format';
                                    }
                                    return null;
                                  },
                                  onChanged: (v) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AppTextField(
                                  label: 'CVV',
                                  controller: _cvvController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  obscureText: true,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Required';
                                    }
                                    if (v.length < 3) return 'Invalid CVV';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Name on card
                          AppTextField(
                            label: 'Name on Card',
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            validator: (v) =>
                                v?.isEmpty ?? true ? 'Required' : null,
                            onChanged: (v) => setState(() {}),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Default checkbox
                          CheckboxListTile(
                            title: const Text('Set as default payment method'),
                            value: _isDefault,
                            onChanged: (v) => setState(() => _isDefault = v!),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Save button
                          PrimaryButton(
                            label: 'Save Card',
                            onPressed: _saveCard,
                            size: ButtonSize.lg,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  String _formatCardNumber(String number) {
    final cleaned = number.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < cleaned.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(cleaned[i]);
    }
    return buffer.toString();
  }

  void _saveCard() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Card saved successfully!'),
            behavior: SnackBarBehavior.floating),
      );
    }
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> method;
  final VoidCallback? onSetDefault;
  final VoidCallback onDelete;

  const _PaymentMethodCard({
    required this.method,
    this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    const customSpacing = AppSpacing.md;
    const customRadius = AppRadius.lg;

    final isDefault = method['isDefault'] as bool;
    final type = method['type'] as String;
    final brand = method['brand'] as String;
    final last4 = method['last4'] as String;

    final (icon, brandColor) = switch (type) {
      'card' => (Icons.credit_card, _PaymentMethodCard._getBrandColor(brand)),
      'apple_pay' => (Icons.apple, Colors.black),
      'google_pay' => (Icons.g_mobiledata, Colors.blue),
      'paypal' => (Icons.payment, Colors.blue),
      _ => (Icons.payment, colorScheme.onSurfaceVariant),
    };

    return Container(
      padding: const EdgeInsets.all(customSpacing),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isDefault
              ? colorScheme.primary
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isDefault ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(customSpacing),
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: brandColor, size: 28),
          ),
          const SizedBox(width: customSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      method['nickname'] ?? _getDisplayName(type, brand, last4),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (isDefault) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          'Default',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (type == 'card') ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$brand ending in $last4 • Exp ${method['expMonth']}/${method['expYear'].toString().substring(2)}',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'default' && onSetDefault != null) onSetDefault!();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              if (onSetDefault != null)
                const PopupMenuItem(
                    value: 'default', child: Text('Set as Default')),
              const PopupMenuItem(
                  value: 'delete',
                  child: Text('Remove', style: TextStyle(color: Colors.red))),
            ],
            child: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  static String _getDisplayName(String type, String brand, String last4) {
    switch (type) {
      case 'card':
        return '$brand ending in $last4';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'paypal':
        return 'PayPal';
      default:
        return type;
    }
  }

  static Color _getBrandColor(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Colors.blue;
      case 'mastercard':
        return Colors.red;
      case 'amex':
        return Colors.green;
      case 'discover':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class _OtherPaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  const _OtherPaymentOption(
      {required this.icon,
      required this.label,
      this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const customSpacing = AppSpacing.md;
    const customRadius = AppRadius.lg;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(customRadius),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(customSpacing),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(customRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(customSpacing),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon,
                  color: theme.colorScheme.onPrimaryContainer, size: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(label,
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }
}
