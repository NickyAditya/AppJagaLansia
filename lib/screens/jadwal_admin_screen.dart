import 'package:flutter/material.dart';
import '../services/jadwal_service.dart';
import '../model/jadwal_model.dart';

class JadwalAdminScreen extends StatefulWidget {
  const JadwalAdminScreen({Key? key}) : super(key: key);

  @override
  State<JadwalAdminScreen> createState() => _JadwalAdminScreenState();
}

class _JadwalAdminScreenState extends State<JadwalAdminScreen> {
  final JadwalService _jadwalService = JadwalService();
  List<JadwalModel> _jadwalList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllJadwal();
  }

  Future<void> _loadAllJadwal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final jadwalList = await _jadwalService.getAllJadwal();

      setState(() {
        _jadwalList = jadwalList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _updateStatus(String id, String newStatus) async {
    try {
      final response = await _jadwalService.updateJadwal(
        id: id,
        field: 'keterangan',
        value: newStatus,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: response['success'] ? Colors.green : Colors.red,
          ),
        );
      }

      if (response['success']) {
        _loadAllJadwal();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _showStatusDialog(JadwalModel jadwal) async {
    String? selectedStatus = jadwal.keterangan;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kegiatan: ${jadwal.kegiatan}'),
              Text('Tanggal: ${jadwal.tanggal}'),
              Text('Waktu: ${jadwal.waktu}'),
              const SizedBox(height: 16),
              const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: const [
                  DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'Tertunda', child: Text('Tertunda')),
                  DropdownMenuItem(value: 'Diterima', child: Text('Diterima')),
                  DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                ],
                onChanged: (value) {
                  setDialogState(() {
                    selectedStatus = value;
                  });
                },
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
                if (selectedStatus != null) {
                  _updateStatus(jadwal.id, selectedStatus!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String keterangan) {
    switch (keterangan.toLowerCase()) {
      case 'pending':
      case 'tertunda':
        return Colors.orange;
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconForKegiatan(String kegiatan) {
    final kegiatanLower = kegiatan.toLowerCase();
    if (kegiatanLower.contains('rujuk')) {
      return Icons.local_hospital;
    } else if (kegiatanLower.contains('obat')) {
      return Icons.medication;
    } else if (kegiatanLower.contains('olahraga')) {
      return Icons.fitness_center;
    } else if (kegiatanLower.contains('makan')) {
      return Icons.restaurant;
    } else {
      return Icons.event_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text('Kelola Jadwal User'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _jadwalList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada jadwal dari user',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadAllJadwal,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _jadwalList.length,
                    itemBuilder: (context, index) {
                      final jadwal = _jadwalList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00897B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getIconForKegiatan(jadwal.kegiatan),
                              color: const Color(0xFF00897B),
                              size: 28,
                            ),
                          ),
                          title: Text(
                            jadwal.kegiatan,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(jadwal.tanggal),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(jadwal.waktu),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(jadwal.keterangan).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      jadwal.keterangan,
                                      style: TextStyle(
                                        color: _getStatusColor(jadwal.keterangan),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xFF00897B)),
                            onPressed: () => _showStatusDialog(jadwal),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
