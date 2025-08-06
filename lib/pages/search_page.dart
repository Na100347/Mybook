import 'package:cuoiki/auth/book_service.dart';
import 'package:cuoiki/pages/reading_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'account_page.dart';
import 'news_page.dart';
import 'detail_page.dart'; // Thêm import trang chi tiết
import '../models/book.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 2; // Mặc định chọn "Tìm kiếm" (index 2)
  final TextEditingController _searchController = TextEditingController();
  final BookService _bookService = BookService();
  List<Book> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;

  late TabController _tabController;
  final List<String> _tabs = ['Sách', 'Tác_giả', 'Danh_mục', 'Danh_ngôn', 'Bộ_sưu_tập'];
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: 0);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingPage()));
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewsPage()));
        break;
      case 4:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountPage()));
        break;
    }
  }

  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final books = await _bookService.searchBooks(query);
      setState(() {
        _searchResults = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Nền gradient kéo dài toàn bộ màn hình
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEDE7F6), Color(0xFFE8F5E9)],
              ),
            ),
          ),
          // Nội dung chính
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên sách, tác giả...',
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.6)),
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Theme.of(context).colorScheme.primary),
                        onPressed: () {
                          _searchController.clear();
                          _searchBooks('');
                        },
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    onSubmitted: _searchBooks,
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_errorMessage != null)
                    Text(_errorMessage!, style: const TextStyle(color: Colors.red))
                  else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
                      const Text('Không tìm thấy sách nào.')
                    else if (_searchResults.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kết quả tìm kiếm',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final book = _searchResults[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => DetailPage(book: book)),
                                    );
                                  },
                                  child: _BookCard(book: book),
                                );
                              },
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              child: TabBar(
                                controller: _tabController,
                                tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                                onTap: (index) {
                                  setState(() {
                                    _selectedTabIndex = index;
                                  });
                                },
                                indicatorColor: Colors.orange,
                                labelColor: Colors.orange,
                                unselectedLabelColor: const Color(0xFF757575),
                                labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kệ sách'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: const Color(0xFF757575),
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.thumbnail.isNotEmpty
                  ? Image.network(
                book.thumbnail,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
              )
                  : const Icon(Icons.book, size: 50),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.authors.isNotEmpty ? book.authors.join(', ') : 'Unknown Author',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.description.isNotEmpty ? book.description : 'No description available',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}