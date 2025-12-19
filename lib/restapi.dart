// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'dart:typed_data';

class DataService {
  Future insertUsers(String appid, String username, String nama, String email, String password, String role) async {
    String uri = 'https://api.247go.app/v5/insert/';

    try {
      final response = await http.post(Uri.parse(uri), body: {
        'token': '6943ac92380728163dc2a161',
        'project': 'jaga_lansia',
        'collection': 'users',
        'appid': appid,
        'username': username,
        'nama': nama,
        'email': email,
        'password': password,
        'role': role,
      });

      print('Insert Response Status: ${response.statusCode}');
      print('Insert Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Insert Error: ${response.statusCode}');
        return '[]';
      }
    } catch (e) {
      print('Insert Exception: $e');
      return '[]';
    }
  }

  Future selectAll(String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/select_all/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectId(String token, String project, String collection, String appid, String id) async {
    String uri = 'https://api.247go.app/v5/select_id/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/id/' + id;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhere(String token, String project, String collection, String appid, String where_field, String where_value) async {
    String uri = 'https://api.247go.app/v5/select_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/where_field/' + where_field + '/where_value/' + where_value;

    print('SelectWhere URI: $uri');

    try {
      final response = await http.get(Uri.parse(uri));

      print('SelectWhere Response Status: ${response.statusCode}');
      print('SelectWhere Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('SelectWhere Error: ${response.statusCode}');
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      print('SelectWhere Exception: $e');
      // Print error here
      return '[]';
    }
  }

  Future selectOrWhere(String token, String project, String collection, String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://api.247go.app/v5/select_or_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/or_where_field/' + or_where_field + '/or_where_value/' + or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhereLike(String token, String project, String collection, String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://api.247go.app/v5/select_where_like/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wlike_field/' + wlike_field + '/wlike_value/' + wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhereIn(String token, String project, String collection, String appid, String win_field, String win_value) async {
    String uri = 'https://api.247go.app/v5/select_where_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/win_field/' + win_field + '/win_value/' + win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future selectWhereNotIn(String token, String project, String collection, String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://api.247go.app/v5/select_where_not_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wnotin_field/' + wnotin_field + '/wnotin_value/' + wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future removeAll(String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/remove_all/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeId(String token, String project, String collection, String appid, String id) async {
    String uri = 'https://api.247go.app/v5/remove_id/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/id/' + id;

    print('Remove ID URI: $uri');
    print('Removing user with ID: $id');

    try {
      final response = await http.delete(Uri.parse(uri));

      print('Remove Response Status: ${response.statusCode}');
      print('Remove Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Remove Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Remove Exception: $e');
      return false;
    }
  }

  Future removeWhere(String token, String project, String collection, String appid, String where_field, String where_value) async {
    String uri = 'https://api.247go.app/v5/remove_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/where_field/' + where_field + '/where_value/' + where_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeOrWhere(String token, String project, String collection, String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://api.247go.app/v5/remove_or_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/or_where_field/' + or_where_field + '/or_where_value/' + or_where_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeWhereLike(String token, String project, String collection, String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://api.247go.app/v5/remove_where_like/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wlike_field/' + wlike_field + '/wlike_value/' + wlike_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeWhereIn(String token, String project, String collection, String appid, String win_field, String win_value) async {
    String uri = 'https://api.247go.app/v5/remove_where_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/win_field/' + win_field + '/win_value/' + win_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future removeWhereNotIn(String token, String project, String collection, String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://api.247go.app/v5/remove_where_not_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wnotin_field/' + wnotin_field + '/wnotin_value/' + wnotin_value;

    try {
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      // Print error here
      return false;
    }
  }

  Future updateAll(String update_field, String update_value, String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/update_all/';

    try {
      final response = await http.put(Uri.parse(uri),body: {
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateId(String update_field, String update_value, String token, String project, String collection, String appid, String id) async {
    String uri = 'https://api.247go.app/v5/update_id/';

    print('Update ID URI: $uri');
    print('Update params: field=$update_field, value=$update_value, id=$id');

    try {
      final response = await http.put(Uri.parse(uri), body: {
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid,
        'id': id,
      });

      print('Update Response Status: ${response.statusCode}');
      print('Update Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Update Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Update Exception: $e');
      return false;
    }
  }

  Future updateWhere(String where_field, String where_value, String update_field, String update_value, String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/update_where/';

    try {
      final response = await http.put(Uri.parse(uri),body: {
        'where_field': where_field,
        'where_value': where_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateOrWhere(String or_where_field, String or_where_value, String update_field, String update_value, String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/update_or_where/';

    try {
      final response = await http.put(Uri.parse(uri),body: {
        'or_where_field': or_where_field,
        'or_where_value': or_where_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateWhereLike(String wlike_field, String wlike_value, String update_field, String update_value, String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/update_where_like/';

    try {
      final response = await http.put(Uri.parse(uri),body: {
        'wlike_field': wlike_field,
        'wlike_value': wlike_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateWhereIn(String win_field, String win_value, String update_field, String update_value, String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/update_where_in/';

    try {
      final response = await http.put(Uri.parse(uri),body: {
        'win_field': win_field,
        'win_value': win_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateWhereNotIn(String wnotin_field, String wnotin_value, String update_field, String update_value, String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/update_where_not_in/';

    try {
      final response = await http.put(Uri.parse(uri),body: {
        'wnotin_field': wnotin_field,
        'wnotin_value': wnotin_value,
        'update_field': update_field,
        'update_value': update_value,
        'token': token,
        'project': project,
        'collection': collection,
        'appid': appid
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future firstAll(String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/first_all/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhere(String token, String project, String collection, String appid, String where_field, String where_value) async {
    String uri = 'https://api.247go.app/v5/first_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/where_field/' + where_field + '/where_value/' + where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstOrWhere(String token, String project, String collection, String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://api.247go.app/v5/first_or_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/or_where_field/' + or_where_field + '/or_where_value/' + or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhereLike(String token, String project, String collection, String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://api.247go.app/v5/first_where_like/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wlike_field/' + wlike_field + '/wlike_value/' + wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhereIn(String token, String project, String collection, String appid, String win_field, String win_value) async {
    String uri = 'https://api.247go.app/v5/first_where_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/win_field/' + win_field + '/win_value/' + win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future firstWhereNotIn(String token, String project, String collection, String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://api.247go.app/v5/first_where_not_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wnotin_field/' + wnotin_field + '/wnotin_value/' + wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastAll(String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/last_all/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhere(String token, String project, String collection, String appid, String where_field, String where_value) async {
    String uri = 'https://api.247go.app/v5/last_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/where_field/' + where_field + '/where_value/' + where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastOrWhere(String token, String project, String collection, String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://api.247go.app/v5/last_or_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/or_where_field/' + or_where_field + '/or_where_value/' + or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhereLike(String token, String project, String collection, String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://api.247go.app/v5/last_where_like/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wlike_field/' + wlike_field + '/wlike_value/' + wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhereIn(String token, String project, String collection, String appid, String win_field, String win_value) async {
    String uri = 'https://api.247go.app/v5/last_where_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/win_field/' + win_field + '/win_value/' + win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future lastWhereNotIn(String token, String project, String collection, String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://api.247go.app/v5/last_where_not_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wnotin_field/' + wnotin_field + '/wnotin_value/' + wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomAll(String token, String project, String collection, String appid) async {
    String uri = 'https://api.247go.app/v5/random_all/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhere(String token, String project, String collection, String appid, String where_field, String where_value) async {
    String uri = 'https://api.247go.app/v5/random_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/where_field/' + where_field + '/where_value/' + where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomOrWhere(String token, String project, String collection, String appid, String or_where_field, String or_where_value) async {
    String uri = 'https://api.247go.app/v5/random_or_where/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/or_where_field/' + or_where_field + '/or_where_value/' + or_where_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhereLike(String token, String project, String collection, String appid, String wlike_field, String wlike_value) async {
    String uri = 'https://api.247go.app/v5/random_where_like/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wlike_field/' + wlike_field + '/wlike_value/' + wlike_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhereIn(String token, String project, String collection, String appid, String win_field, String win_value) async {
    String uri = 'https://api.247go.app/v5/random_where_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/win_field/' + win_field + '/win_value/' + win_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future randomWhereNotIn(String token, String project, String collection, String appid, String wnotin_field, String wnotin_value) async {
    String uri = 'https://api.247go.app/v5/random_where_not_in/token/' + token + '/project/' + project + '/collection/' + collection + '/appid/' + appid + '/wnotin_field/' + wnotin_field + '/wnotin_value/' + wnotin_value;

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        // Return an empty array
        return '[]';
      }
    } catch (e) {
      // Print error here
      return '[]';
    }
  }

  Future upload(
      String token,
      String project,
      Uint8List fileBytes,
      String extension) async {
    String uri = 'https://api.247go.app/v5/upload/';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(uri));

      request.fields['token'] = token;
      request.fields['project'] = project;

      var multipartFile = http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: 'file.$extension',
      );

      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '{"error": "Upload failed"}';
      }
    } catch (e) {
      return '{"error": "Upload failed"}';
    }
  }
}