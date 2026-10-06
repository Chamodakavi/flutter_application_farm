import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/auth_scaffold.dart';
import 'controllers/auth_controller.dart';

/// Opened by the password-recovery deep link: new password + confirm, then
/// back to Login (spec §11.6).
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    try {
      await ref.read(authControllerProvider).completePasswordReset(_password.text);
      messenger.showSnackBar(SnackBar(content: Text(l10n.authPasswordUpdated)));
      router.go(Routes.login);
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = e;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Without the recovery session from the email link there is nothing to
    // update — explain instead of showing a form that would fail.
    final hasSession = ref.watch(currentUserIdProvider) != null;

    return AuthScaffold(
      title: l10n.authResetTitle,
      children: !hasSession
          ? [
              InfoNote(text: l10n.authResetNeedsLink),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: l10n.authBackToLogin,
                onPressed: () => context.go(Routes.login),
              ),
            ]
          : [
              if (_error != null) ...[
                InfoNote(text: context.errorMessage(_error!), tone: InfoNoteTone.danger),
                const SizedBox(height: AppSpacing.lg),
              ],
              Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: l10n.authNewPassword,
                      controller: _password,
                      obscure: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      helper: l10n.validationPassword,
                      validator: Validators.password(l10n),
                      enabled: !_busy,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.authConfirmPassword,
                      controller: _confirm,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      validator: Validators.confirmPassword(l10n, () => _password.text),
                      enabled: !_busy,
                      onSubmitted: (_) => _save(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: l10n.authSavePassword, onPressed: _save, loading: _busy),
            ],
    );
  }
}
