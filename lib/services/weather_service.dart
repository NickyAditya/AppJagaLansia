import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

class WeatherService {
  // OpenWeatherMap configuration
  static const String _openWeatherBase = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;
  final String city; // e.g. 'Bandung,id'

  WeatherService({required this.apiKey, this.city = 'Bandung,id'});

  /// Fetch current weather from OpenWeatherMap and map it into the existing
  /// WeatherModel (so we don't need to change other files/models).
  Future<WeatherModel?> getCurrentWeather() async {
    try {
      final url = Uri.parse('$_openWeatherBase?q=$city&units=metric&appid=$apiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Extract fields from OpenWeatherMap response and convert to the
        // WeatherModel constructor used elsewhere in the app.
        final locationName = (jsonData['name'] as String?) ?? 'Unknown';
        final province = null; // OWM does not provide province; leave null

        final temp = (jsonData['main']?['temp'] as num?)?.toDouble();
        final temperature = temp != null ? temp.toStringAsFixed(0) : null;

        final humidityVal = jsonData['main']?['humidity'];
        final humidity = humidityVal != null ? humidityVal.toString() : null;

        final weatherList = jsonData['weather'] as List<dynamic>?;
        final weatherDesc = (weatherList != null && weatherList.isNotEmpty)
            ? (weatherList[0]['description'] as String?)
            : null;
        final weatherCode = (weatherList != null && weatherList.isNotEmpty)
            ? (weatherList[0]['id']?.toString())
            : null;

        final windSpeedVal = (jsonData['wind']?['speed'] as num?)?.toDouble();
        // keep wind speed as m/s string to avoid changing other parts of app
        final windSpeed = windSpeedVal != null ? windSpeedVal.toString() : null;

        final windDeg = jsonData['wind']?['deg'];
        final windDirection = windDeg != null ? _degToCompass(windDeg as num) : null;

        final dt = jsonData['dt'];
        final timestamp = dt != null
            ? DateTime.fromMillisecondsSinceEpoch((dt as int) * 1000, isUtc: true).toLocal()
            : DateTime.now();

        return WeatherModel(
          locationName: locationName,
          province: province,
          temperature: temperature,
          humidity: humidity,
          weatherDescription: weatherDesc,
          weatherCode: weatherCode,
          windSpeed: windSpeed,
          windDirection: windDirection,
          timestamp: timestamp,
        );
      } else {
        print('Failed to load weather data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather: $e');
      return null;
    }
  }

  Future<WeatherModel?> getCurrentWeatherWithRetry({int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      final weather = await getCurrentWeather();
      if (weather != null) {
        return weather;
      }

      if (i < maxRetries - 1) {
        await Future.delayed(Duration(seconds: 2));
      }
    }
    return null;
  }

  // Helper: convert wind degrees into a compass direction string (e.g., 'N', 'NE')
  static String _degToCompass(num deg) {
    final d = deg % 360;
    if (d < 0) return 'N';
    const directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];
    final idx = ((d / 22.5) + 0.5).floor() % 16;
    return directions[idx];
  }
}
