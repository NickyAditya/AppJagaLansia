import 'package:flutter/material.dart';

class UserHelpScreen extends StatelessWidget {
  const UserHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bantuan & Panduan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00897B),
                    const Color(0xFF00897B).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00897B).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 48),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Panduan menggunakan aplikasi Jaga Lansia',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tutorial Section
            _buildSectionTitle('Tutorial Penggunaan'),
            const SizedBox(height: 12),
            _buildTutorialCard(
              number: '1',
              title: 'Login ke Aplikasi',
              description: 'Masukkan username dan password Anda untuk masuk ke aplikasi. Jika belum memiliki akun, hubungi admin untuk pendaftaran.',
              icon: Icons.login,
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildTutorialCard(
              number: '2',
              title: 'Gunakan Dashboard',
              description: 'Setelah login, Anda akan masuk ke halaman utama (Home) yang menampilkan monitoring kesehatan dan fitur-fitur yang tersedia.',
              icon: Icons.dashboard,
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildTutorialCard(
              number: '3',
              title: 'Kelola Data Anda',
              description: 'Gunakan menu navigasi di bawah untuk mengakses berbagai fitur seperti Jadwal, Kesehatan, dan Riwayat.',
              icon: Icons.explore,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),

            // Fitur Section
            _buildSectionTitle('Fitur Aplikasi'),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.home,
              title: 'Home / Monitoring',
              description: 'Pantau kondisi kesehatan real-time seperti detak jantung (BPM) dan grafik perubahan. Lihat juga jadwal terdekat yang perlu dilakukan.',
              color: const Color(0xFF00897B),
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.calendar_today,
              title: 'Jadwal',
              description: 'Kelola jadwal aktivitas Anda seperti minum obat, kontrol kesehatan, atau rujukan ke dokter. Tambah, edit, atau hapus jadwal sesuai kebutuhan.',
              color: Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.favorite,
              title: 'Kesehatan',
              description: 'Lihat informasi cuaca terkini untuk membantu Anda merencanakan aktivitas harian. Pantau suhu dan kondisi cuaca di lokasi Anda.',
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.history,
              title: 'Riwayat',
              description: 'Lihat riwayat transaksi pembelian obat dan pengeluaran kesehatan Anda. Tambahkan transaksi baru atau kelola data yang sudah ada.',
              color: Colors.indigo,
            ),
            const SizedBox(height: 12),
            _buildFeatureCard(
              icon: Icons.person,
              title: 'Profil',
              description: 'Kelola informasi profil Anda. Edit username dan password. Lihat informasi akun dan keluar dari aplikasi.',
              color: Colors.teal,
            ),
            const SizedBox(height: 24),

            // Tips Section
            _buildSectionTitle('Tips & Saran'),
            const SizedBox(height: 12),
            _buildTipCard(
              icon: Icons.notifications_active,
              title: 'Perhatikan Jadwal Anda',
              description: 'Selalu cek jadwal di halaman Home untuk melihat aktivitas yang akan segera dilakukan.',
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              icon: Icons.security,
              title: 'Jaga Keamanan Akun',
              description: 'Jangan bagikan password Anda kepada siapapun. Logout setelah selesai menggunakan aplikasi.',
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              icon: Icons.update,
              title: 'Update Data Secara Berkala',
              description: 'Pastikan jadwal dan data kesehatan Anda selalu up-to-date untuk monitoring yang lebih baik.',
            ),
            const SizedBox(height: 24),

            // Contact Support
            _buildSectionTitle('Butuh Bantuan Lebih Lanjut?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.support_agent,
                    color: Color(0xFF00897B),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hubungi Tim Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00897B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Jika Anda mengalami kesulitan atau memiliki pertanyaan, silakan hubungi kami:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(Icons.email, 'support@jagalansia.com'),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.phone, '+62 812-3456-7890'),
                  const SizedBox(height: 8),
                  _buildContactRow(Icons.access_time, 'Senin - Jumat: 08:00 - 17:00 WIB'),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00897B),
      ),
    );
  }

  Widget _buildTutorialCard({
    required String number,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber.shade700, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.amber.shade900,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF00897B), size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

