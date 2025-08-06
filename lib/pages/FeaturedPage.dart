import 'package:flutter/material.dart';
import '../auth/book_service.dart';
import 'reading_page.dart';

class FeaturedPage extends StatefulWidget {
  const FeaturedPage({super.key});

  @override
  State<FeaturedPage> createState() => _FeaturedPageState();
}

class _FeaturedPageState extends State<FeaturedPage> {
  final BookService _bookService = BookService();
  late Future<List<dynamic>> _booksFuture;
  int _selectedTabIndex = 2; // Nổi bật được chọn

  @override
  void initState() {
    super.initState();
    _booksFuture = _bookService.searchBooks('featured books');
  }

  void navigateToReadingPage(BuildContext context, dynamic book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReadingPage(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C2C2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C2C2E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTabButton('Khám phá', 0),
            _buildTabButton('Mới nhất', 1),
            _buildTabButton('Nổi bật', 2),
            _buildTabButton('Danh mục', 3),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              children: [
                Expanded(flex: _selectedTabIndex, child: SizedBox()),
                Container(
                  width: 60,
                  height: 2,
                  color: Color(0xFFFF9800),
                ),
                Expanded(flex: 3 - _selectedTabIndex, child: SizedBox()),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không tìm thấy sách nổi bật.', style: TextStyle(color: Colors.white)));
                }
                final books = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return GestureDetector(
                        onTap: () => navigateToReadingPage(context, book),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(book.thumbnail.isNotEmpty
                                        ? book.thumbnail
                                        : 'https://via.placeholder.com/150x200'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF44336), // Màu mặc định nếu không có categoryColor
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          book.category ?? 'Unknown',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2196F3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'EPUB', // Có thể lấy từ dữ liệu API nếu có
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              book.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              book.authors?.join(', ') ?? 'Unknown',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Trip.',
                      style: TextStyle(
                        color: Color(0xFF2196F3),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trip.com',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'App Store',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Tải',
                    style: TextStyle(
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1C1C1E),
        selectedItemColor: Color(0xFFFF9800),
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kệ sách'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: 0,
        onTap: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Color(0xFFFF9800) : Colors.grey[400],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}