import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cuaca_screen.dart';
import 'profile_screen.dart';
import 'pembelian_user.dart';
import 'jadwal_user_screen.dart';
import '../services/jadwal_service.dart';
import '../model/jadwal_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Start with home (center button)

  final List<Widget> _screens = [
    const CuacaScreen(),
    const HomeDashboard(),
    const ProfileScreen(),
    const PembelianScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  label: 'Beranda',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Cuaca',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Pembelian',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  index: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00897B).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF00897B)
                  : const Color(0xFF9CA3AF),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF00897B)
                    : const Color(0xFF9CA3AF),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Home Dashboard Widget (the main content)
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final JadwalService _jadwalService = JadwalService();
  List<JadwalModel> _upcomingSchedules = [];
  bool _isLoading = true;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserAndSchedules();
  }

  Future<void> _loadUserAndSchedules() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('userName') ?? '';

      print('Loading schedules for user: $_userName');

      if (_userName.isNotEmpty) {
        final schedules = await _jadwalService.getJadwalByUser(_userName);

        // Sort by date and time to show upcoming schedules first
        schedules.sort((a, b) {
          final dateCompare = a.tanggal.compareTo(b.tanggal);
          if (dateCompare != 0) return dateCompare;
          return a.waktu.compareTo(b.waktu);
        });

        setState(() {
          _upcomingSchedules = schedules.take(3).toList(); // Show only next 3 schedules
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading schedules: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Jaga Lansia',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF2D3748)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/grandparents.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00897B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.elderly,
                      color: Color(0xFF00897B),
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF00897B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00897B).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat Datang!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pantau kesehatan lansia dengan mudah',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image.asset(
                        'assets/grandparents.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.elderly,
                            size: 40,
                            color: Color(0xFF00897B),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Menu Utama',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildMenuCard(
                  icon: Icons.monitor_heart_outlined,
                  title: 'Monitoring',
                  color: const Color(0xFFFF6B9D),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MonitoringScreen()),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Jadwal',
                  color: const Color(0xFF4FACFE),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const JadwalUserScreen()),
                    );
                    // Reload schedules when returning from jadwal screen
                    _loadUserAndSchedules();
                  },
                ),
                _buildMenuCard(
                  icon: Icons.medical_services_outlined,
                  title: 'Kesehatan',
                  color: const Color(0xFF43E97B),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const KesehatanScreen()),
                    );
                  },
                ),
                _buildMenuCard(
                  icon: Icons.history_outlined,
                  title: 'Riwayat',
                  color: const Color(0xFFFFA726),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RiwayatScreen()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Upcoming Schedules Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jadwal Mendatang',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                if (_upcomingSchedules.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const JadwalUserScreen()),
                      );
                      _loadUserAndSchedules();
                    },
                    child: const Text('Lihat Semua'),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _upcomingSchedules.isEmpty
                    ? Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada jadwal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tambahkan jadwal untuk pengingat kegiatan Anda',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const JadwalUserScreen()),
                                  );
                                  _loadUserAndSchedules();
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Tambah Jadwal'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00897B),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: _upcomingSchedules.map((schedule) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF4FACFE).withOpacity(0.1),
                                    Colors.white,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4FACFE).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.event,
                                    color: Color(0xFF4FACFE),
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  schedule.kegiatan,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          schedule.tanggal,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          schedule.waktu,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    if (schedule.keterangan.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        schedule.keterangan,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const JadwalUserScreen()),
                                  );
                                  _loadUserAndSchedules();
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 36,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Dummy Screens (placed in this file per request) -----------------

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  int currentBpm = 72;
  final List<int> bpmHistory = [72];
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Initialize with some starting data
    for (int i = 0; i < 10; i++) {
      bpmHistory.add(60 + _random.nextInt(30));
    }

    // Start real-time monitoring - update every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        // Generate realistic BPM values between 50-100
        // Use previous value to create smoother transitions
        int change = _random.nextInt(7) - 3; // -3 to +3
        currentBpm = (currentBpm + change).clamp(50, 100);

        bpmHistory.add(currentBpm);

        // Keep only last 20 readings for the graph
        if (bpmHistory.length > 20) {
          bpmHistory.removeAt(0);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _getBpmStatus() {
    if (currentBpm < 60) return 'Di bawah rata-rata';
    if (currentBpm > 90) return 'Di atas rata-rata';
    return 'Normal';
  }

  Color _getBpmColor() {
    if (currentBpm < 60) return Colors.orange;
    if (currentBpm > 90) return Colors.red;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text('Monitoring Real-Time'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.circle, color: Colors.red, size: 8),
                    SizedBox(width: 6),
                    Text('LIVE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current BPM Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getBpmColor().withOpacity(0.1),
                      _getBpmColor().withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite, color: _getBpmColor(), size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'Denyut Jantung',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        '$currentBpm',
                        key: ValueKey<int>(currentBpm),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _getBpmColor(),
                        ),
                      ),
                    ),
                    const Text(
                      'BPM',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getBpmColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getBpmStatus(),
                        style: TextStyle(
                          color: _getBpmColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Graph Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.show_chart, color: Color(0xFF00897B)),
                        SizedBox(width: 8),
                        Text(
                          'Grafik Real-Time',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Perubahan BPM dalam 20 pembacaan terakhir',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 10,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(0.2),
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 5,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                reservedSize: 35,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          minX: 0,
                          maxX: (bpmHistory.length - 1).toDouble(),
                          minY: 40,
                          maxY: 110,
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                bpmHistory.length,
                                (index) => FlSpot(
                                  index.toDouble(),
                                  bpmHistory[index].toDouble(),
                                ),
                              ),
                              isCurved: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF00897B),
                                  const Color(0xFF00897B).withOpacity(0.5),
                                ],
                              ),
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: index == bpmHistory.length - 1 ? 5 : 2,
                                    color: index == bpmHistory.length - 1
                                        ? Colors.red
                                        : const Color(0xFF00897B),
                                    strokeWidth: 2,
                                    strokeColor: Colors.white,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF00897B).withOpacity(0.3),
                                    const Color(0xFF00897B).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Statistics Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.analytics_outlined, color: Color(0xFF00897B)),
                        SizedBox(width: 8),
                        Text(
                          'Statistik',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          'Min',
                          '${bpmHistory.reduce((a, b) => a < b ? a : b)}',
                          Colors.blue,
                        ),
                        _buildStatItem(
                          'Rata-rata',
                          '${(bpmHistory.reduce((a, b) => a + b) / bpmHistory.length).round()}',
                          const Color(0xFF00897B),
                        ),
                        _buildStatItem(
                          'Max',
                          '${bpmHistory.reduce((a, b) => a > b ? a : b)}',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Data ini adalah simulasi monitoring real-time dengan nilai BPM yang berubah setiap 2 detik.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const Text(
          'BPM',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class JadwalScreen extends StatelessWidget {
  const JadwalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy medicine schedule
    final schedules = [
      {'name': 'Paracetamol 500mg', 'time': '08:00'},
      {'name': 'Amlodipine 5mg', 'time': '12:00'},
      {'name': 'Vitamin D', 'time': '18:00'},
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF00897B), title: const Text('Jadwal')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Jadwal Minum Obat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: schedules.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final s = schedules[i];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.medication, color: Color(0xFF00897B)),
                      title: Text(s['name']!),
                      trailing: Text(s['time']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KesehatanScreen extends StatelessWidget {
  const KesehatanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy health status
    final items = [
      {'label': 'Tekanan Darah', 'value': '120/80 mmHg'},
      {'label': 'Gula Darah', 'value': '110 mg/dL'},
      {'label': 'Berat Badan', 'value': '62 kg'},
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF00897B), title: const Text('Kesehatan')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Status Kesehatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...items.map((it) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.health_and_safety, color: Color(0xFF00897B)),
                title: Text(it['label']!),
                trailing: Text(it['value']!),
              ),
            )).toList(),
            const SizedBox(height: 12),
            const Text('Catatan: Data ini bersifat dummy untuk tampilan.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final history = [
      {'title': 'Kontrol ke Puskesmas', 'date': '2025-12-10'},
      {'title': 'Minum Obat (Amlodipine)', 'date': '2025-12-11'},
      {'title': 'Pemeriksaan Gula Darah', 'date': '2025-12-12'},
    ];

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF00897B), title: const Text('Riwayat')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemCount: history.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, i) {
            final h = history[i];
            return ListTile(
              leading: const Icon(Icons.history, color: Color(0xFF00897B)),
              title: Text(h['title']!),
              subtitle: Text(h['date']!),
            );
          },
        ),
      ),
    );
  }
}

