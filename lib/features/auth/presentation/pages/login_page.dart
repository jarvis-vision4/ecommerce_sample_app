// Auth Feature - Login Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                SizedBox(height: customSpacing.xxl),
                // Logo/Brand
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
                  'Sample App',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.sm),
                Text(
                  'Sign in to continue shopping',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.xxxl),
                // Email Field
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
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.md),
                // Password Field
                AppTextField(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon:InkWell(
                    child: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 8) return 'Password must be at least 8 characters';
                    return null;
                  },
                  onSubmitted: (_) => _handleLogin(),
                ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.md),
                // Remember me & Forgot password
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value ?? false),
                    ),
                    Text('Remember me', style: theme.textTheme.bodyMedium),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.lg),
                // Login Button
                PrimaryButton(
                  label: 'Sign In',
                  onPressed: _handleLogin,
                  size: ButtonSize.lg,
                ).animate().fadeIn(duration: 600.ms, delay: 800.ms).slideY(begin: 0.2),
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
                ).animate().fadeIn(duration: 600.ms, delay: 900.ms),
                SizedBox(height: customSpacing.lg),
                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        label: 'Google',
                        leadingIcon: Icons.g_mobiledata,
                        onPressed: () {},
                        size: ButtonSize.md,
                      ),
                    ),
                    SizedBox(width: customSpacing.md),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Apple',
                        leadingIcon: Icons.apple,
                        onPressed: () {},
                        size: ButtonSize.md,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 1000.ms).slideY(begin: 0.2),
                SizedBox(height: customSpacing.xl),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: Text('Sign Up', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 1100.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await ref.read(authStateProvider.notifier).login(_emailController.text.trim(), _passwordController.text);
    if (mounted) {
      setState(() => _isLoading = false);
      final authState = ref.read(authStateProvider);
      if (authState.isAuthenticated) {
        context.go('/');
      }
    }
  }
}