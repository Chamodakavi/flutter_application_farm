import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/l10n/district_labels.dart';
import '../../../../core/l10n/l10n_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../profile/domain/app_user.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import 'settings_actions.dart';

/// The word the user types to confirm account deletion (spec §8.8). Kept in
/// Latin capitals in every language.
const kDeleteConfirmWord = 'DELETE';

/// Settings → Account (spec §11.26): profile form, avatar and the danger
/// zone. Not scrollable by itself — the Settings tab and the
/// `/settings/account` route both place it inside their own scroll view.
class AccountSettingsBody extends ConsumerWidget {
  const AccountSettingsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView<AppUser?>(
      value: ref.watch(profileProvider),
      compact: true,
      onRetry: () => ref.invalidate(profileProvider),
      data: (profile) => profile == null
          ? ErrorState(message: context.l10n.errorSessionExpired, compact: true)
          // Keyed by account so the fields are filled once per user and are
          // not reset while typing when the profile reloads.
          : _AccountForm(key: ValueKey(profile.id), profile: profile),
    );
  }
}

class _AccountForm extends ConsumerStatefulWidget {
  const _AccountForm({super.key, required this.profile});

  /// Latest profile from the provider (the avatar follows it).
  final AppUser profile;

  @override
  ConsumerState<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<_AccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.name ?? '');
  late final _surname = TextEditingController(text: widget.profile.surname ?? '');
  late final _phone = TextEditingController(text: _localDigits(widget.profile.phone));
  late String? _type = knownUserType(widget.profile.userType) ?? _blankToNull(widget.profile.userType);
  late District? _district = Districts.byKey(widget.profile.district);

  bool _saving = false;
  bool _uploading = false;
  bool _deleting = false;

  static String? _blankToNull(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();

  /// The part typed after the fixed `+94` prefix. Numbers saved in another
  /// format (web) are shown as their digits so the user can correct them.
  static String _localDigits(String? stored) {
    final normalized = Validators.normalizePhone(stored);
    if (normalized != null) return normalized.substring(3);
    return (stored ?? '').replaceAll(RegExp(r'\D'), '');
  }

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = context.l10n;
    final base = ref.read(profileProvider).value ?? widget.profile;
    setState(() => _saving = true);
    try {
      await ref.read(profileProvider.notifier).save(
        base.copyWith(
          name: _name.text.trim(),
          surname: _blankToNull(_surname.text),
          phone: Validators.normalizePhone(_phone.text),
          userType: _type,
          // An unknown stored district is kept until the user picks another.
          district: _district?.key ?? base.district,
        ),
      );
      if (!mounted) return;
      // Show what was stored (e.g. 0771234567 → 771234567 after +94).
      _name.text = _name.text.trim();
      _phone.text = _localDigits(ref.read(profileProvider).value?.phone ?? _phone.text);
      context.showSnack(l10n.settingsProfileUpdated);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _changePhoto() async {
    final l10n = context.l10n;
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      setState(() => _uploading = true);
      await ref.read(profileProvider.notifier).changeAvatar(picked.path);
      if (mounted) context.showSnack(l10n.settingsPhotoUpdated);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _DeleteAccountDialog(),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      // On success the session ends and the router returns to Login.
      await ref.read(authControllerProvider).deleteAccount();
    } catch (e) {
      if (!mounted) return;
      context.showError(e);
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final profile = widget.profile;
    final locale = context.localeTag;
    final busy = _saving || _uploading || _deleting;
    // A type set on the web that the app does not list stays selectable.
    final types = [...UserTypes.all, if (_type != null && !UserTypes.all.contains(_type)) _type!];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AvatarCircle(
                        url: profile.avatarUrl,
                        name: profile.displayName.isNotEmpty ? profile.displayName : profile.email,
                        radius: 44,
                      ),
                      if (_uploading) const CircularProgressIndicator(),
                    ],
                  ),
                ),
                Center(
                  child: OnlineOnly(
                    builder: (_, online) => TextButton.icon(
                      onPressed: online && !busy ? _changePhoto : null,
                      icon: const Icon(Icons.photo_camera_outlined, size: 20),
                      label: Text(l10n.settingsChangePhoto),
                    ),
                  ),
                ),
                AppSpacing.gapSm,
                AppTextField(
                  label: l10n.settingsName,
                  controller: _name,
                  required: true,
                  validator: Validators.required(l10n),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.givenName],
                ),
                AppSpacing.gapLg,
                AppTextField(
                  label: l10n.settingsSurname,
                  controller: _surname,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.familyName],
                ),
                AppSpacing.gapLg,
                AppTextField(
                  // Rebuilt if the address changes (email added in Credentials).
                  key: ValueKey(profile.email),
                  label: l10n.settingsEmail,
                  initialValue: profile.email ?? '',
                  enabled: false,
                  helper: l10n.settingsEmailLocked,
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                AppSpacing.gapLg,
                AppTextField.number(
                  label: l10n.settingsPhone,
                  controller: _phone,
                  required: true,
                  prefixText: '+94',
                  hint: '7XXXXXXXX',
                  validator: Validators.phone(l10n),
                  textInputAction: TextInputAction.done,
                ),
                AppSpacing.gapLg,
                AppDropdownField<String>(
                  label: l10n.settingsType,
                  hint: l10n.settingsTypeHint,
                  items: types,
                  itemLabel: (t) => userTypeLabel(l10n, t),
                  value: _type,
                  onChanged: (v) => setState(() => _type = v),
                ),
                AppSpacing.gapLg,
                AppDropdownField<District>(
                  label: l10n.settingsDistrict,
                  hint: l10n.settingsDistrictHint,
                  items: Districts.all,
                  itemLabel: (d) => d.label(locale),
                  value: _district,
                  searchable: true,
                  onChanged: (v) => setState(() => _district = v),
                ),
                AppSpacing.gapXl,
                OnlineOnly(
                  builder: (_, online) => PrimaryButton(
                    label: l10n.settingsUpdateProfile,
                    icon: Icons.check_rounded,
                    loading: _saving,
                    onPressed: online && !busy ? _save : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapLg,
        SectionCard(
          title: l10n.settingsDangerZone,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.settingsDeleteAccountInfo,
                style: text.bodyMedium?.copyWith(color: AppColors.ink500),
              ),
              AppSpacing.gapMd,
              OnlineOnly(
                builder: (_, online) => DangerButton(
                  label: l10n.settingsDeleteAccount,
                  icon: Icons.delete_forever_outlined,
                  outlined: true,
                  loading: _deleting,
                  onPressed: online && !busy ? _deleteAccount : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Asks the user to type [kDeleteConfirmWord] before the delete button
/// becomes active (store requirement, spec §8.8).
class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _input = TextEditingController();

  bool get _matches => _input.text.trim().toUpperCase() == kDeleteConfirmWord;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      scrollable: true,
      title: Text(l10n.settingsDeleteConfirmTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.settingsDeleteConfirmMessage(kDeleteConfirmWord)),
          AppSpacing.gapMd,
          TextField(
            controller: _input,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(hintText: kDeleteConfirmWord),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(foregroundColor: AppColors.ink500),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: _matches ? () => Navigator.of(context).pop(true) : null,
          style: TextButton.styleFrom(foregroundColor: AppColors.red600),
          child: Text(l10n.settingsDeleteAccount),
        ),
      ],
    );
  }
}
