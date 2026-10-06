import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/auth_scaffold.dart';
import 'controllers/auth_controller.dart';

/// Phone sign-in, step 1: fixed `+94` prefix and a 9-digit mobile number
/// (spec §8.9). Many farmers have no email, so this is a first-class option.
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _form = GlobalKey<FormState>();
  final _digits = TextEditingController();
  bool _busy = false;
  Object? _error;

  @override
  void dispose() {
    _digits.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    final digits = _digits.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider).sendOtp(digits);
      if (mounted) await context.push(Routes.otpFor(digits));
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthScaffold(
      title: l10n.authPhoneTitle,
      subtitle: l10n.authPhoneBody,
      showBack: true,
      children: [
        if (_error != null) ...[
          InfoNote(text: context.errorMessage(_error!), tone: InfoNoteTone.danger),
          const SizedBox(height: AppSpacing.lg),
        ],
        Form(
          key: _form,
          child: AppTextField(
            label: l10n.authPhoneNumber,
            controller: _digits,
            prefixText: '+94',
            hint: '7XXXXXXXX',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            maxLength: 9,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofillHints: const [AutofillHints.telephoneNumberNational],
            validator: Validators.mobileDigits(l10n),
            enabled: !_busy,
            onSubmitted: (_) => _send(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OnlineOnly(
          builder: (context, online) => PrimaryButton(
            label: l10n.authSendCode,
            icon: Icons.sms_outlined,
            onPressed: online ? _send : null,
            loading: _busy,
          ),
        ),
      ],
    );
  }
}
