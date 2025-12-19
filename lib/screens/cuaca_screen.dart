import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../model/weather_model.dart';

class CuacaScreen extends StatefulWidget {
  const CuacaScreen({Key? key}) : super(key: key);

  @override
  State<CuacaScreen> createState() => _CuacaScreenState();
}

class _CuacaScreenState extends State<CuacaScreen> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _currentWeather;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    final weather = await _weatherService.getCurrentWeatherWithRetry();

    if (mounted) {
      setState(() {
        _currentWeather = weather;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getWeatherGradient(),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : _currentWeather == null
                  ? _buildErrorState()
                  : _buildWeatherContent(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off,
            color: Colors.white,
            size: 80,
          ),
          const SizedBox(height: 20),
          const Text(
            'Gagal memuat data cuaca',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tidak dapat terhubung ke server BMKG',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _fetchWeather,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4A90E2),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cuaca Hari Ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _fetchWeather,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                    size: 28,
                  ),
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Weather Icon
          Text(
            _currentWeather!.getWeatherIcon(),
            style: const TextStyle(fontSize: 120),
          ),
          const SizedBox(height: 30),
          // Location
          Text(
            _currentWeather!.locationName ?? 'Bandung',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _currentWeather!.province ?? 'Jawa Barat',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 40),
          // Temperature
          Text(
            _currentWeather!.getTemperatureDisplay(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _currentWeather!.weatherDescription ?? 'Memuat...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          // Weather Details Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildWeatherDetailCard(
                        Icons.water_drop,
                        'Kelembaban',
                        _currentWeather!.getHumidityDisplay(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildWeatherDetailCard(
                        Icons.air,
                        'Angin',
                        '${_currentWeather!.windSpeed ?? '--'} km/h',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildWeatherDetailCard(
                  Icons.explore,
                  'Arah Angin',
                  _currentWeather!.windDirection ?? '--',
                  fullWidth: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Info Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  'Data Cuaca Real-Time',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Informasi cuaca diperbarui secara berkala dari Badan Meteorologi, Klimatologi, dan Geofisika (BMKG) Indonesia untuk wilayah Bandung.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Sumber: BMKG Indonesia',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailCard(
    IconData icon,
    String label,
    String value, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: fullWidth
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 30),
                    const SizedBox(width: 15),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Icon(icon, color: Colors.white, size: 35),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  List<Color> _getWeatherGradient() {
    if (_currentWeather == null) {
      return [const Color(0xFF4A90E2), const Color(0xFF357ABD)];
    }

    final code = int.tryParse(_currentWeather!.weatherCode ?? '0') ?? 0;

    // Cerah
    if (code == 0) {
      return [const Color(0xFFFFA726), const Color(0xFFFF7043)];
    }
    // Cerah Berawan
    if (code == 1 || code == 2) {
      return [const Color(0xFF5DADE2), const Color(0xFF3498DB)];
    }
    // Berawan
    if (code == 3 || code == 4) {
      return [const Color(0xFF78909C), const Color(0xFF546E7A)];
    }
    // Hujan
    if (code >= 60 && code <= 97) {
      return [const Color(0xFF5C6BC0), const Color(0xFF3949AB)];
    }

    // Default
    return [const Color(0xFF4A90E2), const Color(0xFF357ABD)];
  }
}

