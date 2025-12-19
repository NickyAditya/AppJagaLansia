import 'dart:convert';
import '../restapi.dart';
import '../config.dart';
import '../model/obat_model.dart';

class ObatService {
  final DataService _dataService = DataService();

  // Get all obat
  Future<List<ObatModel>> getAllObat() async {
    try {
      print('Fetching all obat...');

      final response = await _dataService.selectAll(
        token,
        project,
        'obat',
        appid,
      );

      print('Get all obat response: $response');

      if (response == null || response == '[]') {
        return [];
      }

      // Parse response
      dynamic parsedResponse;
      if (response is String) {
        parsedResponse = json.decode(response);
      } else {
        parsedResponse = response;
      }

      // Handle GoCloud API response structure
      List<dynamic> obatList;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        obatList = parsedResponse['data'];
      } else if (parsedResponse is List) {
        obatList = parsedResponse;
      } else {
        return [];
      }

      // Convert to ObatModel list
      final obatItems = obatList.map((obatData) {
        if (obatData is Map<String, dynamic>) {
          return ObatModel.fromJson(obatData);
        } else {
          return ObatModel.fromJson(Map<String, dynamic>.from(obatData));
        }
      }).toList();

      print('Total obat fetched: ${obatItems.length}');
      return obatItems;
    } catch (e) {
      print('Error fetching obat: $e');
      return [];
    }
  }

  // Get obat by ID
  Future<ObatModel?> getObatById(String id) async {
    try {
      final response = await _dataService.selectId(
        token,
        project,
        'obat',
        appid,
        id,
      );

      if (response == null || response == '[]') {
        return null;
      }

      dynamic parsedResponse;
      if (response is String) {
        parsedResponse = json.decode(response);
      } else {
        parsedResponse = response;
      }

      Map<String, dynamic> obatData;
      if (parsedResponse is Map) {
        if (parsedResponse.containsKey('data')) {
          obatData = Map<String, dynamic>.from(parsedResponse['data']);
        } else {
          obatData = Map<String, dynamic>.from(parsedResponse);
        }
      } else {
        return null;
      }

      return ObatModel.fromJson(obatData);
    } catch (e) {
      print('Error getting obat by ID: $e');
      return null;
    }
  }

  // Add new obat
  Future<Map<String, dynamic>> addObat({
    required String namaObat,
    required String harga,
    required String dosis,
    required String keterangan,
  }) async {
    try {
      print('Adding new obat: $namaObat');

      // Check if obat name already exists
      final checkName = await _dataService.selectWhere(
        token,
        project,
        'obat',
        appid,
        'nama_obat',
        namaObat,
      );

      if (checkName != '[]' && checkName != null) {
        dynamic parsedCheck = json.decode(checkName);
        dynamic existingObat;

        if (parsedCheck is Map && parsedCheck.containsKey('data')) {
          existingObat = parsedCheck['data'];
        } else if (parsedCheck is List) {
          existingObat = parsedCheck;
        } else {
          existingObat = [];
        }

        if (existingObat is List && existingObat.isNotEmpty) {
          return {
            'success': false,
            'message': 'Obat dengan nama tersebut sudah ada',
          };
        }
      }

      // Insert new obat
      final response = await _dataService.insertObat(
        appid,
        namaObat,
        harga,
        dosis,
        keterangan,
      );

      print('Add obat response: $response');

      if (response != null && response != '[]' && response.isNotEmpty) {
        return {
          'success': true,
          'message': 'Obat berhasil ditambahkan',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menambahkan obat',
        };
      }
    } catch (e) {
      print('Error adding obat: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Update obat
  Future<Map<String, dynamic>> updateObat({
    required String id,
    required String field,
    required String value,
  }) async {
    try {
      print('Updating obat $id: $field = $value');

      final response = await _dataService.updateId(
        field,
        value,
        token,
        project,
        'obat',
        appid,
        id,
      );

      print('Update service response: $response');

      // Check if response is boolean or string
      if (response == true) {
        return {
          'success': true,
          'message': 'Obat berhasil diupdate',
        };
      } else if (response is String && response.isNotEmpty && response != '[]') {
        // Sometimes API returns string response
        return {
          'success': true,
          'message': 'Obat berhasil diupdate',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengupdate obat. Silakan coba lagi.',
        };
      }
    } catch (e) {
      print('Error updating obat: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Delete obat
  Future<Map<String, dynamic>> deleteObat(String id) async {
    try {
      print('Deleting obat: $id');

      final response = await _dataService.removeId(
        token,
        project,
        'obat',
        appid,
        id,
      );

      print('Delete service response: $response');

      // Check if response is boolean or string
      if (response == true) {
        return {
          'success': true,
          'message': 'Obat berhasil dihapus',
        };
      } else if (response is String && response.isNotEmpty && response != '[]') {
        // Sometimes API returns string response
        return {
          'success': true,
          'message': 'Obat berhasil dihapus',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus obat. Silakan coba lagi.',
        };
      }
    } catch (e) {
      print('Error deleting obat: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Get obat statistics
  Future<Map<String, int>> getObatStats() async {
    try {
      final allObat = await getAllObat();
      final totalObat = allObat.length;

      return {
        'total': totalObat,
      };
    } catch (e) {
      print('Error getting obat stats: $e');
      return {
        'total': 0,
      };
    }
  }
}

