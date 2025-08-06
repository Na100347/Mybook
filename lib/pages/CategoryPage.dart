import 'package:flutter/material.dart';
import '../auth/book_service.dart';
import 'reading_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final BookService _bookService = BookService();
  int _selectedTabIndex = 3; // Danh mục được chọn
  int _selectedCategoryTabIndex = 0; // VH trong nước được chọn

  final List<String> categoryTabs = ['VH trong nước', 'VH nước ngoài', 'VH mạng', 'Khác'];

  final List<Map<String, dynamic>> categories = [
    {'title': 'Chiến tranh', 'color': Color(0xFF424242)},
    {'title': 'Chính luận', 'color': Color(0xFF424242)},
    {'title': 'Dân gian', 'color': Color(0xFF424242)},
    {'title': 'Giả tưởng', 'color': Color(0xFF424242)},
    {'title': 'Hiện thực', 'color': Color(0xFF424242)},
    {'title': 'Hồi Ký - Tuỳ Bút', 'color': Color(0xFF424242)},
    {'title': 'Khác', 'color': Color(0xFF424242)},
    {'title': 'Kinh dị', 'color': Color(0xFF424242)},
    {'title': 'Lãng mạn', 'color': Color(0xFF424242)},
    {'title': 'Lịch sử', 'color': Color(0xFF424242)},
    {'title': 'Phiêu lưu', 'color': Color(0xFF424242)},
    {'title': 'Thơ', 'color': Color(0xFF424242)},
    {'title': 'Trinh thám', 'color': Color(0xFF424242)},
    {'title': 'Truyện cười', 'color': Color(0xFF424242)},
    {'title': 'Truyện ngắn - Tản văn', 'color': Color(0xFF424242)},
    {'title': 'Truyện tập', 'color': Color(0xFF424242)},
  ];

  void navigateToReadingPage(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadingPage(category: category),
      ),
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
          SizedBox(height: 20),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: categoryTabs.asMap().entries.map((entry) {
                int index = entry.key;
                String title = entry.value;
                bool isSelected = _selectedCategoryTabIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryTabIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.transparent : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isSelected ? Color(0xFFFF9800) : Colors.grey[400],
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (isSelected) ...[
                          SizedBox(height: 4),
                          Container(
                            width: 40,
                            height: 2,
                            color: Color(0xFFFF9800),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3.5,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () => navigateToReadingPage(context, category['title']),
                    child: Container(
                      decoration: BoxDecoration(
                        color: category['color'],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          category['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage('https://via.placeholder.com/350x80/FF5722/FFFFFF?text=VinFast+Advertisement'),
                fit: BoxFit.cover,
              ),
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