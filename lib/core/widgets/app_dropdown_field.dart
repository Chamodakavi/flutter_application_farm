import 'package:flutter/material.dart';

import '../l10n/l10n_ext.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import 'dialogs.dart';

/// Label-above picker that opens a (optionally searchable) bottom sheet —
/// easier to use on small phones than a Material dropdown. Used for districts,
/// user types and crops.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.value,
    required this.onChanged,
    this.hint,
    this.required = false,
    this.searchable = false,
    this.enabled = true,
    this.validator,
    this.leadingBuilder,
  });

  final String label;
  final List<T> items;
  final String Function(T item) itemLabel;
  final T? value;
  final ValueChanged<T> onChanged;
  final String? hint;
  final bool required;
  final bool searchable;
  final bool enabled;
  final String? Function(T? value)? validator;
  final Widget Function(T item)? leadingBuilder;

  Future<void> _open(BuildContext context, FormFieldState<T> field) async {
    FocusScope.of(context).unfocus();
    final picked = await showAppBottomSheet<T>(
      context,
      title: label,
      expand: searchable,
      builder: (_) => _PickerList<T>(
        items: items,
        itemLabel: itemLabel,
        selected: value,
        searchable: searchable,
        leadingBuilder: leadingBuilder,
      ),
    );
    if (picked != null) {
      field.didChange(picked);
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (field) {
        final shown = value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                text: label,
                children: [
                  if (required)
                    const TextSpan(text: ' *', style: TextStyle(color: AppColors.red600)),
                ],
              ),
              style: text.labelMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: enabled ? () => _open(context, field) : null,
              borderRadius: AppRadii.inputBorder,
              child: InputDecorator(
                isEmpty: shown == null,
                decoration: InputDecoration(
                  hintText: hint ?? context.l10n.commonSelect,
                  errorText: field.errorText,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
                child: shown == null
                    ? null
                    : Text(
                        itemLabel(shown),
                        style: text.bodyLarge?.copyWith(
                          color: enabled ? AppColors.ink900 : AppColors.ink500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PickerList<T> extends StatefulWidget {
  const _PickerList({
    required this.items,
    required this.itemLabel,
    required this.selected,
    required this.searchable,
    this.leadingBuilder,
  });

  final List<T> items;
  final String Function(T item) itemLabel;
  final T? selected;
  final bool searchable;
  final Widget Function(T item)? leadingBuilder;

  @override
  State<_PickerList<T>> createState() => _PickerListState<T>();
}

class _PickerListState<T> extends State<_PickerList<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim().toLowerCase();
    final items = q.isEmpty
        ? widget.items
        : widget.items.where((i) => widget.itemLabel(i).toLowerCase().contains(q)).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.searchable)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.sm),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: context.l10n.commonSearch,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
          ),
        Flexible(
          child: items.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Text(context.l10n.commonNoResults),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final selected = item == widget.selected;
                    return ListTile(
                      leading: widget.leadingBuilder?.call(item),
                      title: Text(widget.itemLabel(item)),
                      trailing: selected
                          ? const Icon(Icons.check_rounded, color: AppColors.green600)
                          : null,
                      onTap: () => Navigator.of(context).pop(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
