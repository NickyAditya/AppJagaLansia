import 'package:flutter/material.dart';
import '../services/transaksi_service.dart';
import '../services/obat_service.dart';
import '../model/transaksi_model.dart';
import '../model/obat_model.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TransaksiService _transaksiService = TransaksiService();
  final ObatService _obatService = ObatService();
  List<TransaksiModel> _transaksiList = [];
  List<ObatModel> _obatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Load transaksi dan obat secara paralel
    final results = await Future.wait([
      _transaksiService.getAllTransaksi(),
      _obatService.getAllObat(),
    ]);

    setState(() {
      _transaksiList = results[0] as List<TransaksiModel>;
      _obatList = results[1] as List<ObatModel>;
      _isLoading = false;
    });
  }

  Future<void> _addTransaksi() async {
    if (_obatList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada obat tersedia. Tambahkan obat terlebih dahulu.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddTransaksiDialog(obatList: _obatList),
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

      final response = await _transaksiService.addTransaksi(
        namaObat: result['nama_obat'],
        namaUser: result['nama_user'],
        jumlahDibeli: result['jumlah_dibeli'],
        totalHarga: result['total_harga'],
        statusPembelian: result['status_pembelian'],
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
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editStatusTransaksi(TransaksiModel transaksi) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => EditStatusDialog(currentStatus: transaksi.status_pembelian),
    );

    if (result != null && result != transaksi.status_pembelian) {
      setState(() {
        _isLoading = true;
      });

      final response = await _transaksiService.updateTransaksi(
        id: transaksi.id,
        field: 'status_pembelian',
        value: result,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response['success'] ? Colors.green : Colors.red,
        ),
      );

      await _loadData();
    }
  }

  Future<void> _deleteTransaksi(TransaksiModel transaksi) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus transaksi obat "${transaksi.nama_obat}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isLoading = true;
      });

      final response = await _transaksiService.deleteTransaksi(transaksi.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response['success'] ? Colors.green : Colors.red,
        ),
      );

      if (response['success']) {
        await _loadData();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Berhasil':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Gagal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Berhasil':
        return Icons.check_circle;
      case 'Pending':
        return Icons.pending;
      case 'Gagal':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manajemen Transaksi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addTransaksi,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Tambah Transaksi', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00897B)),
                  )
                : _transaksiList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada transaksi',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _addTransaksi,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00897B),
                              ),
                              child: const Text('Tambah Transaksi Pertama', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.builder(
                          itemCount: _transaksiList.length,
                          itemBuilder: (context, index) {
                            final transaksi = _transaksiList[index];
                            final statusColor = _getStatusColor(transaksi.status_pembelian);
                            final statusIcon = _getStatusIcon(transaksi.status_pembelian);

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: statusColor.withOpacity(0.2),
                                  child: Icon(
                                    statusIcon,
                                    color: statusColor,
                                  ),
                                ),
                                title: Text(
                                  transaksi.nama_obat,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.shopping_bag, size: 14, color: Colors.blue),
                                        const SizedBox(width: 4),
                                        Text('Jumlah: ${transaksi.jumlah_dibeli}', style: const TextStyle(fontSize: 12)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.monetization_on, size: 14, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Text('Total: Rp ${transaksi.total_harga}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Icon(statusIcon, size: 14, color: statusColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Status: ${transaksi.status_pembelian}',
                                          style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, size: 20),
                                          SizedBox(width: 8),
                                          Text('Ubah Status'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, size: 20, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Delete', style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _editStatusTransaksi(transaksi);
                                    } else if (value == 'delete') {
                                      _deleteTransaksi(transaksi);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// Add Transaksi Dialog
class AddTransaksiDialog extends StatefulWidget {
  final List<ObatModel> obatList;

  const AddTransaksiDialog({super.key, required this.obatList});

  @override
  State<AddTransaksiDialog> createState() => _AddTransaksiDialogState();
}

class _AddTransaksiDialogState extends State<AddTransaksiDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaUserController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _totalHargaController = TextEditingController();
  String? _selectedObat;
  String _selectedStatus = 'Pending';
  ObatModel? _currentObat;

  final List<String> _statusList = [
    'Pending',
    'Berhasil',
    'Gagal',
  ];

  @override
  void dispose() {
    _namaUserController.dispose();
    _jumlahController.dispose();
    _totalHargaController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    if (_currentObat != null && _jumlahController.text.isNotEmpty) {
      final jumlah = int.tryParse(_jumlahController.text) ?? 0;
      final hargaSatuan = int.tryParse(_currentObat!.harga) ?? 0;
      final total = jumlah * hargaSatuan;
      _totalHargaController.text = total.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Transaksi Baru'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedObat,
                decoration: const InputDecoration(
                  labelText: 'Pilih Obat',
                  prefixIcon: Icon(Icons.medication),
                  border: OutlineInputBorder(),
                ),
                items: widget.obatList.map((ObatModel obat) {
                  return DropdownMenuItem<String>(
                    value: obat.nama_obat,
                    child: Text(obat.nama_obat, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedObat = newValue;
                    _currentObat = widget.obatList.firstWhere((obat) => obat.nama_obat == newValue);
                    _calculateTotal();
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih obat terlebih dahulu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _namaUserController,
                decoration: const InputDecoration(
                  labelText: 'Nama User',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  hintText: 'Nama pembeli',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama user harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Dibeli',
                  prefixIcon: Icon(Icons.shopping_bag),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _calculateTotal(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus diisi';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 1) {
                    return 'Jumlah harus minimal 1';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalHargaController,
                decoration: const InputDecoration(
                  labelText: 'Total Harga',
                  prefixIcon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                readOnly: true,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status Pembelian',
                  prefixIcon: Icon(Icons.info),
                  border: OutlineInputBorder(),
                ),
                items: _statusList.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'nama_obat': _selectedObat,
                'nama_user': _namaUserController.text,
                'jumlah_dibeli': _jumlahController.text,
                'total_harga': _totalHargaController.text,
                'status_pembelian': _selectedStatus,
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00897B),
          ),
          child: const Text('Tambah', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// Edit Status Dialog
class EditStatusDialog extends StatefulWidget {
  final String currentStatus;

  const EditStatusDialog({super.key, required this.currentStatus});

  @override
  State<EditStatusDialog> createState() => _EditStatusDialogState();
}

class _EditStatusDialogState extends State<EditStatusDialog> {
  late String _selectedStatus;

  final List<String> _statusList = [
    'Pending',
    'Berhasil',
    'Gagal',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Status Pembelian'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Pilih status baru untuk transaksi ini:'),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedStatus,
            decoration: const InputDecoration(
              labelText: 'Status Pembelian',
              prefixIcon: Icon(Icons.info),
              border: OutlineInputBorder(),
            ),
            items: _statusList.map((String status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Row(
                  children: [
                    Icon(
                      status == 'Berhasil' ? Icons.check_circle :
                      status == 'Pending' ? Icons.pending :
                      Icons.cancel,
                      color: status == 'Berhasil' ? Colors.green :
                             status == 'Pending' ? Colors.orange :
                             Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(status, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedStatus = newValue!;
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
          onPressed: () => Navigator.pop(context, _selectedStatus),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00897B),
          ),
          child: const Text('Update', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
