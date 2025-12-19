class WeatherModel {
  final String? locationName;
  final String? province;
  final String? temperature;
  final String? humidity;
  final String? weatherDescription;
  final String? weatherCode;
  final String? windSpeed;
  final String? windDirection;
  final DateTime? timestamp;

  WeatherModel({
    this.locationName,
    this.province,
    this.temperature,
    this.humidity,
    this.weatherDescription,
    this.weatherCode,
    this.windSpeed,
    this.windDirection,
    this.timestamp,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse BMKG API response structure
      final data = json['data'];
      if (data != null && data.isNotEmpty) {
        final location = data[0];
        final lokasi = location['lokasi'];
        final cuaca = location['cuaca'];

        // Get current weather (first forecast)
        if (cuaca != null && cuaca.isNotEmpty) {
          final currentWeather = cuaca[0];

          return WeatherModel(
            locationName: lokasi?['kecamatan'] ?? lokasi?['kota'] ?? 'Unknown',
            province: lokasi?['provinsi'] ?? 'Unknown',
            temperature: currentWeather['t']?.toString(),
            humidity: currentWeather['hu']?.toString(),
            weatherDescription: currentWeather['weather_desc'] ?? 'Unknown',
            weatherCode: currentWeather['weather']?.toString(),
            windSpeed: currentWeather['ws']?.toString(),
            windDirection: currentWeather['wd_to'] ?? currentWeather['wd'],
            timestamp: currentWeather['local_datetime'] != null
                ? DateTime.tryParse(currentWeather['local_datetime'])
                : DateTime.now(),
          );
        }
      }

      return WeatherModel();
    } catch (e) {
      print('Error parsing weather data: $e');
      return WeatherModel();
    }
  }

  String getWeatherIcon() {
    // Map BMKG weather codes to icons
    if (weatherCode == null) return '🌡️';

    final code = int.tryParse(weatherCode!) ?? 0;

    // BMKG weather codes mapping
    if (code == 0) return '☀️'; // Cerah
    if (code == 1 || code == 2) return '⛅'; // Cerah Berawan
    if (code == 3) return '☁️'; // Berawan
    if (code == 4) return '🌥️'; // Berawan Tebal
    if (code >= 60 && code <= 63) return '🌧️'; // Hujan Ringan-Sedang
    if (code >= 95 && code <= 97) return '⛈️'; // Hujan Petir
    if (code == 5) return '🌫️'; // Kabut

    return '🌤️'; // Default
  }

  String getTemperatureDisplay() {
    if (temperature == null) return '--°C';
    return '${temperature}°C';
  }

  String getHumidityDisplay() {
    if (humidity == null) return '--%';
    return '${humidity}%';
  }
}

