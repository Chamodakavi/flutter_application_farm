import 'price_forecast.dart';

/// Farmers usually think in acres; the model works in hectares.
enum LandUnit {
  acres,
  hectares;

  double toHa(double size) => this == acres ? ProfitPlan.acresToHa(size) : size;
}

/// "If I plant this much, what do I get?" — pure maths on one forecast row
/// (spec §13.7). Every figure is null when the model lacks the input for it.
class ProfitPlan {
  const ProfitPlan({required this.forecast, required this.landHa});

  /// Plan for a land size typed in [unit].
  factory ProfitPlan.forLand(PriceForecast forecast, double size, LandUnit unit) =>
      ProfitPlan(forecast: forecast, landHa: unit.toHa(size));

  final PriceForecast forecast;
  final double landHa;

  static const haPerAcre = 0.404686;

  static double acresToHa(double acres) => acres * haPerAcre;

  double? get yieldMtPerHa => forecast.yieldMtPerHa;

  /// Land (ha) × model yield per hectare.
  double? get expectedMt => yieldMtPerHa == null ? null : landHa * yieldMtPerHa!;

  double? get costLkr => (expectedMt == null || forecast.costPerKg == null)
      ? null
      : expectedMt! * 1000 * forecast.costPerKg!;

  /// Income at the forecast wholesale price.
  double? get revenueLkr => expectedMt == null ? null : expectedMt! * 1000 * forecast.wholesalePrice;

  double? get profitLkr => (revenueLkr == null || costLkr == null) ? null : revenueLkr! - costLkr!;

  double? get breakEvenPerKg => forecast.costPerKg;

  bool get isLoss => (profitLkr ?? 0) < 0;

  /// `profit`, `loss`, `even` or `unknown` — the only outcome sent to analytics.
  String get profitSign {
    final p = profitLkr;
    if (p == null) return 'unknown';
    return p > 0 ? 'profit' : (p < 0 ? 'loss' : 'even');
  }
}
