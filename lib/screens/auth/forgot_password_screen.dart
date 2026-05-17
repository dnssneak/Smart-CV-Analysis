import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/snackbar.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_textfield.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(
      _emailController.text.trim(),
    );

    if (success && mounted) {
      setState(() => _emailSent = true);
    } else if (mounted && authProvider.error != null) {
      AppSnackbar.show(context, message: authProvider.error!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.forgotPassword,
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              _emailSent
                  ? 'Check your email for reset instructions.'
                  : 'Enter your email and we will send you a reset link.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.xxxl),

            if (!_emailSent) ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: AppStrings.email,
                      hint: 'name@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppSizes.xxl),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return CustomButton(
                          text: 'Send Reset Link',
                          isLoading: authProvider.isLoading,
                          onPressed: _handleReset,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(AppSizes.xxl),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: theme.colorScheme.primary,
                      size: AppSizes.iconXl,
                    ),
                    const SizedBox(width: AppSizes.lg),
                    Expanded(
                      child: Text(
                        'Reset link sent to ${_emailController.text}',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
              CustomButton(
                text: 'Back to Login',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}