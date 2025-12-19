import 'package:flutter/material.dart';
import 'cuaca_screen.dart';
import 'profile_screen.dart';
import 'pembelian_user.dart';

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
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({Key? key}) : super(key: key);

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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const JadwalScreen()),
                    );
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

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy current BPM and recent readings
    const int currentBpm = 58; // dummy
    final status = currentBpm < 60 ? 'Di bawah rata-rata' : 'Normal';
    final recent = [
      {'bpm': 58, 'time': '08:12'},
      {'bpm': 62, 'time': '07:00'},
      {'bpm': 70, 'time': '06:30'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text('Monitoring'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Denyut Jantung Saat Ini', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('$currentBpm BPM', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(status, style: TextStyle(color: currentBpm < 60 ? Colors.orange : Colors.green)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Pembacaan Terakhir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: recent.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final r = recent[i];
                  return ListTile(
                    leading: const Icon(Icons.favorite, color: Color(0xFF00897B)),
                    title: Text('${r['bpm']} BPM'),
                    subtitle: Text('Waktu: ${r['time']}'),
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

