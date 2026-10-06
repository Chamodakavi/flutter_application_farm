import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../widgets/auth_scaffold.dart';
import 'controllers/auth_controller.dart';

/// UI-side limit on SMS resends: at most 3 per 10 minutes per number
/// (spec §8.9). The server enforces its own rate limit as well.
class OtpResendLimiter {
  OtpResendLimiter({this.max = 3, this.window = const Duration(minutes: 10)});

  final int max;
  final Duration window;
  final _sent = <String, List<DateTime>>{};

  bool canResend(String phone, [DateTime? now]) {
    final t = now ?? DateTime.now();
    final recent = (_sent[phone] ?? const <DateTime>[])
        .where((d) => t.difference(d) < window)
        .toList();
    _sent[phone] = recent;
    return recent.length < max;
  }

  void record(String phone, [DateTime? now]) =>
      (_sent[phone] ??= []).add(now ?? DateTime.now());
}

final _resendLimiter = OtpResendLimiter();

/// Phone sign-in, step 2: six-box code entry with SMS autofill, a 60 s resend
/// countdown and "Change number" (spec §8.9, §11.32).
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phoneDigits});

  /// The 9 digits after `+94`.
  final String phoneDigits;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _resendAfter = 60;

  final _otpKey = GlobalKey<OtpInputState>();
  String _code = '';
  bool _busy = false;
  bool _resending = false;
  Object? _error;
  int _secondsLeft = _resendAfter;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendAfter);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) timer.cancel();
    });
  }

  Future<void> _verify([String? code]) async {
    final value = code ?? _code;
    if (value.length != 6 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider).verifyOtp(digits: widget.phoneDigits, code: value);
      // Signed in: the router guard continues to Complete Profile or Home.
    } catch (e) {
      if (!mounted) return;
      final failure = mapError(e);
      // Any OTP rejection that is not an expiry reads as "wrong code".
      final wrongCode =
          failure is AuthFailure &&
          !const {'otp_expired', 'over_request_rate_limit', 'over_sms_send_rate_limit'}
              .contains(failure.code);
      setState(() {
        _busy = false;
        _error = wrongCode ? const AppException.auth('invalid_otp') : failure;
      });
      _otpKey.currentState?.rejectAndClear();
    }
  }

  Future<void> _resend() async {
    if (!_resendLimiter.canResend(widget.phoneDigits)) {
      setState(() => _error = const AppException.auth('over_sms_send_rate_limit'));
      return;
    }
    setState(() {
      _resending = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider).sendOtp(widget.phoneDigits);
      _resendLimiter.record(widget.phoneDigits);
      if (!mounted) return;
      context.showSnack(context.l10n.authCodeSent);
      _startCountdown();
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
    if (mounted) setState(() => _resending = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canResend = _secondsLeft <= 0 && !_resending && !_busy;
    return AuthScaffold(
      title: l10n.authOtpTitle,
      subtitle: l10n.authOtpBody('+94 ${widget.phoneDigits}'),
      showBack: true,
      children: [
        OtpInput(
          key: _otpKey,
          hasError: _error != null,
          enabled: !_busy,
          onChanged: (v) => setState(() {
            _code = v;
            if (v.isNotEmpty) _error = null;
          }),
          onCompleted: _verify,
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            context.errorMessage(_error!),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.red600),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          label: l10n.authVerify,
          onPressed: _code.length == 6 ? _verify : null,
          loading: _busy,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: canResend ? _resend : null,
          child: Text(
            _secondsLeft > 0 ? l10n.authResendIn(_secondsLeft) : l10n.authResend,
            textAlign: TextAlign.center,
          ),
        ),
        TextButton(
          onPressed: _busy
              ? null
              : () => context.canPop() ? context.pop() : context.go(Routes.phoneLogin),
          style: TextButton.styleFrom(foregroundColor: AppColors.ink500),
          child: Text(l10n.authChangeNumber),
        ),
      ],
    );
  }
}
