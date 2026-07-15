// Auth Feature - Forgot Password Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
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
        child: Padding(
          padding: EdgeInsets.all(customSpacing.xl),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Form(
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
              onPressed: () => Navigator.pop(context),
            ),
          ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),
          SizedBox(height: customSpacing.xl),
          // Icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(customRadius.xl),
              ),
              child: Icon(
                Icons.lock_reset_outlined,
                size: 50,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
          SizedBox(height: customSpacing.xl),
          // Title
          Text(
            'Forgot Password?',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2),
          SizedBox(height: customSpacing.sm),
          Text(
            'Enter your email and we\'ll send you a link to reset your password',
            style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),
          SizedBox(height: customSpacing.xxxl),
          // Email field
          AppTextField(
            label: 'Email',
            hint: 'you@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.email_outlined),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
            onSubmitted: (_) => _handleSubmit(),
          ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.2),
          SizedBox(height: customSpacing.lg),
          // Submit button
          PrimaryButton(
            label: 'Send Reset Link',
            onPressed: _handleSubmit,
            size: ButtonSize.lg,
          ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.2),
          SizedBox(height: customSpacing.xl),
          // Back to login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Remember your password? ', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Sign In')),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customSpacing = context.customSpacing;
    final customRadius = context.customRadius;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Success icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline,
            size: 60,
            color: colorScheme.onSecondaryContainer,
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        SizedBox(height: customSpacing.xl),
        Text(
          'Email Sent!',
          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2),
        SizedBox(height: customSpacing.md),
        Text(
          'We\'ve sent a password reset link to\n${_emailController.text}',
          style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),
        SizedBox(height: customSpacing.lg),
        Text(
          'Check your inbox (and spam folder) and follow the link to reset your password. The link expires in 1 hour.',
          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.2),
        SizedBox(height: customSpacing.xxl),
        // Resend button
        SecondaryButton(
          label: 'Resend Email',
          onPressed: () {
            setState(() => _emailSent = false);
          },
          size: ButtonSize.md,
        ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.2),
        SizedBox(height: customSpacing.md),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back to Sign In'),
        ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
      ],
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Call API
      setState(() => _emailSent = true);
    }
  }
}