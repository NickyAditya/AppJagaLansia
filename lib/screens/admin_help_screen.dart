import 'package:flutter/material.dart';

class AdminHelpScreen extends StatelessWidget {
  const AdminHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bantuan & Dokumentasi Admin',
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
                  Icon(Icons.admin_panel_settings, color: Colors.white, size: 48),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halaman Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Panduan lengkap untuk administrator',
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

            // Dokumentasi Section
            _buildSectionTitle('Dokumentasi'),
            const SizedBox(height: 12),
            _buildDocumentationCard(
              'Kelola Pengguna',
              'Sebagai admin, Anda dapat mengelola semua pengguna dalam sistem:',
              [
                'Menambah pengguna baru (admin atau user biasa)',
                'Mengedit informasi pengguna (username, email, password)',
                'Menghapus pengguna dari sistem',
                'Melihat statistik total pengguna',
              ],
              Icons.people,
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildDocumentationCard(
              'Kelola Obat',
              'Admin dapat mengelola data obat untuk lansia:',
              [
                'Menambah data obat baru',
                'Mengedit informasi obat',
                'Menghapus data obat',
                'Memantau stok dan informasi obat',
              ],
              Icons.medical_services,
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildDocumentationCard(
              'Kelola Transaksi',
              'Pantau dan kelola transaksi pembelian obat:',
              [
                'Melihat semua transaksi pengguna',
                'Menambah transaksi baru',
                'Mengedit data transaksi',
                'Menghapus transaksi',
              ],
              Icons.shopping_cart,
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildDocumentationCard(
              'Kelola Jadwal',
              'Mengelola jadwal aktivitas pengguna:',
              [
                'Melihat semua jadwal pengguna',
                'Mengupdate status jadwal (Pending, Diterima, Ditolak)',
                'Memantau jadwal rujuk yang memerlukan perhatian',
                'Memberikan catatan pada jadwal',
              ],
              Icons.calendar_today,
              Colors.purple,
            ),
            const SizedBox(height: 12),
            _buildDocumentationCard(
              'Dashboard',
              'Memantau statistik dan aktivitas sistem:',
              [
                'Melihat total pengguna (admin dan regular user)',
                'Memantau aktivitas terkini',
                'Akses cepat ke fitur utama',
                'Refresh data real-time',
              ],
              Icons.dashboard,
              Colors.teal,
            ),
            const SizedBox(height: 24),

            // Support Section
            _buildSectionTitle('Our Developer Team'),
            const SizedBox(height: 12),
            _buildSupportCard(
              'Developer 1',
              '152023065 - Nicky Aditya Bagus',
              Icons.person,
              Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildSupportCard(
              'Developer 2',
              '152023046 - Rafi Syahrulfalah',
              Icons.person,
              Colors.green,
            ),
            const SizedBox(height: 24),

            // Tips Section
            _buildSectionTitle('Tips & Best Practices'),
            const SizedBox(height: 12),
            _buildTipCard(
              'Keamanan Data',
              'Selalu logout setelah selesai menggunakan aplikasi, terutama jika menggunakan perangkat bersama.',
              Icons.security,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              'Backup Data',
              'Lakukan refresh data secara berkala untuk memastikan data yang ditampilkan adalah yang terbaru.',
              Icons.backup,
            ),
            const SizedBox(height: 8),
            _buildTipCard(
              'Monitoring Jadwal Rujuk',
              'Periksa pengingat jadwal rujuk secara rutin untuk memastikan pasien mendapat penanganan tepat waktu.',
              Icons.notification_important,
            ),
            const SizedBox(height: 24),

            // Version Info
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

  Widget _buildDocumentationCard(
    String title,
    String description,
    List<String> features,
    IconData icon,
    Color color,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSupportCard(String title, String value, IconData icon, Color color) {
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
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon) {
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

