import 'dart:convert';
import '../restapi.dart';
import '../config.dart';
import '../model/user_model.dart';

class AuthService {
  final DataService _dataService = DataService();

  // Login function
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Starting login for: $email');

      // Select user by email
      final response = await _dataService.selectWhere(
        token,
        project,
        'users',
        appid,
        'email',
        email,
      );

      print('Login response: $response');
      print('Login response type: ${response.runtimeType}');

      // Check if response is null or empty
      if (response == null || response.toString().isEmpty) {
        return {
          'success': false,
          'message': 'Tidak dapat terhubung ke server',
        };
      }

      // Check if response is empty array
      if (response == '[]' || response.toString() == '[]') {
        return {
          'success': false,
          'message': 'Email tidak ditemukan',
        };
      }

      // Parse response - handle both string and already parsed objects
      dynamic parsedResponse;
      try {
        if (response is String) {
          parsedResponse = json.decode(response);
        } else {
          parsedResponse = response;
        }
        print('Parsed response type: ${parsedResponse.runtimeType}');
        print('Parsed response: $parsedResponse');
      } catch (e) {
        print('Error parsing response: $e');
        print('Raw response: $response');
        return {
          'success': false,
          'message': 'Format data tidak valid',
        };
      }

      // Handle GoCloud API response structure: {limit, offset, total, data:[...]}
      dynamic users;
      if (parsedResponse is Map) {
        print('Response is a Map');
        // Check if it has 'data' field (GoCloud API format)
        if (parsedResponse.containsKey('data')) {
          print('Found data field in response');
          users = parsedResponse['data'];
          print('Users from data field: $users');
        } else {
          // If no 'data' field, try to use the map as a single user
          users = [parsedResponse];
        }
      } else if (parsedResponse is List) {
        print('Response is already a List');
        users = parsedResponse;
      } else {
        print('Unknown response format');
        return {
          'success': false,
          'message': 'Format data tidak sesuai',
        };
      }

      print('Users type: ${users.runtimeType}');
      print('Users: $users');

      // Check if users is a list
      if (users is! List) {
        print('Users is not a list, type: ${users.runtimeType}');
        return {
          'success': false,
          'message': 'Format data tidak sesuai',
        };
      }

      // Check if list is empty
      if (users.isEmpty) {
        return {
          'success': false,
          'message': 'Email tidak ditemukan',
        };
      }

      // Get user data from first item
      final userData = users[0];
      print('User data: $userData');
      print('User data type: ${userData.runtimeType}');

      // Ensure userData is a Map
      if (userData is! Map) {
        print('User data is not a map');
        return {
          'success': false,
          'message': 'Format data user tidak valid',
        };
      }

      // Convert to Map<String, dynamic> if needed
      Map<String, dynamic> userMap;
      if (userData is Map<String, dynamic>) {
        userMap = userData;
      } else {
        userMap = Map<String, dynamic>.from(userData);
      }

      print('User map: $userMap');

      // Create user model
      UsersModel user;
      try {
        user = UsersModel.fromJson(userMap);
        print('User model created successfully');
        print('Username: ${user.username}, Email: ${user.email}, Role: ${user.role}');
      } catch (e) {
        print('Error creating user model: $e');
        print('User map keys: ${userMap.keys.toList()}');
        print('User map values: ${userMap.values.toList()}');

        // Try to create response with raw data
        return {
          'success': false,
          'message': 'Error parsing user data: ${e.toString()}',
        };
      }

      // Check password
      print('Checking password...');
      print('Stored password: ${user.password}');
      print('Input password: $password');

      if (user.password != password) {
        print('Password mismatch');
        return {
          'success': false,
          'message': 'Password salah',
        };
      }

      print('Login successful for user: ${user.username}');

      // Login successful
      return {
        'success': true,
        'message': 'Login berhasil',
        'user': {
          'id': user.id,
          'username': user.username,
          'nama': user.nama,
          'email': user.email,
          'role': user.role,
        },
      };
    } catch (e, stackTrace) {
      print('Login exception: $e');
      print('Stack trace: $stackTrace');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Register function - automatically set role as 'user'
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      print('Starting registration for: $email');

      // Check if email already exists
      final checkEmail = await _dataService.selectWhere(
        token,
        project,
        'users',
        appid,
        'email',
        email,
      );

      print('Check email response: $checkEmail');

      if (checkEmail != '[]' && checkEmail != null) {
        try {
          dynamic parsedCheck = json.decode(checkEmail);

          // Handle GoCloud API response structure
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
        } catch (e) {
          print('Error parsing email check: $e');
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

      print('Check username response: $checkUsername');

      if (checkUsername != '[]' && checkUsername != null) {
        try {
          dynamic parsedCheck = json.decode(checkUsername);

          // Handle GoCloud API response structure
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
        } catch (e) {
          print('Error parsing username check: $e');
        }
      }

      // Insert new user with role 'user' automatically
      print('Inserting new user...');
      final response = await _dataService.insertUsers(
        appid,
        username,
        username, // nama = username by default
        email,
        password,
        'user', // Automatically set role as 'user'
      );

      print('Insert response: $response');

      // Check if response is valid and not empty
      if (response != null && response != '[]' && response.isNotEmpty) {
        // Try to parse the response to check if it's valid JSON
        try {
          final parsedResponse = json.decode(response);
          print('Parsed response: $parsedResponse');

          return {
            'success': true,
            'message': 'Registrasi berhasil',
          };
        } catch (e) {
          // If parsing fails but we got a response, consider it success
          print('Response parsing failed but got response: $e');
          if (response.contains('success') || response.contains('inserted')) {
            return {
              'success': true,
              'message': 'Registrasi berhasil',
            };
          }
        }
      }

      return {
        'success': false,
        'message': 'Registrasi gagal. Silakan coba lagi.',
      };
    } catch (e) {
      print('Registration error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  // Logout function
  Future<void> logout() async {
    // Clear any stored user data or session
    // For now, this is a simple logout that doesn't need to do anything
    // In the future, you can add SharedPreferences to clear stored tokens
    return;
  }
}
