class TransaksiModel {
  final String id;
  final String nama_obat;
  final String nama_user;
  final String jumlah_dibeli;
  final String total_harga;
  final String status_pembelian;

  TransaksiModel({
    required this.id,
    required this.nama_obat,
    required this.nama_user,
    required this.jumlah_dibeli,
    required this.total_harga,
    required this.status_pembelian
  });

  factory TransaksiModel.fromJson(Map data) {
    print('Creating TransaksiModel from data: $data');

    // Handle _id field which might be string or ObjectId
    String idValue;
    if (data['_id'] != null) {
      if (data['_id'] is Map && data['_id']['\$oid'] != null) {
        idValue = data['_id']['\$oid'].toString();
      } else {
        idValue = data['_id'].toString();
      }
    } else if (data['id'] != null) {
      idValue = data['id'].toString();
    } else {
      idValue = '';
    }

    return TransaksiModel(
      id: idValue,
      nama_obat: data['nama_obat']?.toString() ?? '',
      nama_user: data['nama_user']?.toString() ?? '',
      jumlah_dibeli: data['jumlah_dibeli']?.toString() ?? '',
      total_harga: data['total_harga']?.toString() ?? '',
      status_pembelian: data['status_pembelian']?.toString() ?? ''
    );
  }
}