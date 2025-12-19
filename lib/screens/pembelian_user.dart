import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/obat_service.dart';
import '../services/transaksi_service.dart';
import '../model/obat_model.dart';
import '../model/transaksi_model.dart';

class PembelianScreen extends StatefulWidget {
  const PembelianScreen({super.key});

  @override
  State<PembelianScreen> createState() => _PembelianScreenState();
}

class _PembelianScreenState extends State<PembelianScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ObatService _obatService = ObatService();
  final TransaksiService _transaksiService = TransaksiService();

  List<ObatModel> _obatList = [];
  List<TransaksiModel> _transaksiUser = [];
  bool _isLoading = true;
  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Get user info from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';

    // Load obat dan transaksi user
    await _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      _obatService.getAllObat(),
      _transaksiService.getAllTransaksi(),
    ]);

    setState(() {
      _obatList = results[0] as List<ObatModel>;
      // Filter transaksi HANYA untuk user yang sedang login
      final allTransaksi = results[1] as List<TransaksiModel>;
      final currentUser = _userName.isNotEmpty ? _userName : _userEmail;

      print('Current user: $currentUser'); // Debug
      print('All transactions: ${allTransaksi.length}'); // Debug

      _transaksiUser = allTransaksi.where((t) {
        print('Checking transaction: ${t.nama_user} vs $currentUser'); // Debug
        return t.nama_user == currentUser;
      }).toList();

      print('Filtered transactions for user: ${_transaksiUser.length}'); // Debug
      _isLoading = false;
    });
  }

  Future<void> _beliObat(ObatModel obat, int jumlah) async {
    if (jumlah < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah pembelian minimal 1'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Pastikan user sudah login
    final currentUser = _userName.isNotEmpty ? _userName : _userEmail;
    if (currentUser.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User tidak ditemukan. Silakan login kembali.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hitung total harga
    final hargaSatuan = int.tryParse(obat.harga) ?? 0;
    final totalHarga = hargaSatuan * jumlah;

    // Konfirmasi pembelian
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Pembelian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Obat: ${obat.nama_obat}'),
            const SizedBox(height: 8),
            Text('Jumlah: $jumlah'),
            const SizedBox(height: 8),
            Text('Total: Rp ${totalHarga.toString()}'),
            const SizedBox(height: 16),
            const Text('Apakah Anda yakin ingin membeli obat ini?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
            ),
            child: const Text('Beli', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      print('Buying medicine for user: $currentUser'); // Debug

      final response = await _transaksiService.addTransaksi(
        namaObat: obat.nama_obat,
        namaUser: currentUser, // Gunakan currentUser yang sudah dipastikan tidak kosong
        jumlahDibeli: jumlah.toString(),
        totalHarga: totalHarga.toString(),
        statusPembelian: 'Pending',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response['success'] ? Colors.green : Colors.red,
        ),
      );

      if (response['success']) {
        await _loadData();
        // Pindah ke tab Obat Dimiliki
        _tabController.animateTo(1);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembelian Obat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00897B),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.shopping_bag),
              text: 'Pembelian',
            ),
            Tab(
              icon: Icon(Icons.inventory),
              text: 'Obat Dimiliki',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPembelianTab(),
          _buildObatDimilikiTab(),
        ],
      ),
    );
  }

  Widget _buildPembelianTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00897B)),
            )
          : _obatList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medical_services_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada obat tersedia',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _obatList.length,
                  itemBuilder: (context, index) {
                    final obat = _obatList[index];
                    return _buildObatCard(obat);
                  },
                ),
    );
  }

  Widget _buildObatCard(ObatModel obat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Color(0xFF00897B),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        obat.nama_obat,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${obat.harga}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    obat.dosis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (obat.keterangan.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      obat.keterangan,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _showBeliDialog(obat),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: const Text('Beli Obat', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBeliDialog(ObatModel obat) {
    int jumlah = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final hargaSatuan = int.tryParse(obat.harga) ?? 0;
          final totalHarga = hargaSatuan * jumlah;

          return AlertDialog(
            title: Text(obat.nama_obat),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rp ${obat.harga} / item',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (jumlah > 1) {
                          setDialogState(() {
                            jumlah--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove_circle),
                      color: const Color(0xFF00897B),
                      iconSize: 36,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        jumlah.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setDialogState(() {
                          jumlah++;
                        });
                      },
                      icon: const Icon(Icons.add_circle),
                      color: const Color(0xFF00897B),
                      iconSize: 36,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00897B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Harga:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Rp ${totalHarga.toString()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00897B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _beliObat(obat, jumlah);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                ),
                child: const Text('Beli Sekarang', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildObatDimilikiTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00897B)),
            )
          : _transaksiUser.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada transaksi',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Beli obat di tab Pembelian',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _transaksiUser.length,
                  itemBuilder: (context, index) {
                    final transaksi = _transaksiUser[index];
                    return _buildTransaksiCard(transaksi);
                  },
                ),
    );
  }

  Widget _buildTransaksiCard(TransaksiModel transaksi) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (transaksi.status_pembelian) {
      case 'Berhasil':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Berhasil';
        break;
      case 'Gagal':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Gagal';
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'Pending';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaksi.nama_obat,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jumlah',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transaksi.jumlah_dibeli} item',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Harga',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${transaksi.total_harga}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00897B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

