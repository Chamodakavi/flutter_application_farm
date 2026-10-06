import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:farmfriend/core/cache/cache_policy.dart';
import 'package:farmfriend/core/errors/app_exception.dart';
import 'package:farmfriend/core/l10n/district_labels.dart';
import 'package:farmfriend/features/weather/data/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'weather_sample.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final ResponseBody Function(RequestOptions options) _handler;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

const _kandy = District(key: 'Kandy', si: 'මහනුවර', ta: 'கண்டி', lat: 7.29, lon: 80.63);

void main() {
  // Hive is not initialised here, so the cache is a no-op and every fetch
  // goes to the (fake) network.
  WeatherRepository repoWith(_FakeAdapter adapter) =>
      WeatherRepository(Dio()..httpClientAdapter = adapter, const CacheStore());

  test('requests the district centroid from Open-Meteo and parses the answer', () async {
    final adapter = _FakeAdapter(
      (_) => ResponseBody.fromString(
        jsonEncode(sampleOpenMeteo()),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );

    final weather = await repoWith(adapter).fetch(_kandy);

    expect(weather.current.temperatureC, 29.4);
    expect(weather.daily, hasLength(7));

    final uri = adapter.requests.single.uri;
    expect(uri.host, 'api.open-meteo.com');
    expect(uri.path, '/v1/forecast');
    expect(uri.queryParameters['latitude'], '7.29');
    expect(uri.queryParameters['longitude'], '80.63');
    expect(uri.queryParameters['timezone'], 'Asia/Colombo');
    expect(uri.queryParameters['forecast_days'], '7');
    expect(uri.queryParameters['hourly'], 'precipitation_probability');
    expect(uri.queryParameters['current'], contains('temperature_2m'));
    expect(uri.queryParameters['daily'], contains('precipitation_probability_max'));
    expect(uri.queryParameters.keys, isNot(contains('apikey')), reason: 'keyless API');
  });

  test('a connection failure becomes a NetworkException', () {
    final adapter = _FakeAdapter(
      (options) => throw DioException.connectionError(requestOptions: options, reason: 'offline'),
    );
    expect(repoWith(adapter).fetch(_kandy), throwsA(isA<NetworkException>()));
  });

  test('a server error becomes a NetworkException', () {
    final adapter = _FakeAdapter((_) => ResponseBody.fromString('oops', 500));
    expect(repoWith(adapter).fetch(_kandy), throwsA(isA<NetworkException>()));
  });

  test('an unusable payload still surfaces as an AppException', () {
    final adapter = _FakeAdapter(
      (_) => ResponseBody.fromString(
        jsonEncode({'error': true, 'reason': 'bad request'}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
    expect(repoWith(adapter).fetch(_kandy), throwsA(isA<AppException>()));
  });

  test('savedAt is null when nothing is cached', () {
    final repo = repoWith(_FakeAdapter((_) => ResponseBody.fromString('', 200)));
    expect(repo.savedAt(_kandy), isNull);
  });
}
