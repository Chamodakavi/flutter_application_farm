import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/auth_scaffold.dart';
import 'controllers/auth_controller.dart';

/// Sends the password-reset link (spec §11.6). The link opens the app on the
/// Reset screen through the `reset-password` deep link.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;
  Object? _error;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider).sendPasswordReset(_email.text);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScaffold(
      title: l10n.authForgotTitle,
      subtitle: _sent ? null : l10n.authForgotBody,
      showBack: true,
      children: _sent
          ? [
              InfoNote(
                text: l10n.authResetSent(_email.text.trim()),
                tone: InfoNoteTone.success,
                icon: Icons.mark_email_read_outlined,
              ),
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
                child: AppTextField(
                  label: l10n.authEmail,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email(l10n),
                  enabled: !_busy,
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              OnlineOnly(
                builder: (context, online) => PrimaryButton(
                  label: l10n.authSendResetLink,
                  onPressed: online ? _send : null,
                  loading: _busy,
                ),
              ),
            ],
    );
  }
}
