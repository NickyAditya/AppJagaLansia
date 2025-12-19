import 'dart:convert';
import '../restapi.dart';
import '../config.dart';
import '../model/user_model.dart';

class UserService {
  final DataService _dataService = DataService();

  // Get all users
  Future<List<UsersModel>> getAllUsers() async {
    try {
      print('Fetching all users...');

      final response = await _dataService.selectAll(
        token,
        project,
        'users',
        appid,
      );

      print('Get all users response: $response');

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
      List<dynamic> usersList;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        usersList = parsedResponse['data'];
      } else if (parsedResponse is List) {
        usersList = parsedResponse;
      } else {
        return [];
      }

      // Convert to UsersModel list
      final users = usersList.map((userData) {
        if (userData is Map<String, dynamic>) {
          return UsersModel.fromJson(userData);
        } else {
          return UsersModel.fromJson(Map<String, dynamic>.from(userData));
        }
      }).toList();

      print('Total users fetched: ${users.length}');
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  // Get user by ID
  Future<UsersModel?> getUserById(String id) async {
    try {
      final response = await _dataService.selectId(
        token,
        project,
        'users',
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

      Map<String, dynamic> userData;
      if (parsedResponse is Map) {
        if (parsedResponse.containsKey('data')) {
          userData = Map<String, dynamic>.from(parsedResponse['data']);
        } else {
          userData = Map<String, dynamic>.from(parsedResponse);
        }
      } else {
        return null;
      }

      return UsersModel.fromJson(userData);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

  // Add new user
  Future<Map<String, dynamic>> addUser({
    required String username,
    required String nama,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      print('Adding new user: $username');

      // Check if email already exists
      final checkEmail = await _dataService.selectWhere(
        token,
        project,
        'users',
        appid,
        'email',
        email,
      );

      if (checkEmail != '[]' && checkEmail != null) {
        dynamic parsedCheck = json.decode(checkEmail);
        dynamic existingUsers;

        if (parsedCheck is Map && parsedCheck.containsKey('data')) {
          existingUsers = parsedCheck['data'];
        } else if (parsedCheck is List) {
          existingUsers = parsedCheck;
        } else {
          existingUsers = [];
        }

        if (existingUsers is List && existingUsers.isNotEmpty) {
          return {
            'success': false,
            'message': 'Email sudah terdaftar',
          };
        }
      }

      // Check if username already exists
      final checkUsername = await _dataService.selectWhere(
        token,
        project,
        'users',
        appid,
        'username',
        username,
      );

      if (checkUsername != '[]' && checkUsername != null) {
        dynamic parsedCheck = json.decode(checkUsername);
        dynamic existingUsers;

        if (parsedCheck is Map && parsedCheck.containsKey('data')) {
          existingUsers = parsedCheck['data'];
        } else if (parsedCheck is List) {
          existingUsers = parsedCheck;
        } else {
          existingUsers = [];
        }

        if (existingUsers is List && existingUsers.isNotEmpty) {
          return {
            'success': false,
            'message': 'Username sudah digunakan',
          };
        }
      }

      // Insert new user
      final response = await _dataService.insertUsers(
        appid,
        username,
        nama,
        email,
        password,
        role,
      );

      print('Add user response: $response');

      if (response != null && response != '[]' && response.isNotEmpty) {
        return {
          'success': true,
          'message': 'User berhasil ditambahkan',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menambahkan user',
        };
      }
    } catch (e) {
      print('Error adding user: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Update user
  Future<Map<String, dynamic>> updateUser({
    required String id,
    required String field,
    required String value,
  }) async {
    try {
      print('Updating user $id: $field = $value');

      final response = await _dataService.updateId(
        field,
        value,
        token,
        project,
        'users',
        appid,
        id,
      );

      print('Update service response: $response');

      // Check if response is boolean or string
      if (response == true) {
        return {
          'success': true,
          'message': 'User berhasil diupdate',
        };
      } else if (response is String && response.isNotEmpty && response != '[]') {
        // Sometimes API returns string response
        return {
          'success': true,
          'message': 'User berhasil diupdate',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal mengupdate user. Silakan coba lagi.',
        };
      }
    } catch (e) {
      print('Error updating user: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Delete user
  Future<Map<String, dynamic>> deleteUser(String id) async {
    try {
      print('Deleting user: $id');

      final response = await _dataService.removeId(
        token,
        project,
        'users',
        appid,
        id,
      );

      print('Delete service response: $response');

      // Check if response is boolean or string
      if (response == true) {
        return {
          'success': true,
          'message': 'User berhasil dihapus',
        };
      } else if (response is String && response.isNotEmpty && response != '[]') {
        // Sometimes API returns string response
        return {
          'success': true,
          'message': 'User berhasil dihapus',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus user. Silakan coba lagi.',
        };
      }
    } catch (e) {
      print('Error deleting user: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Get users by role
  Future<List<UsersModel>> getUsersByRole(String role) async {
    try {
      final response = await _dataService.selectWhere(
        token,
        project,
        'users',
        appid,
        'role',
        role,
      );

      if (response == null || response == '[]') {
        return [];
      }

      dynamic parsedResponse;
      if (response is String) {
        parsedResponse = json.decode(response);
      } else {
        parsedResponse = response;
      }

      List<dynamic> usersList;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        usersList = parsedResponse['data'];
      } else if (parsedResponse is List) {
        usersList = parsedResponse;
      } else {
        return [];
      }

      return usersList.map((userData) {
        if (userData is Map<String, dynamic>) {
          return UsersModel.fromJson(userData);
        } else {
          return UsersModel.fromJson(Map<String, dynamic>.from(userData));
        }
      }).toList();
    } catch (e) {
      print('Error getting users by role: $e');
      return [];
    }
  }

  // Get user statistics
  Future<Map<String, int>> getUserStats() async {
    try {
      final allUsers = await getAllUsers();
      final totalUsers = allUsers.length;
      final adminUsers = allUsers.where((user) => user.role == 'admin').length;
      final regularUsers = allUsers.where((user) => user.role == 'user').length;

      return {
        'total': totalUsers,
        'admin': adminUsers,
        'user': regularUsers,
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return {
        'total': 0,
        'admin': 0,
        'user': 0,
      };
    }
  }
}
