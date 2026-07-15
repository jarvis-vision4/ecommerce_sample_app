// Auth Feature - Register Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(customSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: customSpacing.xl),
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(customRadius.xl),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 40,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
                SizedBox(height: customSpacing.lg),
                // Title
                Text(
                  'Create Account',
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.sm),
                Text(
                  'Join us for the best shopping experience',
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.xxxl),
                // Name fields
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'First Name',
                        hint: 'John',
                        controller: _firstNameController,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    SizedBox(width: customSpacing.md),
                    Expanded(
                      child: AppTextField(
                        label: 'Last Name',
                        hint: 'Doe',
                        controller: _lastNameController,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.md),
                // Email
                AppTextField(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.md),
                // Password
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: InkWell(
                    child: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 8) return 'At least 8 characters';
                    if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Include uppercase';
                    if (!RegExp(r'[a-z]').hasMatch(value)) return 'Include lowercase';
                    if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include number';
                    return null;
                  },
                ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.md),
                // Confirm Password
                AppTextField(
                  label: 'Confirm Password',
                  hint: '••••••••',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                  onSubmitted: (_) => _handleRegister(),
                ).animate().fadeIn(duration: 600.ms, delay: 800.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.md),
                // Terms
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: customSpacing.xs),
                        child: RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 900.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.lg),
                // Register Button
                PrimaryButton(
                  label: 'Create Account',
                  onPressed: _acceptTerms ? _handleRegister : null,
                  size: ButtonSize.lg,
                ).animate().fadeIn(duration: 600.ms, delay: 1000.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.xl),
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: customSpacing.md),
                      child: Text('or continue with', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                    ),
                    Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 1100.ms),
                SizedBox(height: customSpacing.lg),
                // Social
                Row(
                  children: [
                    Expanded(child: SecondaryButton(label: 'Google', leadingIcon: Icons.g_mobiledata, onPressed: () {}, size: ButtonSize.md)),
                    SizedBox(width: customSpacing.md),
                    Expanded(child: SecondaryButton(label: 'Apple', leadingIcon: Icons.apple, onPressed: () {}, size: ButtonSize.md)),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 1200.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.xxl),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    TextButton(onPressed: () => context.pop(), child: Text('Sign In', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 1300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement registration
      context.go('/verify-email', extra: {'email': _emailController.text});
    }
  }
}