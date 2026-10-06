import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Text field with the label above it, like the web forms (spec §10.4).
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.errorText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.prefixText,
    this.prefixIcon,
    this.suffix,
    this.obscure = false,
    this.required = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  }) : _numeric = false,
       _decimal = false;

  /// Numeric keypad for whole numbers.
  const AppTextField.number({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.errorText,
    this.validator,
    this.textInputAction,
    this.prefixText,
    this.prefixIcon,
    this.suffix,
    this.required = false,
    this.enabled = true,
    this.maxLength,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    bool decimal = false,
  }) : keyboardType = decimal
           ? const TextInputType.numberWithOptions(decimal: true)
           : TextInputType.number,
       inputFormatters = null,
       _decimal = decimal,
       _numeric = true,
       obscure = false,
       readOnly = false,
       maxLines = 1,
       minLines = null,
       autofillHints = null,
       textCapitalization = TextCapitalization.none,
       onTap = null;

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? helper;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final IconData? prefixIcon;
  final Widget? suffix;

  /// Password field with a show/hide toggle.
  final bool obscure;

  /// Adds a red asterisk after the label.
  final bool required;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  // Set only by the `.number` constructor.
  final bool _numeric;
  final bool _decimal;

  static final _digits = FilteringTextInputFormatter.digitsOnly;
  static final _decimals = FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'));

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final formatters =
        widget.inputFormatters ??
        (widget._numeric
            ? [widget._decimal ? AppTextField._decimals : AppTextField._digits]
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: widget.label,
            children: [
              if (widget.required)
                const TextSpan(text: ' *', style: TextStyle(color: AppColors.red600)),
            ],
          ),
          style: text.labelMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          focusNode: widget.focusNode,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: formatters,
          obscureText: _hidden,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.obscure ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          autofillHints: widget.autofillHints,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: text.bodyLarge?.copyWith(
            color: widget.enabled ? AppColors.ink900 : AppColors.ink500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helper,
            errorText: widget.errorText,
            prefixText: widget.prefixText == null ? null : '${widget.prefixText} ',
            prefixStyle: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon, size: 20),
            suffixIcon: widget.obscure
                ? IconButton(
                    onPressed: () => setState(() => _hidden = !_hidden),
                    icon: Icon(
                      _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                  )
                : widget.suffix,
          ),
        ),
      ],
    );
  }
}
