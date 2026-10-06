// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_forecast.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PriceForecast {

@JsonKey(name: 'crop_name') String get cropName;@JsonKey(fromJson: asInt) int get year;@JsonKey(fromJson: asInt) int get month;@JsonKey(name: 'wholesale_price', fromJson: asDouble) double get wholesalePrice;@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? get retailPrice;@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? get fairPrice;@JsonKey(name: 'floor_price', fromJson: asDoubleOrNull) double? get floorPrice;@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? get costPerKg;@JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull) double? get profitPerKg;@JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull) double? get harvestGoalMt;@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? get allowedExtentHa;@JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull) int? get growthCycleMonths;@JsonKey(name: 'planting_year', fromJson: asIntOrNull) int? get plantingYear;@JsonKey(name: 'planting_month', fromJson: asIntOrNull) int? get plantingMonth;@JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull) double? get rainfallMm;@JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull) double? get dieselLkr;@JsonKey(name: 'transport_index', fromJson: asDoubleOrNull) double? get transportIndex;@JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull) double? get weatherMultiplier;@JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull) double? get baselineSupplyMt;@JsonKey(name: 'model_version', fromJson: asString) String get modelVersion;@JsonKey(name: 'generated_at') DateTime? get generatedAt;
/// Create a copy of PriceForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceForecastCopyWith<PriceForecast> get copyWith => _$PriceForecastCopyWithImpl<PriceForecast>(this as PriceForecast, _$identity);

  /// Serializes this PriceForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PriceForecast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceForecast&&(identical(other.cropName, _this.cropName) || other.cropName == _this.cropName)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.wholesalePrice, _this.wholesalePrice) || other.wholesalePrice == _this.wholesalePrice)&&(identical(other.retailPrice, _this.retailPrice) || other.retailPrice == _this.retailPrice)&&(identical(other.fairPrice, _this.fairPrice) || other.fairPrice == _this.fairPrice)&&(identical(other.floorPrice, _this.floorPrice) || other.floorPrice == _this.floorPrice)&&(identical(other.costPerKg, _this.costPerKg) || other.costPerKg == _this.costPerKg)&&(identical(other.profitPerKg, _this.profitPerKg) || other.profitPerKg == _this.profitPerKg)&&(identical(other.harvestGoalMt, _this.harvestGoalMt) || other.harvestGoalMt == _this.harvestGoalMt)&&(identical(other.allowedExtentHa, _this.allowedExtentHa) || other.allowedExtentHa == _this.allowedExtentHa)&&(identical(other.growthCycleMonths, _this.growthCycleMonths) || other.growthCycleMonths == _this.growthCycleMonths)&&(identical(other.plantingYear, _this.plantingYear) || other.plantingYear == _this.plantingYear)&&(identical(other.plantingMonth, _this.plantingMonth) || other.plantingMonth == _this.plantingMonth)&&(identical(other.rainfallMm, _this.rainfallMm) || other.rainfallMm == _this.rainfallMm)&&(identical(other.dieselLkr, _this.dieselLkr) || other.dieselLkr == _this.dieselLkr)&&(identical(other.transportIndex, _this.transportIndex) || other.transportIndex == _this.transportIndex)&&(identical(other.weatherMultiplier, _this.weatherMultiplier) || other.weatherMultiplier == _this.weatherMultiplier)&&(identical(other.baselineSupplyMt, _this.baselineSupplyMt) || other.baselineSupplyMt == _this.baselineSupplyMt)&&(identical(other.modelVersion, _this.modelVersion) || other.modelVersion == _this.modelVersion)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PriceForecast;
  return Object.hashAll([runtimeType,_this.cropName,_this.year,_this.month,_this.wholesalePrice,_this.retailPrice,_this.fairPrice,_this.floorPrice,_this.costPerKg,_this.profitPerKg,_this.harvestGoalMt,_this.allowedExtentHa,_this.growthCycleMonths,_this.plantingYear,_this.plantingMonth,_this.rainfallMm,_this.dieselLkr,_this.transportIndex,_this.weatherMultiplier,_this.baselineSupplyMt,_this.modelVersion,_this.generatedAt]);
}

@override
String toString() {
  final _this = this as PriceForecast;
  return 'PriceForecast(cropName: ${_this.cropName}, year: ${_this.year}, month: ${_this.month}, wholesalePrice: ${_this.wholesalePrice}, retailPrice: ${_this.retailPrice}, fairPrice: ${_this.fairPrice}, floorPrice: ${_this.floorPrice}, costPerKg: ${_this.costPerKg}, profitPerKg: ${_this.profitPerKg}, harvestGoalMt: ${_this.harvestGoalMt}, allowedExtentHa: ${_this.allowedExtentHa}, growthCycleMonths: ${_this.growthCycleMonths}, plantingYear: ${_this.plantingYear}, plantingMonth: ${_this.plantingMonth}, rainfallMm: ${_this.rainfallMm}, dieselLkr: ${_this.dieselLkr}, transportIndex: ${_this.transportIndex}, weatherMultiplier: ${_this.weatherMultiplier}, baselineSupplyMt: ${_this.baselineSupplyMt}, modelVersion: ${_this.modelVersion}, generatedAt: ${_this.generatedAt})';
}


}

/// @nodoc
abstract mixin class $PriceForecastCopyWith<$Res>  {
  factory $PriceForecastCopyWith(PriceForecast value, $Res Function(PriceForecast) _then) = _$PriceForecastCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(fromJson: asInt) int year,@JsonKey(fromJson: asInt) int month,@JsonKey(name: 'wholesale_price', fromJson: asDouble) double wholesalePrice,@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? retailPrice,@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'floor_price', fromJson: asDoubleOrNull) double? floorPrice,@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? costPerKg,@JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull) double? profitPerKg,@JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull) double? harvestGoalMt,@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa,@JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull) int? growthCycleMonths,@JsonKey(name: 'planting_year', fromJson: asIntOrNull) int? plantingYear,@JsonKey(name: 'planting_month', fromJson: asIntOrNull) int? plantingMonth,@JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull) double? rainfallMm,@JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull) double? dieselLkr,@JsonKey(name: 'transport_index', fromJson: asDoubleOrNull) double? transportIndex,@JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull) double? weatherMultiplier,@JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull) double? baselineSupplyMt,@JsonKey(name: 'model_version', fromJson: asString) String modelVersion,@JsonKey(name: 'generated_at') DateTime? generatedAt
});




}
/// @nodoc
class _$PriceForecastCopyWithImpl<$Res>
    implements $PriceForecastCopyWith<$Res> {
  _$PriceForecastCopyWithImpl(this._self, this._then);

  final PriceForecast _self;
  final $Res Function(PriceForecast) _then;

/// Create a copy of PriceForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cropName = null,Object? year = null,Object? month = null,Object? wholesalePrice = null,Object? retailPrice = freezed,Object? fairPrice = freezed,Object? floorPrice = freezed,Object? costPerKg = freezed,Object? profitPerKg = freezed,Object? harvestGoalMt = freezed,Object? allowedExtentHa = freezed,Object? growthCycleMonths = freezed,Object? plantingYear = freezed,Object? plantingMonth = freezed,Object? rainfallMm = freezed,Object? dieselLkr = freezed,Object? transportIndex = freezed,Object? weatherMultiplier = freezed,Object? baselineSupplyMt = freezed,Object? modelVersion = null,Object? generatedAt = freezed,}) {
  return _then(PriceForecast(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,wholesalePrice: null == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double,retailPrice: freezed == retailPrice ? _self.retailPrice : retailPrice // ignore: cast_nullable_to_non_nullable
as double?,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,floorPrice: freezed == floorPrice ? _self.floorPrice : floorPrice // ignore: cast_nullable_to_non_nullable
as double?,costPerKg: freezed == costPerKg ? _self.costPerKg : costPerKg // ignore: cast_nullable_to_non_nullable
as double?,profitPerKg: freezed == profitPerKg ? _self.profitPerKg : profitPerKg // ignore: cast_nullable_to_non_nullable
as double?,harvestGoalMt: freezed == harvestGoalMt ? _self.harvestGoalMt : harvestGoalMt // ignore: cast_nullable_to_non_nullable
as double?,allowedExtentHa: freezed == allowedExtentHa ? _self.allowedExtentHa : allowedExtentHa // ignore: cast_nullable_to_non_nullable
as double?,growthCycleMonths: freezed == growthCycleMonths ? _self.growthCycleMonths : growthCycleMonths // ignore: cast_nullable_to_non_nullable
as int?,plantingYear: freezed == plantingYear ? _self.plantingYear : plantingYear // ignore: cast_nullable_to_non_nullable
as int?,plantingMonth: freezed == plantingMonth ? _self.plantingMonth : plantingMonth // ignore: cast_nullable_to_non_nullable
as int?,rainfallMm: freezed == rainfallMm ? _self.rainfallMm : rainfallMm // ignore: cast_nullable_to_non_nullable
as double?,dieselLkr: freezed == dieselLkr ? _self.dieselLkr : dieselLkr // ignore: cast_nullable_to_non_nullable
as double?,transportIndex: freezed == transportIndex ? _self.transportIndex : transportIndex // ignore: cast_nullable_to_non_nullable
as double?,weatherMultiplier: freezed == weatherMultiplier ? _self.weatherMultiplier : weatherMultiplier // ignore: cast_nullable_to_non_nullable
as double?,baselineSupplyMt: freezed == baselineSupplyMt ? _self.baselineSupplyMt : baselineSupplyMt // ignore: cast_nullable_to_non_nullable
as double?,modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceForecast].
extension PriceForecastPatterns on PriceForecast {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceForecast() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceForecast value)  $default,){
final _that = this;
switch (_that) {
case _PriceForecast():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceForecast value)?  $default,){
final _that = this;
switch (_that) {
case _PriceForecast() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(fromJson: asInt)  int year, @JsonKey(fromJson: asInt)  int month, @JsonKey(name: 'wholesale_price', fromJson: asDouble)  double wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull)  double? retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'floor_price', fromJson: asDoubleOrNull)  double? floorPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull)  double? costPerKg, @JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull)  double? profitPerKg, @JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull)  double? harvestGoalMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa, @JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull)  int? growthCycleMonths, @JsonKey(name: 'planting_year', fromJson: asIntOrNull)  int? plantingYear, @JsonKey(name: 'planting_month', fromJson: asIntOrNull)  int? plantingMonth, @JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull)  double? rainfallMm, @JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull)  double? dieselLkr, @JsonKey(name: 'transport_index', fromJson: asDoubleOrNull)  double? transportIndex, @JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull)  double? weatherMultiplier, @JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull)  double? baselineSupplyMt, @JsonKey(name: 'model_version', fromJson: asString)  String modelVersion, @JsonKey(name: 'generated_at')  DateTime? generatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceForecast() when $default != null:
return $default(_that.cropName,_that.year,_that.month,_that.wholesalePrice,_that.retailPrice,_that.fairPrice,_that.floorPrice,_that.costPerKg,_that.profitPerKg,_that.harvestGoalMt,_that.allowedExtentHa,_that.growthCycleMonths,_that.plantingYear,_that.plantingMonth,_that.rainfallMm,_that.dieselLkr,_that.transportIndex,_that.weatherMultiplier,_that.baselineSupplyMt,_that.modelVersion,_that.generatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(fromJson: asInt)  int year, @JsonKey(fromJson: asInt)  int month, @JsonKey(name: 'wholesale_price', fromJson: asDouble)  double wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull)  double? retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'floor_price', fromJson: asDoubleOrNull)  double? floorPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull)  double? costPerKg, @JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull)  double? profitPerKg, @JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull)  double? harvestGoalMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa, @JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull)  int? growthCycleMonths, @JsonKey(name: 'planting_year', fromJson: asIntOrNull)  int? plantingYear, @JsonKey(name: 'planting_month', fromJson: asIntOrNull)  int? plantingMonth, @JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull)  double? rainfallMm, @JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull)  double? dieselLkr, @JsonKey(name: 'transport_index', fromJson: asDoubleOrNull)  double? transportIndex, @JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull)  double? weatherMultiplier, @JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull)  double? baselineSupplyMt, @JsonKey(name: 'model_version', fromJson: asString)  String modelVersion, @JsonKey(name: 'generated_at')  DateTime? generatedAt)  $default,) {final _that = this;
switch (_that) {
case _PriceForecast():
return $default(_that.cropName,_that.year,_that.month,_that.wholesalePrice,_that.retailPrice,_that.fairPrice,_that.floorPrice,_that.costPerKg,_that.profitPerKg,_that.harvestGoalMt,_that.allowedExtentHa,_that.growthCycleMonths,_that.plantingYear,_that.plantingMonth,_that.rainfallMm,_that.dieselLkr,_that.transportIndex,_that.weatherMultiplier,_that.baselineSupplyMt,_that.modelVersion,_that.generatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'crop_name')  String cropName, @JsonKey(fromJson: asInt)  int year, @JsonKey(fromJson: asInt)  int month, @JsonKey(name: 'wholesale_price', fromJson: asDouble)  double wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull)  double? retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull)  double? fairPrice, @JsonKey(name: 'floor_price', fromJson: asDoubleOrNull)  double? floorPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull)  double? costPerKg, @JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull)  double? profitPerKg, @JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull)  double? harvestGoalMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull)  double? allowedExtentHa, @JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull)  int? growthCycleMonths, @JsonKey(name: 'planting_year', fromJson: asIntOrNull)  int? plantingYear, @JsonKey(name: 'planting_month', fromJson: asIntOrNull)  int? plantingMonth, @JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull)  double? rainfallMm, @JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull)  double? dieselLkr, @JsonKey(name: 'transport_index', fromJson: asDoubleOrNull)  double? transportIndex, @JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull)  double? weatherMultiplier, @JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull)  double? baselineSupplyMt, @JsonKey(name: 'model_version', fromJson: asString)  String modelVersion, @JsonKey(name: 'generated_at')  DateTime? generatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PriceForecast() when $default != null:
return $default(_that.cropName,_that.year,_that.month,_that.wholesalePrice,_that.retailPrice,_that.fairPrice,_that.floorPrice,_that.costPerKg,_that.profitPerKg,_that.harvestGoalMt,_that.allowedExtentHa,_that.growthCycleMonths,_that.plantingYear,_that.plantingMonth,_that.rainfallMm,_that.dieselLkr,_that.transportIndex,_that.weatherMultiplier,_that.baselineSupplyMt,_that.modelVersion,_that.generatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceForecast extends PriceForecast {
  const _PriceForecast({@JsonKey(name: 'crop_name') required this.cropName, @JsonKey(fromJson: asInt) required this.year, @JsonKey(fromJson: asInt) required this.month, @JsonKey(name: 'wholesale_price', fromJson: asDouble) required this.wholesalePrice, @JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) this.retailPrice, @JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) this.fairPrice, @JsonKey(name: 'floor_price', fromJson: asDoubleOrNull) this.floorPrice, @JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) this.costPerKg, @JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull) this.profitPerKg, @JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull) this.harvestGoalMt, @JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) this.allowedExtentHa, @JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull) this.growthCycleMonths, @JsonKey(name: 'planting_year', fromJson: asIntOrNull) this.plantingYear, @JsonKey(name: 'planting_month', fromJson: asIntOrNull) this.plantingMonth, @JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull) this.rainfallMm, @JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull) this.dieselLkr, @JsonKey(name: 'transport_index', fromJson: asDoubleOrNull) this.transportIndex, @JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull) this.weatherMultiplier, @JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull) this.baselineSupplyMt, @JsonKey(name: 'model_version', fromJson: asString) this.modelVersion = '', @JsonKey(name: 'generated_at') this.generatedAt}): super._();
  factory _PriceForecast.fromJson(Map<String, dynamic> json) => _$PriceForecastFromJson(json);

@override@JsonKey(name: 'crop_name') final  String cropName;
@override@JsonKey(fromJson: asInt) final  int year;
@override@JsonKey(fromJson: asInt) final  int month;
@override@JsonKey(name: 'wholesale_price', fromJson: asDouble) final  double wholesalePrice;
@override@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) final  double? retailPrice;
@override@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) final  double? fairPrice;
@override@JsonKey(name: 'floor_price', fromJson: asDoubleOrNull) final  double? floorPrice;
@override@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) final  double? costPerKg;
@override@JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull) final  double? profitPerKg;
@override@JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull) final  double? harvestGoalMt;
@override@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) final  double? allowedExtentHa;
@override@JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull) final  int? growthCycleMonths;
@override@JsonKey(name: 'planting_year', fromJson: asIntOrNull) final  int? plantingYear;
@override@JsonKey(name: 'planting_month', fromJson: asIntOrNull) final  int? plantingMonth;
@override@JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull) final  double? rainfallMm;
@override@JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull) final  double? dieselLkr;
@override@JsonKey(name: 'transport_index', fromJson: asDoubleOrNull) final  double? transportIndex;
@override@JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull) final  double? weatherMultiplier;
@override@JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull) final  double? baselineSupplyMt;
@override@JsonKey(name: 'model_version', fromJson: asString) final  String modelVersion;
@override@JsonKey(name: 'generated_at') final  DateTime? generatedAt;

/// Create a copy of PriceForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceForecastCopyWith<_PriceForecast> get copyWith => __$PriceForecastCopyWithImpl<_PriceForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceForecastToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceForecast&&(identical(other.cropName, cropName) || other.cropName == cropName)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.wholesalePrice, wholesalePrice) || other.wholesalePrice == wholesalePrice)&&(identical(other.retailPrice, retailPrice) || other.retailPrice == retailPrice)&&(identical(other.fairPrice, fairPrice) || other.fairPrice == fairPrice)&&(identical(other.floorPrice, floorPrice) || other.floorPrice == floorPrice)&&(identical(other.costPerKg, costPerKg) || other.costPerKg == costPerKg)&&(identical(other.profitPerKg, profitPerKg) || other.profitPerKg == profitPerKg)&&(identical(other.harvestGoalMt, harvestGoalMt) || other.harvestGoalMt == harvestGoalMt)&&(identical(other.allowedExtentHa, allowedExtentHa) || other.allowedExtentHa == allowedExtentHa)&&(identical(other.growthCycleMonths, growthCycleMonths) || other.growthCycleMonths == growthCycleMonths)&&(identical(other.plantingYear, plantingYear) || other.plantingYear == plantingYear)&&(identical(other.plantingMonth, plantingMonth) || other.plantingMonth == plantingMonth)&&(identical(other.rainfallMm, rainfallMm) || other.rainfallMm == rainfallMm)&&(identical(other.dieselLkr, dieselLkr) || other.dieselLkr == dieselLkr)&&(identical(other.transportIndex, transportIndex) || other.transportIndex == transportIndex)&&(identical(other.weatherMultiplier, weatherMultiplier) || other.weatherMultiplier == weatherMultiplier)&&(identical(other.baselineSupplyMt, baselineSupplyMt) || other.baselineSupplyMt == baselineSupplyMt)&&(identical(other.modelVersion, modelVersion) || other.modelVersion == modelVersion)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,cropName,year,month,wholesalePrice,retailPrice,fairPrice,floorPrice,costPerKg,profitPerKg,harvestGoalMt,allowedExtentHa,growthCycleMonths,plantingYear,plantingMonth,rainfallMm,dieselLkr,transportIndex,weatherMultiplier,baselineSupplyMt,modelVersion,generatedAt]);
}

@override
String toString() {
    return 'PriceForecast(cropName: $cropName, year: $year, month: $month, wholesalePrice: $wholesalePrice, retailPrice: $retailPrice, fairPrice: $fairPrice, floorPrice: $floorPrice, costPerKg: $costPerKg, profitPerKg: $profitPerKg, harvestGoalMt: $harvestGoalMt, allowedExtentHa: $allowedExtentHa, growthCycleMonths: $growthCycleMonths, plantingYear: $plantingYear, plantingMonth: $plantingMonth, rainfallMm: $rainfallMm, dieselLkr: $dieselLkr, transportIndex: $transportIndex, weatherMultiplier: $weatherMultiplier, baselineSupplyMt: $baselineSupplyMt, modelVersion: $modelVersion, generatedAt: $generatedAt)';
}


}

/// @nodoc
abstract mixin class _$PriceForecastCopyWith<$Res> implements $PriceForecastCopyWith<$Res> {
  factory _$PriceForecastCopyWith(_PriceForecast value, $Res Function(_PriceForecast) _then) = __$PriceForecastCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'crop_name') String cropName,@JsonKey(fromJson: asInt) int year,@JsonKey(fromJson: asInt) int month,@JsonKey(name: 'wholesale_price', fromJson: asDouble) double wholesalePrice,@JsonKey(name: 'retail_price', fromJson: asDoubleOrNull) double? retailPrice,@JsonKey(name: 'fair_price', fromJson: asDoubleOrNull) double? fairPrice,@JsonKey(name: 'floor_price', fromJson: asDoubleOrNull) double? floorPrice,@JsonKey(name: 'cost_per_kg', fromJson: asDoubleOrNull) double? costPerKg,@JsonKey(name: 'profit_per_kg', fromJson: asDoubleOrNull) double? profitPerKg,@JsonKey(name: 'harvest_goal_mt', fromJson: asDoubleOrNull) double? harvestGoalMt,@JsonKey(name: 'allowed_extent_ha', fromJson: asDoubleOrNull) double? allowedExtentHa,@JsonKey(name: 'growth_cycle_months', fromJson: asIntOrNull) int? growthCycleMonths,@JsonKey(name: 'planting_year', fromJson: asIntOrNull) int? plantingYear,@JsonKey(name: 'planting_month', fromJson: asIntOrNull) int? plantingMonth,@JsonKey(name: 'rainfall_mm', fromJson: asDoubleOrNull) double? rainfallMm,@JsonKey(name: 'diesel_lkr', fromJson: asDoubleOrNull) double? dieselLkr,@JsonKey(name: 'transport_index', fromJson: asDoubleOrNull) double? transportIndex,@JsonKey(name: 'weather_multiplier', fromJson: asDoubleOrNull) double? weatherMultiplier,@JsonKey(name: 'baseline_supply_mt', fromJson: asDoubleOrNull) double? baselineSupplyMt,@JsonKey(name: 'model_version', fromJson: asString) String modelVersion,@JsonKey(name: 'generated_at') DateTime? generatedAt
});




}
/// @nodoc
class __$PriceForecastCopyWithImpl<$Res>
    implements _$PriceForecastCopyWith<$Res> {
  __$PriceForecastCopyWithImpl(this._self, this._then);

  final _PriceForecast _self;
  final $Res Function(_PriceForecast) _then;

/// Create a copy of PriceForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cropName = null,Object? year = null,Object? month = null,Object? wholesalePrice = null,Object? retailPrice = freezed,Object? fairPrice = freezed,Object? floorPrice = freezed,Object? costPerKg = freezed,Object? profitPerKg = freezed,Object? harvestGoalMt = freezed,Object? allowedExtentHa = freezed,Object? growthCycleMonths = freezed,Object? plantingYear = freezed,Object? plantingMonth = freezed,Object? rainfallMm = freezed,Object? dieselLkr = freezed,Object? transportIndex = freezed,Object? weatherMultiplier = freezed,Object? baselineSupplyMt = freezed,Object? modelVersion = null,Object? generatedAt = freezed,}) {
  return _then(_PriceForecast(
cropName: null == cropName ? _self.cropName : cropName // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,wholesalePrice: null == wholesalePrice ? _self.wholesalePrice : wholesalePrice // ignore: cast_nullable_to_non_nullable
as double,retailPrice: freezed == retailPrice ? _self.retailPrice : retailPrice // ignore: cast_nullable_to_non_nullable
as double?,fairPrice: freezed == fairPrice ? _self.fairPrice : fairPrice // ignore: cast_nullable_to_non_nullable
as double?,floorPrice: freezed == floorPrice ? _self.floorPrice : floorPrice // ignore: cast_nullable_to_non_nullable
as double?,costPerKg: freezed == costPerKg ? _self.costPerKg : costPerKg // ignore: cast_nullable_to_non_nullable
as double?,profitPerKg: freezed == profitPerKg ? _self.profitPerKg : profitPerKg // ignore: cast_nullable_to_non_nullable
as double?,harvestGoalMt: freezed == harvestGoalMt ? _self.harvestGoalMt : harvestGoalMt // ignore: cast_nullable_to_non_nullable
as double?,allowedExtentHa: freezed == allowedExtentHa ? _self.allowedExtentHa : allowedExtentHa // ignore: cast_nullable_to_non_nullable
as double?,growthCycleMonths: freezed == growthCycleMonths ? _self.growthCycleMonths : growthCycleMonths // ignore: cast_nullable_to_non_nullable
as int?,plantingYear: freezed == plantingYear ? _self.plantingYear : plantingYear // ignore: cast_nullable_to_non_nullable
as int?,plantingMonth: freezed == plantingMonth ? _self.plantingMonth : plantingMonth // ignore: cast_nullable_to_non_nullable
as int?,rainfallMm: freezed == rainfallMm ? _self.rainfallMm : rainfallMm // ignore: cast_nullable_to_non_nullable
as double?,dieselLkr: freezed == dieselLkr ? _self.dieselLkr : dieselLkr // ignore: cast_nullable_to_non_nullable
as double?,transportIndex: freezed == transportIndex ? _self.transportIndex : transportIndex // ignore: cast_nullable_to_non_nullable
as double?,weatherMultiplier: freezed == weatherMultiplier ? _self.weatherMultiplier : weatherMultiplier // ignore: cast_nullable_to_non_nullable
as double?,baselineSupplyMt: freezed == baselineSupplyMt ? _self.baselineSupplyMt : baselineSupplyMt // ignore: cast_nullable_to_non_nullable
as double?,modelVersion: null == modelVersion ? _self.modelVersion : modelVersion // ignore: cast_nullable_to_non_nullable
as String,generatedAt: freezed == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
