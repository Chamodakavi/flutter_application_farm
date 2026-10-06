import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n/district_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/domain/app_user.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../../profile/presentation/profile_labels.dart';
import '../widgets/auth_scaffold.dart';
import 'controllers/auth_controller.dart';

/// Mandatory gate after the first sign-in: name and phone are required before
/// the home shell opens (spec §11.7). Mirrors web Settings → Account.
class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _phone = TextEditingController();
  String? _type = UserTypes.farmer;
  District? _district;
  bool _busy = false;
  bool _uploadingPhoto = false;
  bool _prefilled = false;
  Object? _error;

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _phone.dispose();
    super.dispose();
  }

  /// Fills the form once from whatever sign-up already provided (Google name,
  /// phone-login number, …).
  void _prefill(AppUser user) {
    if (_prefilled) return;
    _prefilled = true;
    _name.text = user.name ?? '';
    _surname.text = user.surname ?? '';
    final normalized = Validators.normalizePhone(user.phone);
    _phone.text = normalized != null ? normalized.substring(3) : (user.phone ?? '');
    _type = user.userType ?? UserTypes.farmer;
    _district = Districts.byKey(user.district);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final file = await ImagePicker().pickImage(source: source, maxWidth: 1200, imageQuality: 85);
      if (file == null || !mounted) return;
      setState(() => _uploadingPhoto = true);
      await ref.read(profileProvider.notifier).changeAvatar(file.path);
    } catch (e) {
      if (mounted) context.showError(e);
    }
    if (mounted) setState(() => _uploadingPhoto = false);
  }

  void _choosePhoto() {
    final l10n = context.l10n;
    showAppBottomSheet<void>(
      context,
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.profilePhotoGallery),
            onTap: () {
              Navigator.of(sheet).pop();
              _pickPhoto(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.profilePhotoCamera),
            onTap: () {
              Navigator.of(sheet).pop();
              _pickPhoto(ImageSource.camera);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Future<void> _save(AppUser user) async {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      // Read the latest profile so a photo uploaded on this screen is kept.
      final current = ref.read(profileProvider).value ?? user;
      await ref
          .read(profileProvider.notifier)
          .save(
            current.copyWith(
              name: _name.text.trim(),
              surname: _surname.text.trim().isEmpty ? null : _surname.text.trim(),
              phone: Validators.normalizePhone(_phone.text),
              userType: _type,
              district: _district?.key,
            ),
          );
      // Saved: the profile is now complete and the router guard opens Home.
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
    final user = ref.watch(profileProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    _prefill(user);
    final hasEmail = user.email != null && user.email!.isNotEmpty;
    final lang = context.localeTag;

    return AuthScaffold(
      title: l10n.profileCompleteTitle,
      subtitle: l10n.profileCompleteSubtitle,
      footer: TextButton(
        onPressed: _busy ? null : () => ref.read(authControllerProvider).signOut(),
        style: TextButton.styleFrom(foregroundColor: AppColors.ink500),
        child: Text(l10n.authSignOut),
      ),
      children: [
        if (_error != null) ...[
          InfoNote(text: context.errorMessage(_error!), tone: InfoNoteTone.danger),
          const SizedBox(height: AppSpacing.lg),
        ],
        Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AvatarCircle(
                    url: user.avatarUrl,
                    name: _name.text.isNotEmpty ? _name.text : user.email,
                    radius: 40,
                  ),
                  if (_uploadingPhoto) const CircularProgressIndicator(),
                ],
              ),
              TextButton.icon(
                onPressed: _busy || _uploadingPhoto ? null : _choosePhoto,
                icon: const Icon(Icons.photo_camera_outlined, size: 18),
                label: Text(
                  (user.avatarUrl ?? '').isEmpty ? l10n.profileAddPhoto : l10n.profileChangePhoto,
                ),
              ),
            ],
          ),
        ),
        Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: l10n.profileName,
                controller: _name,
                required: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: Validators.required(l10n),
                enabled: !_busy,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: l10n.profileSurname,
                controller: _surname,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                enabled: !_busy,
              ),
              if (hasEmail) ...[
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: l10n.profileEmail,
                  initialValue: user.email,
                  enabled: false,
                  helper: l10n.profileEmailReadOnly,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: l10n.profileTelephone,
                controller: _phone,
                required: true,
                prefixText: '+94',
                hint: '7XXXXXXXX',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: Validators.phone(l10n),
                enabled: !_busy,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppDropdownField<String>(
                label: l10n.profileType,
                hint: l10n.profileSelectType,
                items: UserTypes.all,
                itemLabel: (t) => userTypeLabel(l10n, t),
                value: _type,
                enabled: !_busy,
                onChanged: (v) => setState(() => _type = v),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppDropdownField<District>(
                label: l10n.profileDistrict,
                hint: l10n.profileSelectDistrict,
                items: Districts.all,
                itemLabel: (d) => d.label(lang),
                value: _district,
                searchable: true,
                enabled: !_busy,
                onChanged: (v) => setState(() => _district = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        OnlineOnly(
          builder: (context, online) => PrimaryButton(
            label: l10n.profileSaveContinue,
            onPressed: online ? () => _save(user) : null,
            loading: _busy,
          ),
        ),
      ],
    );
  }
}
