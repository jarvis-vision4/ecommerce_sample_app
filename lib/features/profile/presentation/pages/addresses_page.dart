// Addresses Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';


import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class AddressesPage extends ConsumerWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock addresses
    final addresses = [
      {
        'id': '1',
        'type': 'shipping',
        'firstName': 'John',
        'lastName': 'Doe',
        'company': '',
        'addressLine1': '123 Main Street, Apt 4B',
        'addressLine2': '',
        'city': 'New York',
        'state': 'NY',
        'postalCode': '10001',
        'country': 'United States',
        'phone': '+1 (555) 123-4567',
        'isDefault': true,
      },
      {
        'id': '2',
        'type': 'billing',
        'firstName': 'John',
        'lastName': 'Doe',
        'company': 'Acme Corp',
        'addressLine1': '456 Business Ave, Suite 200',
        'addressLine2': '',
        'city': 'San Francisco',
        'state': 'CA',
        'postalCode': '94105',
        'country': 'United States',
        'phone': '+1 (555) 987-6543',
        'isDefault': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAddressDialog(context),
          ),
        ],
      ),
      body: addresses.isEmpty
          ? _buildEmptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final address = addresses[index];
                return _AddressCard(
                  address: address,
                  onEdit: () => _showAddAddressDialog(context, address: address),
                  onDelete: () => _showDeleteDialog(context, address['id'] as String),
                  onSetDefault: () {},
                ).animate().fadeIn(duration: 400.ms, delay: (100 * index).ms).slideX(begin: 0.1);
              },
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
              child: Icon(Icons.location_on_outlined, size: 64, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('No Addresses Yet', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Add shipping and billing addresses\nfor faster checkout.',
              style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: 'Add Address',
              onPressed: () => _showAddAddressDialog(context),
              leadingIcon: Icons.add_location_outlined,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, {Map<String, dynamic>? address}) {
    final isEditing = address != null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
      builder: (context) => _AddAddressSheet(address: address, isEditing: isEditing),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Delete address
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AddAddressSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic>? address;
  final bool isEditing;

  const _AddAddressSheet({this.address, this.isEditing = false});

  @override
  ConsumerState<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends ConsumerState<_AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _companyController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;
  late TextEditingController _phoneController;
  String _addressType = 'shipping';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    _firstNameController = TextEditingController(text: addr?['firstName'] ?? '');
    _lastNameController = TextEditingController(text: addr?['lastName'] ?? '');
    _companyController = TextEditingController(text: addr?['company'] ?? '');
    _addressLine1Controller = TextEditingController(text: addr?['addressLine1'] ?? '');
    _addressLine2Controller = TextEditingController(text: addr?['addressLine2'] ?? '');
    _cityController = TextEditingController(text: addr?['city'] ?? '');
    _stateController = TextEditingController(text: addr?['state'] ?? '');
    _postalCodeController = TextEditingController(text: addr?['postalCode'] ?? '');
    _countryController = TextEditingController(text: addr?['country'] ?? 'United States');
    _phoneController = TextEditingController(text: addr?['phone'] ?? '');
    _addressType = addr?['type'] ?? 'shipping';
    _isDefault = addr?['isDefault'] ?? false;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const customSpacing = AppSpacing.lg;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.md),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.isEditing ? 'Edit Address' : 'Add Address',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                // Form
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      controller: PrimaryScrollController.of(context),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type selector
                          Text('Address Type', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Shipping'),
                                  value: 'shipping',
                                  groupValue: _addressType,
                                  onChanged: (v) => setState(() => _addressType = v!),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Billing'),
                                  value: 'billing',
                                  groupValue: _addressType,
                                  onChanged: (v) => setState(() => _addressType = v!),
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Name fields
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'First Name',
                                  controller: _firstNameController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AppTextField(
                                  label: 'Last Name',
                                  controller: _lastNameController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Company
                          AppTextField(
                            label: 'Company (Optional)',
                            controller: _companyController,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Address Line 1
                          AppTextField(
                            label: 'Address Line 1',
                            controller: _addressLine1Controller,
                            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Address Line 2
                          AppTextField(
                            label: 'Address Line 2 (Optional)',
                            controller: _addressLine2Controller,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // City, State, Postal Code
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: AppTextField(
                                  label: 'City',
                                  controller: _cityController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AppTextField(
                                  label: 'State',
                                  controller: _stateController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Postal Code',
                                  controller: _postalCodeController,
                                  keyboardType: TextInputType.number,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: AppTextField(
                                  label: 'Country',
                                  controller: _countryController,
                                  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                         const SizedBox(height: AppSpacing.md),

                          // Phone
                          AppTextField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Default checkbox
                          CheckboxListTile(
                            title: const Text('Set as default address'),
                            value: _isDefault,
                            onChanged: (v) => setState(() => _isDefault = v!),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: AppSpacing.xl),

                          // Save button
                          PrimaryButton(
                            label: widget.isEditing ? 'Update Address' : 'Save Address',
                            onPressed: _saveAddress,
                            size: ButtonSize.lg,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Save address
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEditing ? 'Address updated!' : 'Address added!'), behavior: SnackBarBehavior.floating),
      );
    }
  }
}

class _AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    final isDefault = address['isDefault'] as bool;

    return Container(
      padding: EdgeInsets.all(customSpacing.md),
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
              Container(
                padding: EdgeInsets.all(customSpacing.xs),
                decoration: BoxDecoration(
                  color: address['type'] == 'shipping' ? Colors.blue.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  address['type'] == 'shipping' ? Icons.local_shipping_outlined : Icons.payment_outlined,
                  color: address['type'] == 'shipping' ? Colors.blue : Colors.green,
                  size: 20,
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Text(
                address['type'].toString().toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: address['type'] == 'shipping' ? Colors.blue : Colors.green,
                ),
              ),
              if (isDefault) ...[
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: customSpacing.sm, vertical: customSpacing.xs),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Default',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: customSpacing.md),
          Text(
            '${address['firstName']} ${address['lastName']}',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (address['company'].toString().isNotEmpty) ...[
            SizedBox(height: customSpacing.xs),
            Text(address['company'], style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
          SizedBox(height: customSpacing.xs),
          Text(address['addressLine1'], style: theme.textTheme.bodyMedium),
          if (address['addressLine2'].toString().isNotEmpty) ...[
            SizedBox(height: customSpacing.xs),
            Text(address['addressLine2'], style: theme.textTheme.bodyMedium),
          ],
          SizedBox(height: customSpacing.xs),
          Text(
            '${address['city']}, ${address['state']} ${address['postalCode']}',
            style: theme.textTheme.bodyMedium,
          ),
          Text(address['country'], style: theme.textTheme.bodyMedium),
          SizedBox(height: customSpacing.xs),
          Text(address['phone'], style: theme.textTheme.bodyMedium),
          SizedBox(height: customSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isDefault)
                TextButton.icon(
                  onPressed: onSetDefault,
                  icon: const Icon(Icons.flag_outlined, size: 18),
                  label: const Text('Set Default'),
                ),
              SizedBox(width: customSpacing.sm),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
              ),
              SizedBox(width: customSpacing.sm),
              TextButton.icon(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
                label: Text('Delete', style: TextStyle(color: colorScheme.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}