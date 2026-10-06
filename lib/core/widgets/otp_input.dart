import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

/// Six single-digit boxes backed by one invisible text field, so paste and
/// the platform's SMS one-time-code autofill (Android and iOS) both work.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.enabled = true,
    this.autofocus = true,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final bool enabled;
  final bool autofocus;

  @override
  State<OtpInput> createState() => OtpInputState();
}

class OtpInputState extends State<OtpInput> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _shake.dispose();
    super.dispose();
  }

  /// Clears the boxes and shakes them — call after a wrong code.
  void rejectAndClear() {
    _controller.clear();
    widget.onChanged('');
    _shake.forward(from: 0);
    _focus.requestFocus();
    setState(() {});
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;
    final text = Theme.of(context).textTheme;
    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        // Damped left-right wobble.
        final t = _shake.value;
        final dx = t == 0 ? 0.0 : 10 * (1 - t) * (((t * 8).floor() % 2 == 0) ? 1 : -1);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? _focus.requestFocus : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.length; i++)
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 52),
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.fieldFill,
                        borderRadius: AppRadii.inputBorder,
                        border: Border.all(
                          width: 2,
                          color: widget.hasError
                              ? AppColors.red600
                              : (_focus.hasFocus && i == code.length.clamp(0, widget.length - 1))
                              ? AppColors.green600
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        i < code.length ? code[i] : '',
                        style: text.titleLarge,
                      ),
                    ),
                  ),
              ],
            ),
            // Invisible field on top: receives typing, paste and SMS autofill.
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: AutofillGroup(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: widget.autofocus,
                    enabled: widget.enabled,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    enableInteractiveSelection: false,
                    showCursor: false,
                    maxLength: widget.length,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(counterText: ''),
                    onChanged: _onChanged,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
