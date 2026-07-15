// Auth Feature - Verify Email Page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/ui_components.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  final String email;

  const VerifyEmailPage({super.key, required this.email});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  int _resendCountdown = 0;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _resendCountdown = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _resendCountdown--);
        return _resendCountdown > 0;
      }
      return false;
    });
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mark_email_read_outlined,
                  size: 60,
                  color: colorScheme.onPrimaryContainer,
                ),
              ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
              SizedBox(height: customSpacing.xl),
              // Title
              Text(
                'Verify Your Email',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.2),
              SizedBox(height: customSpacing.md),
              // Message
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  children: [
                    const TextSpan(text: 'We\'ve sent a verification link to '),
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    ),
                    const TextSpan(text: '. Please check your inbox and click the link to verify your account.'),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),
              SizedBox(height: customSpacing.xl),
              // Resend timer
              if (_resendCountdown > 0)
                Text(
                  'Resend email in $_resendCountdown',
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w500),
                ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
              SizedBox(height: customSpacing.xl),
              // Buttons
              PrimaryButton(
                label: _isResending ? 'Sending...' : 'Resend Email',
                onPressed: _resendCountdown == 0 && !_isResending ? _resendEmail : null,
                size: ButtonSize.lg,
                leadingIcon: Icons.email_outlined,
              ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.2),
              SizedBox(height: customSpacing.md),
              SecondaryButton(
                label: '- Continue',
                onPressed: _verifyEmail,
                size: ButtonSize.lg,
                leadingIcon: Icons.check_circle_outline,
              ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideY(begin: 0.2),
              SizedBox(height: customSpacing.lg),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Change Email Address'),
              ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  void _resendEmail() async {
    setState(() => _isResending = true);
    // TODO: Call API
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isResending = false);
      _startCountdown();
    }
  }

  void _verifyEmail() {
    // TODO: Check if verified via API
    // For now, navigate to home
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}