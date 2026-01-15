import 'dart:convert';
import '../restapi.dart';
import '../config.dart';
import '../model/user_model.dart';

class UserService {
  final DataService _dataService = DataService();

  // Get all users from database
  Future<List<UsersModel>> getAllUsers() async {
    try {
      print('Fetching all users...');

      final response = await _dataService.selectAll(token, project, 'users', appid);

      print('Get all users response: $response');

      if (response == '[]' || response == null || response.isEmpty) {
        return [];
      }

      final parsedResponse = json.decode(response);

      dynamic userData;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        userData = parsedResponse['data'];
      } else if (parsedResponse is List) {
        userData = parsedResponse;
      } else {
        return [];
      }

      if (userData is! List || userData.isEmpty) {
        return [];
      }

      final users = userData.map((item) => UsersModel.fromJson(item)).toList();
      print('Total users fetched: ${users.length}');
      return users;
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final users = await getAllUsers();

      int totalUsers = users.length;
      int adminCount = users.where((u) => u.role.toLowerCase() == 'admin').length;
      int userCount = users.where((u) => u.role.toLowerCase() == 'user').length;

      return {
        'success': true,
        'total': totalUsers,
        'admins': adminCount,
        'users': userCount,
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return {
        'success': false,
        'total': 0,
        'admins': 0,
        'users': 0,
      };
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

      final response = await _dataService.insertUsers(
        appid,
        username,
        nama,
        email,
        password,
        role,
      );

      print('Add user response: $response');

      if (response != '[]' && response != null && response.isNotEmpty) {
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
        'message': 'Error: $e',
      };
    }
  }

  // Update user
  Future<Map<String, dynamic>> updateUser({
    required String userId,
    String? username,
    String? nama,
    String? email,
    String? password,
    String? role,
  }) async {
    try {
      print('Updating user: $userId');

      bool hasError = false;
      String errorMessage = '';

      // Update username if provided
      if (username != null && username.isNotEmpty) {
        final result = await _dataService.updateId(
          'username',
          username,
          token,
          project,
          'users',
          appid,
          userId,
        );
        if (result != true) {
          hasError = true;
          errorMessage = 'Gagal update username';
        }
      }

      // Update nama if provided
      if (nama != null && nama.isNotEmpty && !hasError) {
        final result = await _dataService.updateId(
          'nama',
          nama,
          token,
          project,
          'users',
          appid,
          userId,
        );
        if (result != true) {
          hasError = true;
          errorMessage = 'Gagal update nama';
        }
      }

      // Update email if provided
      if (email != null && email.isNotEmpty && !hasError) {
        final result = await _dataService.updateId(
          'email',
          email,
          token,
          project,
          'users',
          appid,
          userId,
        );
        if (result != true) {
          hasError = true;
          errorMessage = 'Gagal update email';
        }
      }

      // Update password if provided
      if (password != null && password.isNotEmpty && !hasError) {
        final result = await _dataService.updateId(
          'password',
          password,
          token,
          project,
          'users',
          appid,
          userId,
        );
        if (result != true) {
          hasError = true;
          errorMessage = 'Gagal update password';
        }
      }

      // Update role if provided
      if (role != null && role.isNotEmpty && !hasError) {
        final result = await _dataService.updateId(
          'role',
          role,
          token,
          project,
          'users',
          appid,
          userId,
        );
        if (result != true) {
          hasError = true;
          errorMessage = 'Gagal update role';
        }
      }

      if (hasError) {
        return {
          'success': false,
          'message': errorMessage,
        };
      }

      return {
        'success': true,
        'message': 'User berhasil diperbarui',
      };
    } catch (e) {
      print('Error updating user: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  // Delete user
  Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      print('Deleting user: $userId');

      final result = await _dataService.removeId(
        token,
        project,
        'users',
        appid,
        userId,
      );

      print('Delete user result: $result');

      if (result == true) {
        return {
          'success': true,
          'message': 'User berhasil dihapus',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal menghapus user',
        };
      }
    } catch (e) {
      print('Error deleting user: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateUsername({
    required String userId,
    required String newUsername,
  }) async {
    try {
      print('Updating username for userId: $userId to: $newUsername');

      final result = await _dataService.updateId(
        'username',
        newUsername,
        token,
        project,
        'users',
        appid,
        userId,
      );

      print('Update username result: $result');

      if (result == true) {
        return {
          'success': true,
          'message': 'Username berhasil diperbarui',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal memperbarui username',
        };
      }
    } catch (e) {
      print('Error updating username: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updatePassword({
    required String userId,
    required String newPassword,
  }) async {
    try {
      print('Updating password for userId: $userId');

      final result = await _dataService.updateId(
        'password',
        newPassword,
        token,
        project,
        'users',
        appid,
        userId,
      );

      print('Update password result: $result');

      if (result == true) {
        return {
          'success': true,
          'message': 'Password berhasil diperbarui',
        };
      } else {
        return {
          'success': false,
          'message': 'Gagal memperbarui password',
        };
      }
    } catch (e) {
      print('Error updating password: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    try {
      print('Getting user by email: $email');

      final response = await _dataService.selectWhere(
        token,
        project,
        'users',
        appid,
        'email',
        email,
      );

      print('Get user response: $response');

      if (response == '[]' || response == null || response.isEmpty) {
        return {
          'success': false,
          'message': 'User tidak ditemukan',
        };
      }

      final parsedResponse = json.decode(response);

      dynamic userData;
      if (parsedResponse is Map && parsedResponse.containsKey('data')) {
        userData = parsedResponse['data'];
      } else if (parsedResponse is List) {
        userData = parsedResponse;
      } else {
        return {
          'success': false,
          'message': 'Format data tidak valid',
        };
      }

      if (userData is! List || userData.isEmpty) {
        return {
          'success': false,
          'message': 'User tidak ditemukan',
        };
      }

      return {
        'success': true,
        'user': userData[0],
      };
    } catch (e) {
      print('Error getting user: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}
