class ObatModel {
  final String id;
  final String nama_obat;
  final String harga;
  final String dosis;
  final String keterangan;

  ObatModel({
    required this.id,
    required this.nama_obat,
    required this.harga,
    required this.dosis,
    required this.keterangan
  });

  factory ObatModel.fromJson(Map data) {
    print('Creating ObatModel from data: $data');

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

    return ObatModel(
      id: idValue,
      nama_obat: data['nama_obat']?.toString() ?? '',
      harga: data['harga']?.toString() ?? '',
      dosis: data['dosis']?.toString() ?? '',
      keterangan: data['keterangan']?.toString() ?? ''
    );
  }
}