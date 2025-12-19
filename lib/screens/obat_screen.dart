import 'package:flutter/material.dart';
import '../services/obat_service.dart';
import '../model/obat_model.dart';

class ObatScreen extends StatefulWidget {
  const ObatScreen({super.key});

  @override
  State<ObatScreen> createState() => _ObatScreenState();
}

class _ObatScreenState extends State<ObatScreen> {
  final ObatService _obatService = ObatService();
  List<ObatModel> _obatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadObat();
  }

  Future<void> _loadObat() async {
    setState(() {
      _isLoading = true;
    });

    final obatList = await _obatService.getAllObat();

    setState(() {
      _obatList = obatList;
      _isLoading = false;
    });
  }

  Future<void> _addObat() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddObatDialog(),
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

      final response = await _obatService.addObat(
        namaObat: result['nama_obat'],
        harga: result['harga'],
        dosis: result['dosis'],
        keterangan: result['keterangan'],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response['success'] ? Colors.green : Colors.red,
        ),
      );

      if (response['success']) {
        await _loadObat();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editObat(ObatModel obat) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditObatDialog(obat: obat),
    );

    if (result != null) {
      setState(() {
        _isLoading = true;
      });

      bool success = true;
      String message = '';

      // Update nama_obat if changed
      if (result['nama_obat'] != obat.nama_obat) {
        final response = await _obatService.updateObat(
          id: result['id'],
          field: 'nama_obat',
          value: result['nama_obat'],
        );
        if (!response['success']) {
          success = false;
          message = response['message'];
        }
      }

      // Update harga if changed
      if (result['harga'] != obat.harga && success) {
        final response = await _obatService.updateObat(
          id: result['id'],
          field: 'harga',
          value: result['harga'],
        );
        if (!response['success']) {
          success = false;
          message = response['message'];
        }
      }

      // Update dosis if changed
      if (result['dosis'] != obat.dosis && success) {
        final response = await _obatService.updateObat(
          id: result['id'],
          field: 'dosis',
          value: result['dosis'],
        );
        if (!response['success']) {
          success = false;
          message = response['message'];
        }
      }

      // Update keterangan if changed
      if (result['keterangan'] != obat.keterangan && success) {
        final response = await _obatService.updateObat(
          id: result['id'],
          field: 'keterangan',
          value: result['keterangan'],
        );
        if (!response['success']) {
          success = false;
          message = response['message'];
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Obat berhasil diupdate' : message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      await _loadObat();
    }
  }

  Future<void> _deleteObat(ObatModel obat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus obat "${obat.nama_obat}"?'),
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

      final response = await _obatService.deleteObat(obat.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response['success'] ? Colors.green : Colors.red,
        ),
      );

      if (response['success']) {
        await _loadObat();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
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
                'Manajemen Obat',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00897B),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addObat,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Tambah Obat', style: TextStyle(color: Colors.white)),
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
                : _obatList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.medical_services_outlined, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada obat',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _addObat,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00897B),
                              ),
                              child: const Text('Tambah Obat Pertama', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadObat,
                        child: ListView.builder(
                          itemCount: _obatList.length,
                          itemBuilder: (context, index) {
                            final obat = _obatList[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF00897B),
                                  child: const Icon(
                                    Icons.medication,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  obat.nama_obat,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.monetization_on, size: 14, color: Colors.green),
                                        const SizedBox(width: 4),
                                        Text('Rp ${obat.harga}', style: const TextStyle(fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.schedule, size: 14, color: Colors.blue),
                                        const SizedBox(width: 4),
                                        Expanded(child: Text(obat.dosis, style: const TextStyle(fontSize: 12))),
                                      ],
                                    ),
                                    if (obat.keterangan.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        obat.keterangan,
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
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
                                          Text('Delete', style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _editObat(obat);
                                    } else if (value == 'delete') {
                                      _deleteObat(obat);
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

// Add Obat Dialog
class AddObatDialog extends StatefulWidget {
  const AddObatDialog({super.key});

  @override
  State<AddObatDialog> createState() => _AddObatDialogState();
}

class _AddObatDialogState extends State<AddObatDialog> {
  final _formKey = GlobalKey<FormState>();
  final _namaObatController = TextEditingController();
  final _hargaController = TextEditingController();
  final _keteranganController = TextEditingController();
  String _selectedDosis = '3 x 1 hari, sebelum makan';

  final List<String> _dosisList = [
    '3 x 1 hari, sebelum makan',
    '3 x 1 hari, sesudah makan',
    '3 x 2 hari, sebelum makan',
    '3 x 2 hari, sesudah makan',
    '3 x 3 hari, sebelum makan',
    '3 x 3 hari, sesudah makan',
    '2 x 1 hari, sebelum makan',
    '2 x 1 hari, sesudah makan',
    '2 x 2 hari, sebelum makan',
    '2 x 2 hari, sesudah makan',
    '2 x 3 hari, sebelum makan',
    '2 x 3 hari, sesudah makan',
  ];

  @override
  void dispose() {
    _namaObatController.dispose();
    _hargaController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Obat Baru'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _namaObatController,
                decoration: const InputDecoration(
                  labelText: 'Nama Obat',
                  prefixIcon: Icon(Icons.medication),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama obat harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  prefixIcon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedDosis,
                decoration: const InputDecoration(
                  labelText: 'Dosis',
                  prefixIcon: Icon(Icons.schedule),
                  border: OutlineInputBorder(),
                ),
                items: _dosisList.map((String dosis) {
                  return DropdownMenuItem<String>(
                    value: dosis,
                    child: Text(dosis, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDosis = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan harus diisi';
                  }
                  return null;
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
                'nama_obat': _namaObatController.text,
                'harga': _hargaController.text,
                'dosis': _selectedDosis,
                'keterangan': _keteranganController.text,
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

// Edit Obat Dialog
class EditObatDialog extends StatefulWidget {
  final ObatModel obat;

  const EditObatDialog({super.key, required this.obat});

  @override
  State<EditObatDialog> createState() => _EditObatDialogState();
}

class _EditObatDialogState extends State<EditObatDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaObatController;
  late TextEditingController _hargaController;
  late TextEditingController _keteranganController;
  late String _selectedDosis;

  final List<String> _dosisList = [
    '3 x 1 hari, sebelum makan',
    '3 x 1 hari, sesudah makan',
    '3 x 2 hari, sebelum makan',
    '3 x 2 hari, sesudah makan',
    '3 x 3 hari, sebelum makan',
    '3 x 3 hari, sesudah makan',
    '2 x 1 hari, sebelum makan',
    '2 x 1 hari, sesudah makan',
    '2 x 2 hari, sebelum makan',
    '2 x 2 hari, sesudah makan',
    '2 x 3 hari, sebelum makan',
    '2 x 3 hari, sesudah makan',
  ];

  @override
  void initState() {
    super.initState();
    _namaObatController = TextEditingController(text: widget.obat.nama_obat);
    _hargaController = TextEditingController(text: widget.obat.harga);
    _keteranganController = TextEditingController(text: widget.obat.keterangan);
    _selectedDosis = widget.obat.dosis;
  }

  @override
  void dispose() {
    _namaObatController.dispose();
    _hargaController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Obat'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _namaObatController,
                decoration: const InputDecoration(
                  labelText: 'Nama Obat',
                  prefixIcon: Icon(Icons.medication),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama obat harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  prefixIcon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga harus diisi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Harga harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedDosis,
                decoration: const InputDecoration(
                  labelText: 'Dosis',
                  prefixIcon: Icon(Icons.schedule),
                  border: OutlineInputBorder(),
                ),
                items: _dosisList.map((String dosis) {
                  return DropdownMenuItem<String>(
                    value: dosis,
                    child: Text(dosis, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDosis = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan harus diisi';
                  }
                  return null;
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
                'id': widget.obat.id,
                'nama_obat': _namaObatController.text,
                'harga': _hargaController.text,
                'dosis': _selectedDosis,
                'keterangan': _keteranganController.text,
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00897B),
          ),
          child: const Text('Update', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
