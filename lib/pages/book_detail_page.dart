import 'package:flutter/material.dart';
import '../auth/book_service.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;
  final String title;
  final String thumbnail;

  const BookDetailPage({
    Key? key,
    required this.bookId,
    required this.title,
    required this.thumbnail,
  }) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final BookService _bookService = BookService();
  late Future<Map<String, dynamic>> _bookContentFuture;

  @override
  void initState() {
    super.initState();
    _bookContentFuture = _bookService.getBookContent(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D2D2D),
              Color(0xFF1A1A1A),
              Color(0xFF4A1A4A),
            ],
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _bookContentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi: ${snapshot.error}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'Không tìm thấy thông tin',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            final bookDetail = snapshot.data!;
            // Lấy phần giới thiệu từ trường 'description' hoặc mặc định
            final description = bookDetail['description']?.toString() ??
                'Không có giới thiệu cho sách này.';

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị bìa sách
                  Center(
                    child: Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: widget.thumbnail.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(widget.thumbnail),
                          fit: BoxFit.cover,
                        )
                            : null,
                        color: widget.thumbnail.isEmpty ? Colors.grey[700] : null,
                      ),
                      child: widget.thumbnail.isEmpty
                          ? Center(
                        child: Icon(
                          Icons.book,
                          color: Colors.grey[500],
                          size: 32,
                        ),
                      )
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Hiển thị tiêu đề
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Hiển thị giới thiệu
                  Text(
                    'Giới thiệu:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}