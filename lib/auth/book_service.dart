import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';

class BookService {
  static const String baseUrl = 'http://10.0.2.2:5002/chatapptute-42bf1/us-central1/api';

  Future<List<Book>> searchBooks(String query) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    final url = Uri.parse('$baseUrl/books?q=$query');
    try {
      final response = await http.get(
        url,
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},

      );
      if (response.statusCode == 200) {
        return Book.fromJsonList(response.body);

      } else {
        throw Exception('Không thể tải dữ liệu sách: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi gọi API: $e');
    }
  }

  Future<List<String>> fetchFeaturedKeywords() async {
    final url = Uri.parse('$baseUrl/featured-keywords');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item.toString()).toList();
      } else {
        throw Exception('Không thể tải từ khóa nổi bật: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy từ khóa nổi bật: $e');
    }
  }

  Future<void> addBook(Book book) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    final url = Uri.parse('$baseUrl/books');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': book.id,
          'title': book.title,
          'authors': book.authors,
          'description': book.description,
          'thumbnail': book.thumbnail,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Không thể thêm sách: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi thêm sách: $e');
    }
  }

  Future<void> addToFavorites(Book book) async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    final url = Uri.parse('$baseUrl/favorites');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': book.id,
          'title': book.title,
          'authors': book.authors,
          'description': book.description,
          'thumbnail': book.thumbnail,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Không thể thêm vào yêu thích: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi thêm vào yêu thích: $e');
    }
  }

  Future<List<Book>> getFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken(true);
    final url = Uri.parse('$baseUrl/favorites');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Book.fromJson(item)).toList();
      } else {
        throw Exception('Không thể lấy danh sách yêu thích: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách yêu thích: $e');
    }
  }
  Future<Map<String, dynamic>> getBookContent(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập. Vui lòng đăng nhập để tiếp tục.');
    }
    final token = await user.getIdToken(true);
    final url = Uri.parse('$baseUrl/books/$bookId');
    try {
      final response = await http.get(
        url,
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        final responseNoAuth = await http.get(url).timeout(Duration(seconds: 10));
        if (responseNoAuth.statusCode == 200) {
          return jsonDecode(responseNoAuth.body);
        }
        throw Exception('Không được phép truy cập: ${responseNoAuth.statusCode}');
      } else {
        throw Exception('Không thể tải nội dung sách: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("Error in getBookContent: $e");
      throw Exception('Lỗi khi lấy nội dung sách: $e');
    }
  }
}