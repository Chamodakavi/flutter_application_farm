import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/google_sign_in_button.dart';
import 'controllers/auth_controller.dart';

/// Email + password, Google and phone sign-in (spec §11.4).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _googleBusy = false;
  Object? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(authControllerProvider)
          .signInWithPassword(email: _email.text, password: _password.text);
      // Success: the router guard leaves this screen once the profile loads,
      // so the spinner stays on until then.
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
    return AuthScaffold(
      title: l10n.authWelcomeBack,
      footer: AuthFooterLink(
        question: l10n.authNewHere,
        action: l10n.authCreateAccount,
        onTap: () => context.push(Routes.signup),
      ),
      children: [
        if (_error != null) ...[
          // TC_AUTH_02: localized "Invalid login credentials" banner.
          InfoNote(text: context.errorMessage(_error!), tone: InfoNoteTone.danger),
          const SizedBox(height: AppSpacing.lg),
        ],
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.required(l10n),
                  enabled: !locked,
                  onSubmitted: (_) => _signIn(),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: locked ? null : () => context.push(Routes.forgot),
            child: Text(l10n.authForgot),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        PrimaryButton(
          label: l10n.authSignIn,
          onPressed: _googleBusy ? null : _signIn,
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
        const SizedBox(height: AppSpacing.md),
        SecondaryButton(
          label: l10n.authPhone,
          icon: Icons.phone_iphone_rounded,
          onPressed: locked ? null : () => context.push(Routes.phoneLogin),
        ),
      ],
    );
  }
}
