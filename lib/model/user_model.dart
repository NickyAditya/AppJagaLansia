class UsersModel {
  final String id;
  final String username;
  final String nama;
  final String email;
  final String password;
  final String role;

  UsersModel({
    required this.id,
    required this.username,
    required this.nama,
    required this.email,
    required this.password,
    required this.role
  });

  factory UsersModel.fromJson(Map data) {
    print('Creating UsersModel from data: $data');

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

    return UsersModel(
        id: idValue,
        username: data['username']?.toString() ?? '',
        nama: data['nama']?.toString() ?? '',
        email: data['email']?.toString() ?? '',
        password: data['password']?.toString() ?? '',
        role: data['role']?.toString() ?? 'user'
    );
  }
}