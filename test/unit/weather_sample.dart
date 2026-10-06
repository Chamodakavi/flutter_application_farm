/// A realistic Open-Meteo `/v1/forecast` response for the weather tests:
/// 7 daily entries and 168 hourly values starting at midnight of [start].
Map<String, dynamic> sampleOpenMeteo({
  DateTime? start,
  double temperature = 29.4,
  int weatherCode = 2,
  List<int?> dailyRain = const [35, 80, 20, null, 55, 10, 65],
  int Function(int hour)? hourlyRain,
}) {
  final first = start ?? DateTime(2026, 10, 5);
  String day(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  String hour(DateTime d) => '${day(d)}T${d.hour.toString().padLeft(2, '0')}:00';

  final days = [for (var i = 0; i < 7; i++) DateTime(first.year, first.month, first.day + i)];
  final hours = [
    for (var i = 0; i < 168; i++) DateTime(first.year, first.month, first.day, i),
  ];

  return {
    'latitude': 7.25,
    'longitude': 80.625,
    'generationtime_ms': 0.21,
    'utc_offset_seconds': 19800,
    'timezone': 'Asia/Colombo',
    'timezone_abbreviation': 'GMT+5:30',
    'elevation': 477.0,
    'current_units': {
      'time': 'iso8601',
      'interval': 'seconds',
      'temperature_2m': '°C',
      'relative_humidity_2m': '%',
      'precipitation': 'mm',
      'weather_code': 'wmo code',
      'wind_speed_10m': 'km/h',
    },
    'current': {
      'time': '${day(first)}T14:15',
      'interval': 900,
      'temperature_2m': temperature,
      'relative_humidity_2m': 74,
      'precipitation': 0.1,
      'weather_code': weatherCode,
      'wind_speed_10m': 11.6,
    },
    'hourly_units': {'time': 'iso8601', 'precipitation_probability': '%'},
    'hourly': {
      'time': [for (final h in hours) hour(h)],
      'precipitation_probability': [
        for (var i = 0; i < hours.length; i++) hourlyRain?.call(i) ?? (i * 7) % 101,
      ],
    },
    'daily_units': {
      'time': 'iso8601',
      'weather_code': 'wmo code',
      'temperature_2m_max': '°C',
      'temperature_2m_min': '°C',
      'precipitation_probability_max': '%',
    },
    'daily': {
      'time': [for (final d in days) day(d)],
      'weather_code': [2, 61, 3, 80, 95, 0, 63],
      'temperature_2m_max': [30.1, 28.4, 29.9, 27.2, 26.8, 31.5, 28.0],
      'temperature_2m_min': [21.3, 20.9, 21.8, 20.4, 20.1, 22.0, 21.1],
      'precipitation_probability_max': dailyRain,
    },
  };
}
