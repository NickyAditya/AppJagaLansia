class JadwalModel {
  final String id;
  final String tanggal;
  final String waktu;
  final String kegiatan;
  final String keterangan;
  final String nama_user;

  JadwalModel({
    required this.id,
    required this.tanggal,
    required this.waktu,
    required this.kegiatan,
    required this.keterangan,
    required this.nama_user,
  });

  factory JadwalModel.fromJson(Map data) {
    print('Creating JadwalModel from data: $data');

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

    return JadwalModel(
      id: idValue,
      tanggal: data['tanggal']?.toString() ?? '',
      waktu: data['waktu']?.toString() ?? '',
      kegiatan: data['kegiatan']?.toString() ?? '',
      keterangan: data['keterangan']?.toString() ?? '',
      nama_user: data['nama_user']?.toString() ?? '',
    );
  }
}