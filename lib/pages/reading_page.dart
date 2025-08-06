import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'account_page.dart';
import 'news_page.dart';
import 'book_detail_page.dart';
import '../auth/book_service.dart';
import '../models/book.dart';

class ReadingPage extends StatefulWidget {
  final dynamic book;
  final String? category;

  const ReadingPage({Key? key, this.book, this.category}) : super(key: key);

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBottomNavIndex = 1;
  final BookService _bookService = BookService();
  late Future<List<dynamic>> _booksFuture;
  final Set<String> _favoriteIds = <String>{};
  List<Book> _favorites = []; // Lưu danh sách yêu thích

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _booksFuture = _bookService.searchBooks('');
    // _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _bookService.getFavorites();
      if (mounted) {
        setState(() {
          _favoriteIds.addAll(favorites.map((book) => book.id.toString()));
          _favorites = favorites; // Cập nhật danh sách yêu thích
        });
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('Người dùng chưa đăng nhập')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vui lòng đăng nhập để xem danh sách yêu thích.'),
              action: SnackBarAction(
                label: 'Đăng nhập',
                onPressed: () {
                  // Điều hướng đến trang đăng nhập (cần tạo trang đăng nhập)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountPage()),
                  );
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi tải danh sách yêu thích: $e')),
          );
        }
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedBottomNavIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewsPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountPage()),
        );
        break;
    }
  }

  Future<void> _toggleFavorite(Book book) async {
    if (book.id == null || book.id.toString().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể thêm: Sách không có ID.')),
        );
      }
      return;
    }

    try {
      await _bookService.addToFavorites(book);
      if (mounted) {
        setState(() {
          _favoriteIds.add(book.id.toString());
          _favorites.add(book); // Thêm sách vào danh sách yêu thích
        });
        _tabController.animateTo(3);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm vào BST yêu thích!')),
        );
      }
    } catch (e) {
      if (mounted) {
        if (e.toString().contains('Người dùng chưa đăng nhập')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vui lòng đăng nhập để thêm sách yêu thích.'),
              action: SnackBarAction(
                label: 'Đăng nhập',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountPage()),
                  );
                },
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi thêm vào yêu thích: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        title: Container(
          child: TabBar(
            controller: _tabController,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorWeight: 3,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            unselectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: 'Tải xuống'),
              Tab(text: 'Sách'),
              Tab(text: 'BST cá nhân'),
              Tab(text: 'BST yêu thích'),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmptyContent(),
                _buildBooksContent(),
                _buildEmptyContent(),
                _buildFavoritesContent(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kệ sách'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: _selectedBottomNavIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Color(0xFF757575),
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(Icons.keyboard_arrow_up, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF), Color(0xFFB99AE8), Color(0xFFB99AE8)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, size: 64, color: Colors.grey[600]),
            SizedBox(height: 16),
            Text('Không tìm thấy', style: TextStyle(color: Colors.grey, fontSize: 18)),
            SizedBox(height: 8),
            Text('Thêm sách vào kệ của bạn', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A), Color(0xFF4A1A4A)],
        ),
      ),
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
            return _buildEmptyContent();
          }
          final books = snapshot.data!.cast<Book>();
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: Colors.grey[850],
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: book.thumbnail.isNotEmpty
                                  ? DecorationImage(image: NetworkImage(book.thumbnail), fit: BoxFit.cover)
                                  : null,
                              color: book.thumbnail.isEmpty ? Colors.grey[700] : null,
                            ),
                            child: book.thumbnail.isEmpty
                                ? Center(child: Icon(Icons.book, color: Colors.grey[500], size: 32))
                                : null,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tác giả: ${book.authors.isNotEmpty ? book.authors.join(', ') : 'Không rõ'}',
                                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        icon: Icon(
                                          _favoriteIds.contains(book.id.toString())
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                        onPressed: () {
                                          _toggleFavorite(book);
                                        },
                                        splashRadius: 24,
                                        constraints: BoxConstraints(minHeight: 40, minWidth: 40),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.download, color: Colors.blue, size: 20),
                                    SizedBox(width: 8),
                                    Icon(Icons.share, color: Colors.green, size: 20),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Thông tin chi tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 12),
                  Card(
                    color: Colors.grey[850],
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Tiêu đề:', book.title),
                          _buildInfoRow('Tác giả:', book.authors.isNotEmpty ? book.authors.join(', ') : 'Không rõ'),
                          _buildInfoRow('Thể loại:', 'Không rõ'),
                          _buildInfoRow('Định dạng:', 'PDF'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoritesContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A), Color(0xFF4A1A4A)],
        ),
      ),
      child: _favorites.isEmpty
          ? Center(child: Text('Chưa có sách yêu thích', style: TextStyle(color: Colors.white, fontSize: 18)))
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final book = _favorites[index];
          return Card(
            color: Colors.grey[850],
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: book.thumbnail.isNotEmpty
                          ? DecorationImage(image: NetworkImage(book.thumbnail), fit: BoxFit.cover)
                          : null,
                      color: book.thumbnail.isEmpty ? Colors.grey[700] : null,
                    ),
                    child: book.thumbnail.isEmpty
                        ? Center(child: Icon(Icons.book, color: Colors.grey[500], size: 32))
                        : null,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tác giả: ${book.authors.isNotEmpty ? book.authors.join(', ') : 'Không rõ'}',
                          style: TextStyle(color: Colors.grey[300], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14))),
          Expanded(child: Text(value, style: TextStyle(color: Colors.white, fontSize: 14))),
        ],
      ),
    );
  }
}