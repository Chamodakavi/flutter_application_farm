import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/google_sign_in_button.dart';
import 'controllers/auth_controller.dart';

/// Email sign-up and Google sign-up (spec §11.5).
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _agreed = false;
  bool _showAgreeError = false;
  bool _busy = false;
  bool _googleBusy = false;
  Object? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool get _alreadyRegistered {
    final e = _error;
    if (e == null) return false;
    final failure = mapError(e);
    return failure is AuthFailure &&
        const {'user_already_exists', 'email_exists'}.contains(failure.code);
  }

  Future<void> _create() async {
    FocusScope.of(context).unfocus();
    final valid = _form.currentState!.validate();
    setState(() => _showAgreeError = !_agreed);
    if (!valid || !_agreed) return;

    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final signedIn = await ref
          .read(authControllerProvider)
          .signUp(name: _name.text, email: _email.text, password: _password.text);
      if (!mounted) return;
      if (!signedIn) {
        // Email confirmation is on: show "Check your email".
        context.go(Routes.checkEmailFor(_email.text.trim()));
      }
      // Otherwise the router guard continues to Complete Profile.
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
    final locked = _busy || _googleBusy;
    final text = Theme.of(context).textTheme;
    return AuthScaffold(
      title: l10n.authCreateTitle,
      showBack: true,
      footer: AuthFooterLink(
        question: l10n.authHaveAccount,
        action: l10n.authSignIn,
        onTap: () => context.go(Routes.login),
      ),
      children: [
        if (_error != null) ...[
          InfoNote(
            text: context.errorMessage(_error!),
            tone: InfoNoteTone.danger,
            actionLabel: _alreadyRegistered ? l10n.authSignInInstead : null,
            onAction: _alreadyRegistered ? () => context.go(Routes.login) : null,
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  label: l10n.authFullName,
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: Validators.required(l10n),
                  enabled: !locked,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: l10n.authEmail,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  validator: Validators.email(l10n),
                  enabled: !locked,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: l10n.authPassword,
                  controller: _password,
                  obscure: true,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  helper: l10n.validationPassword,
                  validator: Validators.password(l10n),
                  enabled: !locked,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: l10n.authConfirmPassword,
                  controller: _confirm,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.confirmPassword(l10n, () => _password.text),
                  enabled: !locked,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: locked
              ? null
              : () => setState(() {
                  _agreed = !_agreed;
                  _showAgreeError = false;
                }),
          child: Row(
            children: [
              Checkbox(
                value: _agreed,
                activeColor: AppColors.green600,
                onChanged: locked
                    ? null
                    : (v) => setState(() {
                        _agreed = v ?? false;
                        _showAgreeError = false;
                      }),
              ),
              Expanded(child: Text(l10n.authAgreeTerms, style: text.bodyMedium)),
            ],
          ),
        ),
        if (_showAgreeError)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.md, bottom: AppSpacing.sm),
            child: Text(
              l10n.authAgreeRequired,
              style: text.bodySmall?.copyWith(color: AppColors.red600),
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        PrimaryButton(
          label: l10n.authCreateAccount,
          onPressed: _googleBusy ? null : _create,
          loading: _busy,
        ),
        OrDivider(label: l10n.commonOr),
        GoogleSignInButton(
          enabled: !_busy,
          onBusyChanged: (v) => setState(() {
            _googleBusy = v;
            if (v) _error = null;
          }),
          onError: (e) => setState(() => _error = e),
        ),
      ],
    );
  }
}
