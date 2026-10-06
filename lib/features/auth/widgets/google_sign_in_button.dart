import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/auth_repository.dart';
import '../presentation/controllers/auth_controller.dart';

/// "Continue with Google" — the same widget and the same call on Login and
/// Sign up; Supabase creates the account on first sign-in (spec §11.5).
class GoogleSignInButton extends ConsumerStatefulWidget {
  const GoogleSignInButton({
    super.key,
    this.enabled = true,
    this.onBusyChanged,
    required this.onError,
  });

  /// False while another button on the screen is working.
  final bool enabled;
  final ValueChanged<bool>? onBusyChanged;
  final ValueChanged<Object> onError;

  @override
  ConsumerState<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton> {
  bool _busy = false;

  void _setBusy(bool value) {
    if (!mounted) return;
    setState(() => _busy = value);
    widget.onBusyChanged?.call(value);
  }

  Future<void> _signIn() async {
    _setBusy(true);
    try {
      await ref.read(authControllerProvider).signInWithGoogle();
      // Signed in: the router guard takes over once the profile loads.
    } on SignInCancelled {
      // The user closed the account picker — not an error.
    } catch (e) {
      widget.onError(e);
    }
    _setBusy(false);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.enabled && !_busy ? _signIn : null,
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.ink900,
        side: const BorderSide(color: AppColors.line200),
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(borderRadius: AppRadii.buttonBorder),
      ),
      child: _busy
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const _GoogleMark(),
                const SizedBox(width: AppSpacing.md),
                Flexible(
                  child: Text(
                    context.l10n.authGoogle,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
    );
  }
}

/// The four-colour "G", drawn so no image asset is needed.
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) => ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (rect) => const SweepGradient(
      startAngle: 0,
      endAngle: 6.283,
      colors: [
        Color(0xFF4285F4),
        Color(0xFF34A853),
        Color(0xFFFBBC05),
        Color(0xFFEA4335),
        Color(0xFF4285F4),
      ],
      stops: [0.0, 0.3, 0.55, 0.8, 1.0],
    ).createShader(rect),
    child: const Text(
      'G',
      style: TextStyle(fontFamily: 'NotoSans', fontSize: 22, fontWeight: FontWeight.w700, height: 1),
    ),
  );
}
