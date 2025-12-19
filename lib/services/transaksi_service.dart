import 'dart:convert';
import '../restapi.dart';
import '../config.dart';
import '../model/transaksi_model.dart';

class TransaksiService {
  final DataService _dataService = DataService();

  // Get all transaksi
  Future<List<TransaksiModel>> getAllTransaksi() async {
    try {
      print('Fetching all transaksi...');

      final response = await _dataService.selectAll(
        token,
        project,
        'transaksi',
        appid,
      );

      print('Get all transaksi response: $response');

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
      List<dynamic> transaksiList;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        transaksiList = parsedResponse['data'];
      } else if (parsedResponse is List) {
        transaksiList = parsedResponse;
      } else {
        return [];
      }

      // Convert to TransaksiModel list
      final transaksiItems = transaksiList.map((transaksiData) {
        if (transaksiData is Map<String, dynamic>) {
          return TransaksiModel.fromJson(transaksiData);
        } else {
          return TransaksiModel.fromJson(Map<String, dynamic>.from(transaksiData));
        }
      }).toList();

      print('Total transaksi fetched: ${transaksiItems.length}');
      return transaksiItems;
    } catch (e) {
      print('Error fetching transaksi: $e');
      return [];
    }
  }

  // Get transaksi by ID
  Future<TransaksiModel?> getTransaksiById(String id) async {
    try {
      final response = await _dataService.selectId(
        token,
        project,
        'transaksi',
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

      Map<String, dynamic> transaksiData;
      if (parsedResponse is Map) {
        if (parsedResponse.containsKey('data')) {
          transaksiData = Map<String, dynamic>.from(parsedResponse['data']);
        } else {
          transaksiData = Map<String, dynamic>.from(parsedResponse);
        }
      } else {
        return null;
      }

      return TransaksiModel.fromJson(transaksiData);
    } catch (e) {
      print('Error getting transaksi by ID: $e');
      return null;
    }
  }

  // Add new transaksi
  Future<Map<String, dynamic>> addTransaksi({
    required String namaObat,
    required String namaUser,
    required String jumlahDibeli,
    required String totalHarga,
    required String statusPembelian,
  }) async {
    try {
      print('Adding new transaksi: $namaObat');

      // Insert new transaksi
      final response = await _dataService.insertTransaksi(
        appid,
        namaObat,
        namaUser,
        jumlahDibeli,
        totalHarga,
        statusPembelian,
      );

      print('Add transaksi response: $response');

      if (response != null && response != '[]' && response.isNotEmpty) {
        return {
          'success': true,
          'message': 'Transaksi berhasil ditambahkan',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menambahkan transaksi',
        };
      }
    } catch (e) {
      print('Error adding transaksi: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Update transaksi
  Future<Map<String, dynamic>> updateTransaksi({
    required String id,
    required String field,
    required String value,
  }) async {
    try {
      print('Updating transaksi $id: $field = $value');

      final response = await _dataService.updateId(
        field,
        value,
        token,
        project,
        'transaksi',
        appid,
        id,
      );

      print('Update service response: $response');

      // Check if response is boolean or string
      if (response == true) {
        return {
          'success': true,
          'message': 'Transaksi berhasil diupdate',
        };
      } else if (response is String && response.isNotEmpty && response != '[]') {
        // Sometimes API returns string response
        return {
          'success': true,
          'message': 'Transaksi berhasil diupdate',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengupdate transaksi. Silakan coba lagi.',
        };
      }
    } catch (e) {
      print('Error updating transaksi: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Delete transaksi
  Future<Map<String, dynamic>> deleteTransaksi(String id) async {
    try {
      print('Deleting transaksi: $id');

      final response = await _dataService.removeId(
        token,
        project,
        'transaksi',
        appid,
        id,
      );

      print('Delete service response: $response');

      // Check if response is boolean or string
      if (response == true) {
        return {
          'success': true,
          'message': 'Transaksi berhasil dihapus',
        };
      } else if (response is String && response.isNotEmpty && response != '[]') {
        // Sometimes API returns string response
        return {
          'success': true,
          'message': 'Transaksi berhasil dihapus',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus transaksi. Silakan coba lagi.',
        };
      }
    } catch (e) {
      print('Error deleting transaksi: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Get transaksi statistics
  Future<Map<String, int>> getTransaksiStats() async {
    try {
      final allTransaksi = await getAllTransaksi();
      final totalTransaksi = allTransaksi.length;
      final pendingTransaksi = allTransaksi.where((t) => t.status_pembelian == 'Pending').length;
      final berhasilTransaksi = allTransaksi.where((t) => t.status_pembelian == 'Berhasil').length;
      final gagalTransaksi = allTransaksi.where((t) => t.status_pembelian == 'Gagal').length;

      return {
        'total': totalTransaksi,
        'pending': pendingTransaksi,
        'berhasil': berhasilTransaksi,
        'gagal': gagalTransaksi,
      };
    } catch (e) {
      print('Error getting transaksi stats: $e');
      return {
        'total': 0,
        'pending': 0,
        'berhasil': 0,
        'gagal': 0,
      };
    }
  }
}

