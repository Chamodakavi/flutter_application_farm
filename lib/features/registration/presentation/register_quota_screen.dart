import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/constants.dart';
import '../../../core/l10n/crop_labels.dart';
import '../../../core/l10n/l10n_ext.dart';
import '../../../core/notifications/push_service.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../../prices/domain/price_forecast.dart';
import '../../prices/presentation/controllers/prices_controller.dart';
import '../../profile/presentation/controllers/profile_controller.dart';
import '../domain/bucket_rules.dart';
import '../domain/bucket_status.dart';
import '../domain/register_result.dart';
import 'controllers/bucket_controller.dart';
import 'controllers/register_controller.dart';
import 'widgets/bucket_live_scope.dart';
import 'widgets/crop_picker_sheet.dart';
import 'widgets/key_value_row.dart';
import 'widgets/land_to_tonnes_sheet.dart';
import 'widgets/quota_table.dart';
import 'widgets/surplus_warning_sheet.dart';

/// Register Harvest Quota — bottom-navigation tab 3 (spec §11.10). Mirrors the
/// web form and adds live quota context. The quota rule lives in the
/// `register_harvest` RPC; the client pre-check only makes the warning instant.
class RegisterQuotaScreen extends ConsumerStatefulWidget {
  const RegisterQuotaScreen({super.key, this.initialCrop, this.initialAmount});

  /// Database crop key to preselect (from Crop Outlook, Prices, the planner).
  final String? initialCrop;
  final double? initialAmount;

  @override
  ConsumerState<RegisterQuotaScreen> createState() => _RegisterQuotaScreenState();
}

enum _Notice { noTarget, unknown }

class _RegisterQuotaScreenState extends ConsumerState<RegisterQuotaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();

  String? _crop;
  String? _cropError;

  /// Set when the server answers `invalid_amount`.
  String? _amountError;
  _Notice? _notice;

  @override
  void initState() {
    super.initState();
    final crop = widget.initialCrop?.trim() ?? '';
    if (crop.isNotEmpty) _crop = crop.toUpperCase();
    final amount = widget.initialAmount;
    if (amount != null && amount > 0) _amount.text = amountFieldText(amount);
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(bucketStatusProvider);
    ref.invalidate(myRegistrationsProvider);
    ref.invalidate(myCropRegistrationsProvider);
    try {
      await ref.read(bucketStatusProvider.future);
    } catch (_) {
      // The form shows the error state.
    }
  }

  String? _validateAmount(String? value) {
    final l10n = context.l10n;
    final text = value?.trim() ?? '';
    if (text.isEmpty) return l10n.validationRequired;
    final amount = double.tryParse(text);
    if (amount != null && amount > AppConst.maxHarvestMt) {
      return l10n.registerAmountMax(Fmt.amount(AppConst.maxHarvestMt));
    }
    return Validators.isAmount(text) ? null : l10n.validationAmount;
  }

  Future<void> _pickCrop(List<BucketStatus> buckets) async {
    FocusScope.of(context).unfocus();
    final picked = await CropPickerSheet.show(
      context,
      buckets: buckets,
      thresholds: ref.read(surplusThresholdsProvider),
      selected: _crop,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _crop = picked;
      _cropError = null;
      _notice = null;
    });
  }

  Future<void> _estimateFromLand(PriceForecast forecast) async {
    FocusScope.of(context).unfocus();
    final tonnes = await LandToTonnesSheet.show(context, forecast: forecast);
    if (tonnes == null || !mounted) return;
    setState(() {
      _amount.text = amountFieldText(tonnes);
      _amountError = null;
    });
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    FocusScope.of(context).unfocus();
    setState(() {
      _amountError = null;
      _notice = null;
      _cropError = _crop == null ? l10n.registerCropRequired : null;
    });
    final amountOk = _formKey.currentState?.validate() ?? false;
    final crop = _crop;
    if (crop == null || !amountOk) return;
    final amount = double.parse(_amount.text.trim());

    final controller = ref.read(registerControllerProvider.notifier);
    final thresholds = ref.read(surplusThresholdsProvider);

    // Instant pre-check against the cached bucket (spec §13.2): the warning
    // opens straight away, and the RPC below still has the final say.
    ValueNotifier<SurplusSheetState>? sheet;
    Future<SurplusChoice?>? choice;
    var sheetOpen = false;
    void openSheet(SurplusSheetState state) {
      sheet = ValueNotifier(state);
      sheetOpen = true;
      choice = SurplusWarningSheet.show(
        context,
        state: sheet!,
        cropName: crop,
        requestedMt: amount,
        thresholds: thresholds,
      ).whenComplete(() => sheetOpen = false);
    }

    final cached = controller.preCheck(crop, amount);
    if (cached != null) openSheet(SurplusSheetState(cached, confirming: true));

    RegisterResult result;
    try {
      result = await controller.submit(crop, amount);
    } catch (e) {
      if (!mounted) return;
      if (sheetOpen) Navigator.of(context).pop();
      context.showError(e);
      sheet?.dispose();
      return;
    }
    if (!mounted) return;

    if (result is RegisterSurplus) {
      if (sheet == null) {
        openSheet(SurplusSheetState(result));
      } else if (sheetOpen) {
        sheet!.value = SurplusSheetState(result);
      }
      final picked = await choice;
      sheet?.dispose();
      if (!mounted) return;
      await _applyChoice(picked, from: crop);
      return;
    }

    // The cache was stale: close the provisional warning before the outcome.
    if (sheetOpen) Navigator.of(context).pop();
    await choice;
    sheet?.dispose();
    if (!mounted) return;

    switch (result) {
      case RegisterSuccess():
        await _onSuccess(crop, amount);
      case RegisterNoTarget():
        setState(() => _notice = _Notice.noTarget);
      case RegisterInvalid():
        setState(() => _amountError = l10n.registerInvalidAmount);
      case RegisterUnknown():
        setState(() => _notice = _Notice.unknown);
      case RegisterSurplus():
        break; // handled above
    }
  }

  Future<void> _applyChoice(SurplusChoice? picked, {required String from}) async {
    switch (picked) {
      case ChooseAlternative(crop: final alternative):
        final key = alternative.cropName.trim().toUpperCase();
        ref.read(registerControllerProvider.notifier).alternativeChosen(from: from, to: key);
        setState(() {
          _crop = key;
          _cropError = null;
        });
        context.showSnack(context.l10n.registerCropChanged(CropLabels.of(context, key)));
      case RegisterRemainder(:final amountMt):
        setState(() => _amount.text = amountFieldText(amountMt));
        await _submit();
      case null:
        break;
    }
  }

  Future<void> _onSuccess(String crop, double amount) async {
    final l10n = context.l10n;
    setState(_amount.clear);
    var viewQuotas = false;
    await SuccessSheet.show(
      context,
      title: l10n.registerSuccessTitle,
      message: l10n.registerSuccessBody(Fmt.amount(amount), CropLabels.of(context, crop)),
      primaryLabel: l10n.registerViewQuotas,
      onPrimary: () => viewQuotas = true,
      secondaryLabel: l10n.commonDone,
    );
    if (!mounted) return;
    // A meaningful moment for feedback and for the push permission (§17.2).
    await FeedbackSheet.maybeShowOnce(
      context,
      ref,
      contextKey: FeedbackContexts.firstRegistration,
    );
    if (!mounted) return;
    try {
      await ref.read(pushServiceProvider).requestPermission();
    } catch (_) {
      // Notifications are optional.
    }
    if (mounted && viewQuotas) await context.push(Routes.myQuotas);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = context.localeTag;
    final bucketAsync = ref.watch(bucketStatusProvider);
    final thresholds = ref.watch(surplusThresholdsProvider);
    final submitting = ref.watch(registerControllerProvider);

    final buckets = bucketAsync.value ?? const <BucketStatus>[];
    final crop = _crop;
    final bucket = bucketFor(buckets, crop);
    final month = bucket?.targetMonth;
    PriceForecast? forecast;
    if (crop != null && month != null) {
      for (final row in ref.watch(cropForecastsProvider(crop))) {
        if (row.isFor(month.year, month.month)) forecast = row;
      }
    }
    final landForecast = forecast?.yieldMtPerHa == null ? null : forecast;

    return AppScaffold(
      appBar: const FarmAppBar(),
      body: BucketLiveScope(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg + kFabClearance,
            ),
            children: [
              const _HeaderCard(),
              const SizedBox(height: AppSpacing.lg),
              SectionCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!bucketAsync.hasValue && bucketAsync.hasError)
                        ErrorState(error: bucketAsync.error, onRetry: _refresh, compact: true)
                      else ...[
                        _CropField(
                          crop: crop,
                          errorText: _cropError,
                          loading: !bucketAsync.hasValue,
                          onTap: buckets.isEmpty ? null : () => _pickCrop(buckets),
                        ),
                        if (bucketAsync.hasValue && buckets.isEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          InfoNote(tone: InfoNoteTone.warning, text: l10n.registerNoTargets),
                        ],
                      ],
                      if (crop != null && bucket != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _CropContextCard(
                          bucket: bucket,
                          level: thresholds.levelOf(bucket),
                          forecast: forecast,
                          locale: locale,
                        ),
                      ] else if (crop != null && bucketAsync.hasValue && buckets.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        InfoNote(
                          tone: InfoNoteTone.warning,
                          text: l10n.registerNoActiveTarget(CropLabels.of(context, crop)),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField.number(
                        label: l10n.registerAmountLabel,
                        controller: _amount,
                        decimal: true,
                        required: true,
                        hint: l10n.registerAmountHint,
                        helper: bucket == null
                            ? null
                            : l10n.registerAmountHelper(Fmt.amount(bucket.roomMt)),
                        errorText: _amountError,
                        validator: _validateAmount,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) {
                          if (_amountError != null) setState(() => _amountError = null);
                        },
                      ),
                      if (landForecast != null)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton.icon(
                            onPressed: () => _estimateFromLand(landForecast),
                            icon: const Icon(Icons.straighten_rounded, size: 18),
                            label: Text(l10n.registerDontKnow),
                          ),
                        ),
                      if (_notice != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        InfoNote(
                          tone: _notice == _Notice.noTarget
                              ? InfoNoteTone.danger
                              : InfoNoteTone.warning,
                          text: _notice == _Notice.noTarget
                              ? l10n.registerNoTarget
                              : l10n.registerUnknownResult,
                          actionLabel: l10n.registerContactSupport,
                          onAction: () => context.push(Routes.support),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      OnlineOnly(
                        builder: (_, online) => PrimaryButton(
                          label: l10n.registerCheckAndRegister,
                          icon: Icons.verified_outlined,
                          loading: submitting,
                          onPressed: online && bucketAsync.hasValue ? _submit : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const _MyQuotasCard(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Title, "Farmer Authenticated" badge and the "secure price" note.
class _HeaderCard extends ConsumerWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final authenticated = ref.watch(profileCompleteProvider);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.registerTitle, style: text.titleLarge),
          if (authenticated) ...[
            const SizedBox(height: AppSpacing.sm),
            TagChip(l10n.registerAuthBadge, icon: Icons.verified_user_outlined),
          ],
          const SizedBox(height: AppSpacing.md),
          InfoNote(text: l10n.registerInfo),
        ],
      ),
    );
  }
}

/// Label-above field that opens the crop picker.
class _CropField extends StatelessWidget {
  const _CropField({required this.crop, this.errorText, required this.loading, this.onTap});

  final String? crop;
  final String? errorText;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final crop = this.crop;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            text: l10n.registerSelectCrop,
            children: const [TextSpan(text: ' *', style: TextStyle(color: AppColors.red600))],
          ),
          style: text.labelMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          key: const Key('register-crop-field'),
          onTap: onTap,
          borderRadius: AppRadii.inputBorder,
          child: InputDecorator(
            isEmpty: crop == null,
            decoration: InputDecoration(
              hintText: l10n.registerSelectCropHint,
              errorText: errorText,
              suffixIcon: loading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            child: crop == null
                ? null
                : Row(
                    children: [
                      Text(CropLabels.emoji(crop), style: const TextStyle(fontSize: 18, height: 1.1)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          CropLabels.of(context, crop),
                          style: text.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

/// Live context for the chosen crop: quota numbers, prices, dates, farmer
/// count and the model forecast for the target harvest month.
class _CropContextCard extends StatelessWidget {
  const _CropContextCard({
    required this.bucket,
    required this.level,
    required this.forecast,
    required this.locale,
  });

  final BucketStatus bucket;
  final SurplusLevel level;
  final PriceForecast? forecast;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final planting = bucket.plantingLabel(locale);
    final harvest = bucket.harvestLabel(locale);
    final forecast = this.forecast;
    final profit = forecast?.profitPerKg ?? forecast?.marginPerKg;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.green100.withValues(alpha: 0.45),
        borderRadius: AppRadii.inputBorder,
        border: Border.all(color: AppColors.line200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(CropLabels.of(context, bucket.cropName), style: text.titleMedium),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(child: SurplusChip(level)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          QuotaProgressBar(
            filledMt: bucket.filledMt,
            limitMt: bucket.limitMt,
            level: level,
            showLabels: false,
          ),
          const SizedBox(height: AppSpacing.sm),
          KeyValueRow(label: l10n.registerLimit, value: Fmt.mt(bucket.limitMt)),
          KeyValueRow(label: l10n.registerFilled, value: Fmt.mt(bucket.filledMt)),
          KeyValueRow(
            label: l10n.registerRemaining,
            value: Fmt.mt(bucket.roomMt),
            valueColor: level.color,
          ),
          if (bucket.fairPrice != null)
            KeyValueRow(label: l10n.registerFairPrice, value: Fmt.perKg(bucket.fairPrice)),
          if (bucket.wholesalePrice != null)
            KeyValueRow(label: l10n.registerWholesale, value: Fmt.perKg(bucket.wholesalePrice)),
          if (planting != null) KeyValueRow(label: l10n.registerPlantingDate, value: planting),
          if (harvest != null) KeyValueRow(label: l10n.registerHarvestDate, value: harvest),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(Icons.groups_outlined, size: 16, color: AppColors.ink500),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(l10n.registerFarmerCount(bucket.farmerCount), style: text.bodySmall),
              ),
            ],
          ),
          if (forecast != null) ...[
            const Divider(height: AppSpacing.xl),
            Text(
              l10n.registerForecastTitle(Fmt.monthYear(forecast.harvestDate, locale)),
              style: text.labelMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            KeyValueRow(
              label: l10n.registerForecastWholesale,
              value: Fmt.perKg(forecast.wholesalePrice),
            ),
            if (forecast.fairPrice != null)
              KeyValueRow(label: l10n.registerFairPrice, value: Fmt.perKg(forecast.fairPrice)),
            if (profit != null)
              KeyValueRow(
                label: l10n.registerForecastProfit,
                value: Fmt.perKg(profit),
                valueColor: profit >= 0 ? AppColors.green600 : AppColors.red600,
              ),
          ],
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: () => context.push(Routes.priceDetail(bucket.key)),
              icon: const Icon(Icons.show_chart_rounded, size: 18),
              label: Text(l10n.registerSeeTrend),
            ),
          ),
        ],
      ),
    );
  }
}

/// "My Registered Quotas" under the form: the latest rows, a record count and
/// the locked-in note linking to Contact Support.
class _MyQuotasCard extends ConsumerWidget {
  const _MyQuotasCard();

  static const _preview = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final registrations = ref.watch(myRegistrationsProvider);
    final statuses = ref.watch(cropRegistrationStatusProvider);
    final count = registrations.value?.length;

    return SectionCard(
      title: l10n.quotasTitle,
      trailing: count == null ? null : TagChip(l10n.recordsCount(count)),
      child: AsyncValueView(
        value: registrations,
        compact: true,
        onRetry: () => ref.invalidate(myRegistrationsProvider),
        empty: EmptyState(
          compact: true,
          icon: Icons.assignment_outlined,
          title: l10n.quotasEmptyTitle,
          message: l10n.quotasEmptyBody,
        ),
        data: (rows) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            QuotaTable(rows: rows.take(_preview).toList(), statuses: statuses),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () => context.push(Routes.myQuotas),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.chevron_right_rounded, size: 18),
                label: Text(l10n.commonSeeAll),
              ),
            ),
            InfoNote(
              text: l10n.quotasLockedNote,
              actionLabel: l10n.quotasRequestChange,
              onAction: () => context.push(Routes.supportWith(l10n.quotasChangeSubject)),
            ),
          ],
        ),
      ),
    );
  }
}
