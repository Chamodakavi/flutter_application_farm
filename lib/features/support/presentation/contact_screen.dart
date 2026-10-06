import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n_ext.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../domain/complaint.dart';
import 'controllers/complaints_controller.dart';
import 'widgets/complaint_tile.dart';

/// Contact Support (spec §11.23): send a message to the admins and follow the
/// replies under "My Sent Messages".
class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key, this.initialSubject});

  /// Pre-fills Subject (`/support?subject=…`).
  final String? initialSubject;

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  static const _maxSubject = 150;
  static const _maxBody = 2000;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subject = TextEditingController(
    text: widget.initialSubject?.trim() ?? '',
  );
  final _body = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final l10n = context.l10n;
    setState(() => _sending = true);
    try {
      await ref.read(complaintsProvider.notifier).send(subject: _subject.text, body: _body.text);
      if (!mounted) return;
      _subject.clear();
      _body.clear();
      context.showSnack(l10n.supportSent);
    } catch (e) {
      if (mounted) context.showError(e);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _refresh() async {
    try {
      await ref.read(complaintsProvider.notifier).refresh();
    } catch (_) {
      // The card shows the error with Retry.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final complaints = ref.watch(complaintsProvider);
    final count = complaints.value?.length;

    String? required(String? value, int max) =>
        Validators.required(l10n)(value) ?? Validators.maxLength(l10n, max)(value?.trim());

    return AppScaffold(
      title: l10n.supportTitle,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: AppSpacing.page,
          children: [
            SectionCard(
              title: l10n.supportNewTitle,
              subtitle: l10n.supportNewSubtitle,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                      label: l10n.supportSubject,
                      hint: l10n.supportSubjectHint,
                      controller: _subject,
                      required: true,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => required(v, _maxSubject),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.supportDescription,
                      hint: l10n.supportDescriptionHint,
                      controller: _body,
                      required: true,
                      minLines: 4,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) => required(v, _maxBody),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OnlineOnly(
                      builder: (context, online) => PrimaryButton(
                        label: l10n.supportSend,
                        icon: Icons.send_rounded,
                        loading: _sending,
                        onPressed: online ? _submit : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SectionCard(
              title: l10n.supportMineTitle,
              trailing: count == null ? null : TagChip(l10n.recordsCount(count)),
              child: AsyncValueView<List<Complaint>>(
                value: complaints,
                compact: true,
                loading: const ShimmerList(
                  itemCount: 3,
                  itemHeight: 72,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                ),
                onRetry: () => ref.invalidate(complaintsProvider),
                empty: EmptyState(
                  compact: true,
                  icon: Icons.mark_email_read_outlined,
                  title: l10n.supportEmpty,
                ),
                data: (items) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (index, complaint) in items.indexed) ...[
                      if (index > 0) const Divider(height: 1),
                      ComplaintTile(
                        complaint: complaint,
                        onTap: () => context.push(Routes.complaint(complaint.id)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
