import 'dart:convert';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnail;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Không có tiêu đề',
      authors: json['authors'] != null ? List<String>.from(json['authors']) : [],
      description: json['description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
    );
  }

  static List<Book> fromJsonList(String jsonString) {
    try {
      final data = jsonDecode(jsonString);
      if (data['items'] == null || data['items'].isEmpty) {
        print('No items in JSON response'); // Debugging
        return [];
      }
      return (data['items'] as List).map((item) => Book.fromJson(item)).toList();
    } catch (e) {
      print('Error parsing JSON: $e'); // Debugging
      return [];
    }
  }
}