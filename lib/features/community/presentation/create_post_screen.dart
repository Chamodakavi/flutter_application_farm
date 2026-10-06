import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/constants.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../domain/post.dart';
import '../domain/post_activity.dart';
import 'controllers/feed_controller.dart';
import 'controllers/post_controller.dart';
import 'widgets/activity_chip.dart';

/// Create a post — text, optional photo and activity tag (spec §11.20) — or,
/// with [editPostId], change the text of an existing own post.
class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key, this.editPostId});

  final int? editPostId;

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _text = TextEditingController();
  final _picker = ImagePicker();

  PostActivity? _activity;
  String? _imagePath;
  bool _submitting = false;

  /// Edit mode: the post's text has been copied into the field.
  bool _prefilled = false;

  bool get _editing => widget.editPostId != null;

  @override
  void initState() {
    super.initState();
    _text.addListener(_onTextChanged);
    final id = widget.editPostId;
    if (id != null) {
      ref.listenManual(postByIdProvider(id), (_, post) => _prefill(post), fireImmediately: true);
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  /// Splits the stored content back into activity tag and text, once.
  void _prefill(Post? post) {
    if (post == null || _prefilled) return;
    _prefilled = true;
    final tagged = ActivityTag.parse(post.content);
    _activity = tagged.activity;
    _text.text = tagged.text;
  }

  /// What gets stored: the text with the activity tag in front.
  String get _content => ActivityTag.apply(_activity, _text.text);

  bool get _canSubmit =>
      !_submitting && _text.text.trim().isNotEmpty && _content.length <= AppConst.maxPostLength;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source);
      if (file != null && mounted) setState(() => _imagePath = file.path);
    } catch (_) {
      // Permission denied or no camera.
      if (mounted) context.showSnack(context.l10n.postPhotoFailed);
    }
  }

  Future<void> _chooseActivity() async {
    final choice = await showAppBottomSheet<_ActivityChoice>(
      context,
      title: context.l10n.communityActivityChoose,
      builder: (_) => _ActivitySheet(selected: _activity),
    );
    if (choice != null && mounted) setState(() => _activity = choice.activity);
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    final l10n = context.l10n;
    final actions = ref.read(postActionsProvider);
    final content = _content;
    final editId = widget.editPostId;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      if (editId != null) {
        await actions.edit(editId, content);
      } else {
        await actions.create(content: content, imagePath: _imagePath);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitting = false);
        context.showError(e);
      }
      return;
    }
    if (!mounted) return;
    context.showSnack(editId != null ? l10n.postUpdated : l10n.postPublished);
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.community);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editId = widget.editPostId;

    Widget body;
    if (editId == null) {
      body = _form(context, null);
    } else {
      final post = ref.watch(postByIdProvider(editId));
      final load = ref.watch(postLoadProvider(editId));
      final me = ref.watch(currentUserIdProvider);
      if (post == null) {
        body = load.hasError
            ? ErrorState(error: load.error, onRetry: () => ref.invalidate(postLoadProvider(editId)))
            : const ShimmerList(itemCount: 2, itemHeight: 160);
      } else if (post.userId != me) {
        body = ErrorState(message: l10n.postNotYours);
      } else {
        body = _form(context, post);
      }
    }

    return AppScaffold(title: _editing ? l10n.postEditTitle : l10n.postCreateTitle, body: body);
  }

  Widget _form(BuildContext context, Post? editing) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final profile = ref.watch(profileProvider).value;
    final name = profile?.displayName.isNotEmpty == true ? profile!.displayName : profile?.email;
    final prefix = ActivityTag.prefixLength(_activity);
    final imagePath = _imagePath;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: AppSpacing.page,
            child: SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      AvatarCircle(url: profile?.avatarUrl, name: name),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          profile?.displayName.isNotEmpty == true
                              ? profile!.displayName
                              : l10n.communityFarmer,
                          style: text.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_activity != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InputChip(
                        label: Text('${_activity!.emoji} ${activityLabel(l10n, _activity!)}'),
                        onDeleted: _submitting ? null : () => setState(() => _activity = null),
                        deleteButtonTooltipMessage: l10n.communityActivityNone,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _text,
                    enabled: !_submitting,
                    autofocus: editing == null,
                    minLines: 5,
                    maxLines: 12,
                    // The tag is stored in the same column, so it counts.
                    maxLength: AppConst.maxPostLength - prefix,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: text.bodyLarge,
                    decoration: InputDecoration(hintText: l10n.communityWhatsOnMind),
                    buildCounter:
                        (_, {required currentLength, required isFocused, required maxLength}) =>
                            Text(
                              '${currentLength + prefix}/${AppConst.maxPostLength}',
                              style: text.bodySmall,
                            ),
                  ),
                  if (imagePath != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    _PhotoPreview(
                      path: imagePath,
                      onRemove: _submitting ? null : () => setState(() => _imagePath = null),
                    ),
                  ],
                  if (editing != null && editing.hasImage) ...[
                    const SizedBox(height: AppSpacing.md),
                    NetworkImageBox(
                      url: editing.image,
                      aspectRatio: 4 / 3,
                      borderRadius: AppRadii.inputBorder,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    InfoNote(text: l10n.postEditPhotoNote),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      if (editing == null) ...[
                        _ToolButton(
                          icon: Icons.photo_library_outlined,
                          label: l10n.postGallery,
                          onTap: _submitting ? null : () => _pickImage(ImageSource.gallery),
                        ),
                        _ToolButton(
                          icon: Icons.photo_camera_outlined,
                          label: l10n.postCamera,
                          onTap: _submitting ? null : () => _pickImage(ImageSource.camera),
                        ),
                      ],
                      _ToolButton(
                        icon: Icons.emoji_nature_outlined,
                        label: l10n.communityActivity,
                        onTap: _submitting ? null : _chooseActivity,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // In the body (not the scaffold's bottom bar) so it stays above the
        // keyboard.
        Material(
          color: AppColors.white,
          elevation: 8,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: OnlineOnly(
                builder: (context, online) => PrimaryButton(
                  label: editing != null ? l10n.commonSave : l10n.communityPost,
                  icon: editing != null ? Icons.check_rounded : Icons.send_rounded,
                  loading: _submitting,
                  onPressed: online && _canSubmit ? _submit : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Result of the activity sheet; a null [activity] means "No activity".
class _ActivityChoice {
  const _ActivityChoice(this.activity);

  final PostActivity? activity;
}

class _ActivitySheet extends StatelessWidget {
  const _ActivitySheet({required this.selected});

  final PostActivity? selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget option(PostActivity? activity) => ListTile(
      leading: SizedBox(
        width: 32,
        child: Center(
          child: activity == null
              ? const Icon(Icons.block_rounded, color: AppColors.ink500)
              : Text(activity.emoji, style: const TextStyle(fontSize: 24, height: 1.1)),
        ),
      ),
      title: Text(activity == null ? l10n.communityActivityNone : activityLabel(l10n, activity)),
      trailing: activity == selected
          ? const Icon(Icons.check_rounded, color: AppColors.green600)
          : null,
      onTap: () => Navigator.of(context).pop(_ActivityChoice(activity)),
    );

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      children: [for (final activity in PostActivity.values) option(activity), option(null)],
    );
  }
}

/// Local photo with a remove button.
class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({required this.path, required this.onRemove});

  final String path;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadii.inputBorder,
    child: Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const LeafPlaceholder(),
          ),
        ),
        Positioned(
          top: AppSpacing.xs,
          right: AppSpacing.xs,
          child: IconButton.filled(
            tooltip: context.l10n.postRemovePhoto,
            onPressed: onRemove,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.ink900.withValues(alpha: 0.6),
              foregroundColor: AppColors.white,
            ),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
      ],
    ),
  );
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onTap,
    style: TextButton.styleFrom(
      foregroundColor: AppColors.forest900,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      textStyle: Theme.of(context).textTheme.labelMedium,
    ),
    icon: Icon(icon, size: 20, color: onTap == null ? null : AppColors.green600),
    label: Text(label),
  );
}
