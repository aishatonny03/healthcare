import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  final String baseUrl = 'http://76.150.246.167:241';

  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_token', token);
  }

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<String?> login(String username, String password) async {
    try {
      final tokens = await _fetchTokensFromServer(username, password);
      final accessToken = tokens?['access'];
      final refreshToken = tokens?['refresh'];

      if (accessToken != null && refreshToken != null) {
        // Store the token
        await storeToken(accessToken);

        // Store the username
        await storeUsername(username);

        return accessToken;
      } else {
        throw Exception('Login failed: Invalid token data');
      }
    } catch (e) {
      if (e is Exception) {
        final errorMessage = e.toString();
        if (errorMessage.contains("Token retrieval failed with status code: 401")) {
          throw Exception('Login failed: Invalid username or password');
        } else {
          throw Exception('Login failed: $errorMessage');
        }
      } else {
        throw Exception('Login failed: An unknown error occurred');
      }
    }
  }

  Future<Map<String, String>?> register(String username, String email, String password) async {
    try {
      // Hash the password before sending it to the server
      final hashedPassword = password;

      final response = await http.post(
        Uri.parse('$baseUrl/fastapi/userview/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': hashedPassword}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final token = await _fetchTokensFromServer(username, password);
        return token;
      } else {
        final errorMessage = json.decode(response.body)['error_message'] as String?;
        if (errorMessage != null) {
          print('Error message: $errorMessage');
        }
        print('Registration failed');
        return null; // Return null in case of failure.
      }
    } catch (e) {
      print('Registration failed with exception: $e');
      return null;
    }
  }

  Future<void> storeUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Remove the token when logging out
  }

  Future<String?> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/fastapi/userview/refreshtoken/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['access'];
        return token;
      } else {
        throw Exception(_parseError(response));
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  Future<String?> fetchProtectedData(String token, String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return json.encode(userData); // Convert the data to a JSON string
      } else {
        throw Exception(_parseError(response));
      }
    } catch (e) {
      throw Exception('Failed to fetch protected data: $e');
    }
  }

  Future<Map<String, String>?> _fetchTokensFromServer(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/gettoken/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final accessToken = data['access'] as String?;
        final refreshToken = data['refresh'] as String?;

        if (accessToken != null && refreshToken != null) {
          return {'access': accessToken, 'refresh': refreshToken};
        } else {
          throw Exception('Token retrieval failed: Invalid token data');
        }
      } else {
        throw Exception('Token retrieval failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Token retrieval failed: $e');
    }
  }

  String _parseError(http.Response response) {
    try {
      final errorMap = json.decode(response.body);
      final errorMessage = errorMap['detail'] ?? 'An error occurred.';
      return errorMessage;
    } catch (e) {
      return 'An error occurred.';
    }
  }

  // Hash the password using SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
