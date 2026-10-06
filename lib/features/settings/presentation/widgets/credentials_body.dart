import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/data/auth_repository.dart';
import '../controllers/credentials_controller.dart';

/// Settings → Credentials (spec §11.26, §8.9). What it offers depends on how
/// the account signs in:
///
/// * has a password → change it (current → new → confirm);
/// * Google only → "You signed in with Google" + set a password;
/// * phone → "Signed in with phone +94…" + optional email & password.
///
/// Not scrollable by itself.
class CredentialsBody extends ConsumerWidget {
  const CredentialsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final info = ref.watch(credentialsInfoProvider);

    final _PasswordMode mode;
    if (info.hasPassword) {
      mode = _PasswordMode.change;
    } else if (info.isPhone && info.email == null) {
      mode = _PasswordMode.addEmail;
    } else {
      mode = _PasswordMode.set;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (info.isPhone) ...[
          InfoNote(
            icon: Icons.smartphone_rounded,
            text: l10n.settingsPhoneAccount(info.phone ?? '+94'),
          ),
          AppSpacing.gapLg,
        ] else if (info.isGoogle && !info.hasPassword) ...[
          InfoNote(
            icon: Icons.account_circle_outlined,
            text: '${l10n.settingsGoogleAccount}\n${l10n.settingsGoogleAccountHint}',
          ),
          AppSpacing.gapLg,
        ],
        // Keyed by mode: the fields reset when the account gains a password.
        _PasswordForm(key: ValueKey(mode), mode: mode),
      ],
    );
  }
}

enum _PasswordMode { change, set, addEmail }

class _PasswordForm extends ConsumerStatefulWidget {
  const _PasswordForm({super.key, required this.mode});

  final _PasswordMode mode;

  @override
  ConsumerState<_PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends ConsumerState<_PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _saving = false;

  /// Success text shown above the form after "set password" / "add email".
  String? _done;

  @override
  void dispose() {
    _email.dispose();
    _current.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = context.l10n;
    final auth = ref.read(authRepositoryProvider);
    setState(() => _saving = true);
    try {
      final String message;
      switch (widget.mode) {
        case _PasswordMode.change:
          await auth.changePassword(current: _current.text, newPassword: _password.text);
          message = l10n.settingsPasswordUpdated;
        case _PasswordMode.set:
          await auth.setEmailAndPassword(password: _password.text);
          message = l10n.settingsPasswordSet;
        case _PasswordMode.addEmail:
          await auth.setEmailAndPassword(email: _email.text, password: _password.text);
          message = l10n.settingsEmailPasswordAdded;
      }
      if (!mounted) return;
      _formKey.currentState?.reset();
      for (final c in [_email, _current, _password, _confirm]) {
        c.clear();
      }
      setState(() => _done = widget.mode == _PasswordMode.change ? null : message);
      context.showSnack(message);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mode = widget.mode;
    final (String title, String? subtitle, String action) = switch (mode) {
      _PasswordMode.change => (l10n.settingsChangePassword, null, l10n.settingsUpdatePassword),
      _PasswordMode.set => (l10n.settingsSetPassword, null, l10n.settingsSetPassword),
      _PasswordMode.addEmail => (
        l10n.settingsAddEmailPassword,
        l10n.settingsAddEmailHint,
        l10n.settingsAddEmailPassword,
      ),
    };

    return SectionCard(
      title: title,
      subtitle: subtitle,
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_done != null) ...[
                InfoNote(text: _done!, tone: InfoNoteTone.success),
                AppSpacing.gapLg,
              ],
              if (mode == _PasswordMode.addEmail) ...[
                AppTextField(
                  label: l10n.settingsEmail,
                  controller: _email,
                  required: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email(l10n),
                ),
                AppSpacing.gapLg,
              ],
              if (mode == _PasswordMode.change) ...[
                AppTextField(
                  label: l10n.settingsCurrentPassword,
                  controller: _current,
                  required: true,
                  obscure: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.required(l10n),
                ),
                AppSpacing.gapLg,
              ],
              AppTextField(
                label: l10n.settingsNewPassword,
                controller: _password,
                required: true,
                obscure: true,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.newPassword],
                validator: Validators.password(l10n),
              ),
              AppSpacing.gapLg,
              AppTextField(
                label: l10n.settingsConfirmPassword,
                controller: _confirm,
                required: true,
                obscure: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.newPassword],
                validator: Validators.confirmPassword(l10n, () => _password.text),
              ),
              AppSpacing.gapXl,
              OnlineOnly(
                builder: (_, online) => PrimaryButton(
                  label: action,
                  icon: Icons.lock_reset_rounded,
                  loading: _saving,
                  onPressed: online ? _submit : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
