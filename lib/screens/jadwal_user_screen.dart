import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/jadwal_service.dart';
import '../model/jadwal_model.dart';
import 'package:intl/intl.dart';

class JadwalUserScreen extends StatefulWidget {
  const JadwalUserScreen({Key? key}) : super(key: key);

  @override
  State<JadwalUserScreen> createState() => _JadwalUserScreenState();
}

class _JadwalUserScreenState extends State<JadwalUserScreen> {
  final JadwalService _jadwalService = JadwalService();
  List<JadwalModel> _jadwalList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  Future<void> _loadJadwal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName') ?? '';

      if (userName.isEmpty) {
        setState(() {
          _jadwalList = [];
          _isLoading = false;
        });
        return;
      }

      print('Loading jadwal for userName: $userName');

      final jadwalList = await _jadwalService.getJadwalByUser(userName);

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

  Future<void> _showAddEditDialog({JadwalModel? jadwal}) async {
    final isEdit = jadwal != null;
    final tanggalController = TextEditingController(text: jadwal?.tanggal ?? '');
    final waktuController = TextEditingController(text: jadwal?.waktu ?? '');
    final kegiatanController = TextEditingController(text: jadwal?.kegiatan ?? '');
    
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    if (isEdit && jadwal.tanggal.isNotEmpty) {
      try {
        final parts = jadwal.tanggal.split('/');
        if (parts.length == 3) {
          selectedDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        // ignore
      }
    }

    if (isEdit && jadwal.waktu.isNotEmpty) {
      try {
        final parts = jadwal.waktu.split('.');
        if (parts.length == 2) {
          selectedTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      } catch (e) {
        // ignore
      }
    }

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Jadwal' : 'Tambah Jadwal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tanggal
                TextField(
                  controller: tanggalController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setDialogState(() {
                        selectedDate = date;
                        tanggalController.text = DateFormat('dd/MM/yyyy').format(date);
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Waktu
                TextField(
                  controller: waktuController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Waktu',
                    suffixIcon: Icon(Icons.access_time),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setDialogState(() {
                        selectedTime = time;
                        waktuController.text = '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Kegiatan
                TextField(
                  controller: kegiatanController,
                  decoration: const InputDecoration(
                    labelText: 'Kegiatan (rujuk, minum obat, olahraga, dll)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (tanggalController.text.isEmpty ||
                    waktuController.text.isEmpty ||
                    kegiatanController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }

                Navigator.pop(context);

                if (isEdit) {
                  await _updateJadwal(
                    jadwal!.id,
                    tanggalController.text,
                    waktuController.text,
                    kegiatanController.text,
                  );
                } else {
                  await _addJadwal(
                    tanggalController.text,
                    waktuController.text,
                    kegiatanController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
              ),
              child: Text(isEdit ? 'Update' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addJadwal(String tanggal, String waktu, String kegiatan) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userName = prefs.getString('userName') ?? '';

      if (userName.isEmpty) {
        throw Exception('User tidak ditemukan, silahkan login kembali');
      }

      print('Adding jadwal for userName: $userName');

      final response = await _jadwalService.addJadwal(
        tanggal: tanggal,
        waktu: waktu,
        kegiatan: kegiatan,
        keterangan: 'Pending',
        userName: userName,
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
        _loadJadwal();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _updateJadwal(String id, String tanggal, String waktu, String kegiatan) async {
    try {
      // Update tanggal
      await _jadwalService.updateJadwal(
        id: id,
        field: 'tanggal',
        value: tanggal,
      );
      
      // Update waktu
      await _jadwalService.updateJadwal(
        id: id,
        field: 'waktu',
        value: waktu,
      );
      
      // Update kegiatan
      await _jadwalService.updateJadwal(
        id: id,
        field: 'kegiatan',
        value: kegiatan,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil diupdate')),
        );
      }
      _loadJadwal();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteJadwal(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await _jadwalService.deleteJadwal(id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message']),
              backgroundColor: response['success'] ? Colors.green : Colors.red,
            ),
          );
        }

        if (response['success']) {
          _loadJadwal();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B),
        title: const Text('Jadwal Saya'),
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
                        'Belum ada jadwal',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap tombol + untuk menambah jadwal',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadJadwal,
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
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showAddEditDialog(jadwal: jadwal);
                              } else if (value == 'delete') {
                                _deleteJadwal(jadwal.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Hapus', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: const Color(0xFF00897B),
        child: const Icon(Icons.add),
      ),
    );
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
}
