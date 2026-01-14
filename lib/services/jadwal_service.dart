import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../restapi.dart';
import '../config.dart';
import '../model/jadwal_model.dart';

class JadwalService {
  final DataService _dataService = DataService();

  Future<List<JadwalModel>> getAllJadwal() async {
    try {
      print('Fetching all jadwal...');

      final response = await _dataService.selectAll(token, project, 'jadwal', appid);

      print('Get all jadwal response: $response');

      if (response == '[]' || response == null || response.isEmpty) {
        return [];
      }

      final parsedResponse = json.decode(response);

      // Handle GoCloud API response structure: {data:[...]} or direct array
      dynamic jadwalData;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        jadwalData = parsedResponse['data'];
      } else if (parsedResponse is List) {
        jadwalData = parsedResponse;
      } else {
        return [];
      }

      if (jadwalData is! List || jadwalData.isEmpty) {
        return [];
      }

      final jadwalItems = jadwalData.map((item) => JadwalModel.fromJson(item)).toList();
      print('Total jadwal fetched: ${jadwalItems.length}');
      return jadwalItems;
    } catch (e) {
      print('Error getting all jadwal: $e');
      return [];
    }
  }

  Future<List<JadwalModel>> getJadwalByUser(String userName) async {
    try {
      print('Getting jadwal for userName: $userName');

      final response = await _dataService.selectWhere(
        token,
        project,
        'jadwal',
        appid,
        'nama_user',
        userName,
      );

      print('Response from server: $response');

      if (response == '[]' || response == null || response.isEmpty) {
        print('Empty response or no data found');
        return [];
      }

      final parsedResponse = json.decode(response);
      print('Parsed response type: ${parsedResponse.runtimeType}');
      print('Parsed response: $parsedResponse');

      // Handle GoCloud API response structure: {data:[...]} or direct array
      dynamic jadwalData;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        print('Response has data field');
        jadwalData = parsedResponse['data'];
      } else if (parsedResponse is List) {
        print('Response is direct list');
        jadwalData = parsedResponse;
      } else {
        print('Unknown response format');
        return [];
      }

      print('Jadwal data type: ${jadwalData.runtimeType}');
      print('Jadwal data: $jadwalData');

      if (jadwalData is! List) {
        print('Jadwal data is not a list');
        return [];
      }

      if (jadwalData.isEmpty) {
        print('Jadwal data is empty');
        return [];
      }

      final jadwalList = jadwalData.map((item) => JadwalModel.fromJson(item)).toList();
      print('Successfully parsed ${jadwalList.length} jadwal items');
      return jadwalList;
    } catch (e, stackTrace) {
      print('Error getting jadwal by user: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<Map<String, dynamic>> addJadwal({
    required String tanggal,
    required String waktu,
    required String kegiatan,
    required String keterangan,
    required String userName,
  }) async {
    try {
      print('Adding jadwal for userName: $userName');
      print('Data: tanggal=$tanggal, waktu=$waktu, kegiatan=$kegiatan, keterangan=$keterangan');
      print('Using appid from config: $appid');

      // Insert jadwal dengan appid global dari config
      final response = await _dataService.insertJadwal(
        appid,
        tanggal,
        waktu,
        kegiatan,
        keterangan,
        userName,
      );

      print('Insert jadwal response: $response');

      if (response != '[]' && response != null && response.isNotEmpty) {
        return {
          'success': true,
          'message': 'Jadwal berhasil ditambahkan',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menambahkan jadwal',
        };
      }
    } catch (e, stackTrace) {
      print('Error adding jadwal: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateJadwal({
    required String id,
    required String field,
    required String value,
  }) async {
    try {
      print('Updating jadwal $id: $field = $value');

      final success = await _dataService.updateId(
        field,
        value,
        token,
        project,
        'jadwal',
        appid,
        id,
      );

      print('Update jadwal response: $success');

      if (success == true) {
        return {
          'success': true,
          'message': 'Jadwal berhasil diupdate',
        };
      } else if (success is String && success.isNotEmpty && success != '[]') {
        return {
          'success': true,
          'message': 'Jadwal berhasil diupdate',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengupdate jadwal',
        };
      }
    } catch (e) {
      print('Error updating jadwal: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> deleteJadwal(String id) async {
    try {
      print('Deleting jadwal: $id');

      final success = await _dataService.removeId(
        token,
        project,
        'jadwal',
        appid,
        id,
      );

      print('Delete jadwal response: $success');

      if (success == true) {
        return {
          'success': true,
          'message': 'Jadwal berhasil dihapus',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus jadwal',
        };
      }
    } catch (e) {
      print('Error deleting jadwal: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
