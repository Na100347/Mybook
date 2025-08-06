import 'package:cuoiki/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/book_service.dart';
import 'reading_page.dart';
import 'search_page.dart';
import 'account_page.dart';
import 'news_page.dart';
import 'LatestPage.dart';
import 'FeaturedPage.dart';
import 'CategoryPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BookService _bookService = BookService();
  late Future<List<dynamic>> _booksFuture;
  final List<Map<String, dynamic>> gridItems = [
    {'title': 'Reels', 'icon': Icons.video_collection, 'color': Color(0xFFFF9800)},
    {'title': 'Sách', 'icon': Icons.book, 'color': Color(0xFF7E57C2)},
    {'title': 'Sách nói', 'icon': Icons.headset, 'color': Color(0xFF4CAF50)},
    {'title': 'Truyện', 'icon': Icons.bookmark, 'color': Color(0xFF7E57C2)},
    {'title': 'Truyện tranh', 'icon': Icons.image, 'color': Color(0xFFFF9800)},
    {'title': 'Danh ngôn', 'icon': Icons.format_quote, 'color': Color(0xFF4CAF50)},
    {'title': 'Thơ', 'icon': Icons.edit, 'color': Color(0xFF7E57C2)},
    {'title': 'Bộ sưu tập', 'icon': Icons.star, 'color': Color(0xFFFF9800)},
    {'title': '#BXH', 'icon': Icons.trending_up, 'color': Color(0xFF4CAF50)},
    {'title': 'Cộng đồng', 'icon': Icons.group, 'color': Color(0xFF7E57C2)},
    {'title': 'Song ngữ', 'icon': Icons.translate, 'color': Color(0xFFFF9800)},
    {'title': 'Ngoại văn', 'icon': Icons.language, 'color': Color(0xFF4CAF50)},
    {'title': 'Học T.A', 'icon': Icons.school, 'color': Color(0xFF7E57C2)},
    {'title': 'Xem thêm', 'icon': Icons.add, 'color': Color(0xFFFF9800)},
  ];

  int _selectedIndex = 0;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _booksFuture = _bookService.searchBooks('flutter');
  }

  Future<void> logout(BuildContext context) async {
    final _auth = AuthService();
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng xuất thất bại: $e')),
      );
    }
  }

  void navigateToReadingPage(BuildContext context, dynamic book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReadingPage(book: book)),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReadingPage()),
        );
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

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<dynamic>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Lỗi: ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Không tìm thấy sách.', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  );
                }
                final book = snapshot.data![0];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    color: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: book.thumbnail.isNotEmpty
                                ? DecorationImage(
                              image: NetworkImage(book.thumbnail),
                              fit: BoxFit.cover,
                            )
                                : null,
                            color: book.thumbnail.isEmpty ? Colors.grey[300] : null,
                          ),
                          child: book.thumbnail.isEmpty
                              ? Center(child: Text('No Image', style: TextStyle(color: Theme.of(context).colorScheme.primary)))
                              : null,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tác giả: ${book.authors.isNotEmpty ? book.authors.join(', ') : 'Không rõ'}',
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Thể loại: Không rõ',
                                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary, size: 20),
                                  SizedBox(width: 5),
                                  Text('1', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                                ],
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => navigateToReadingPage(context, null),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          child: Icon(
                            gridItems[index]['icon'],
                            size: 24,
                            color: gridItems[index]['color'],
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          gridItems[index]['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Gợi ý cho bạn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<dynamic>>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Lỗi: ${snapshot.error}', style: TextStyle(color: Theme.of(context).colorScheme.primary));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Không tìm thấy sách.', style: TextStyle(color: Theme.of(context).colorScheme.primary));
                  }
                  return Column(
                    children: snapshot.data!.take(3).map((book) {
                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          onTap: () => navigateToReadingPage(context, book),
                          leading: Container(
                            width: 50,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: book.thumbnail.isNotEmpty
                                  ? DecorationImage(
                                image: NetworkImage(book.thumbnail),
                                fit: BoxFit.cover,
                              )
                                  : null,
                              color: book.thumbnail.isEmpty ? Colors.grey[300] : null,
                            ),
                            child: book.thumbnail.isEmpty
                                ? Center(child: Text('No Image', style: TextStyle(color: Theme.of(context).colorScheme.primary)))
                                : null,
                          ),
                          title: Text(
                            book.title,
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            book.authors.isNotEmpty ? book.authors.join(', ') : 'Không rõ',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
                          ),
                          trailing: Chip(
                            label: Text(
                              'PDF',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        );
      case 1:
        return LatestPage();
      case 2:
        return FeaturedPage();
      case 3:
        return CategoryPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDE7F6), Color(0xFFE8F5E9)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _onTabTapped(0),
                      child: Text(
                        'Khám phá',
                        style: TextStyle(
                          fontWeight: _selectedTabIndex == 0 ? FontWeight.bold : FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _onTabTapped(1),
                      child: Text(
                        'Mới nhất',
                        style: TextStyle(
                          fontWeight: _selectedTabIndex == 1 ? FontWeight.bold : FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _onTabTapped(2),
                      child: Text(
                        'Nổi bật',
                        style: TextStyle(
                          fontWeight: _selectedTabIndex == 2 ? FontWeight.bold : FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _onTabTapped(3),
                      child: Text(
                        'Danh mục',
                        style: TextStyle(
                          fontWeight: _selectedTabIndex == 3 ? FontWeight.bold : FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0 + (_selectedTabIndex * 60.0)),
                child: Divider(
                  color: Theme.of(context).colorScheme.secondary,
                  thickness: 2.0,
                  height: 2.0,
                  endIndent: MediaQuery.of(context).size.width - 100,
                ),
              ),
              _buildTabContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Kệ sách'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Thông báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Color(0xFF757575),
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}