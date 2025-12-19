import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

class WeatherService {
  // Bandung region code - Bandung Wetan
  static const String _bandungCode = '32.73.08.1001';
  static const String _baseUrl = 'https://api.bmkg.go.id/publik/prakiraan-cuaca';

  Future<WeatherModel?> getCurrentWeather() async {
    try {
      final url = Uri.parse('$_baseUrl?adm4=$_bandungCode');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return WeatherModel.fromJson(jsonData);
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
}

