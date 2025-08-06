import 'package:cuoiki/pages/reading_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'account_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 3; // Mặc định chọn "Thông báo" (index 3)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0: // Trang chủ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1: // Kệ sách
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReadingPage()),
        );

        break;
      case 2: // Tìm kiếm
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SearchPage()),
        );
        break;
      case 3: // Thông báo
      // Không cần điều hướng lại
        break;
      case 4: // Tài khoản
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AccountPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEDE7F6), Color(0xFFE8F5E9)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildNewsCard(
              context,
              title: '"ĐI TỐC" SỰ TỒN TẠI KHÁC THƯỜNG, SỐNG LÂU TRONG XÃ HỘI, NHỮNG THỨ ĐỌC ĐẮC KHÔNG KHÁC GÌ QUÝ VẬT. JUNG YEON, NGƯỜI ĐANG CHỊU TĂNG CỦA MẸ MÌNH, BẬT NGỜ ĐỐI MẶT VỚI SINH VẬT ÉP BƯỚC CÓ THỂ VÀO THẾ GIỚI CỦA H...',
              timeAgo: '2 ngày trước',
            ),
            _buildNewsCard(
              context,
              title: 'MÃ NGUỒN: KHỞI ĐẦU CỦA TÔI - BILL GATES - PHẦN 1 - BILL GATES',
              description: 'Những thành tựu vang dội trong kinh doanh của Bill Gates đã trở thành huyền thoại: chàng thanh niên 20 tuổi bỏ học Harvard để khởi nghiệp một công ty phần mềm, từ đó tạo nên để chế công nghệ không lồ,...',
              timeAgo: '2 ngày trước',
            ),
            _buildNewsCard(
              context,
              title: 'TÊN CỦA CÔ ẤY - PHẦN 2 - VUI LỢI',
              description: 'Bộ của nữ sinh bị bắt cóc với tính phát hiện một xác chết bị moi tim một cách tàn bạo tại địa điểm giao dịch tiền chuộc mà kẻ bắt cóc chỉ định. Một gia đình tưởng chừng hạnh phúc, yêu thương nhau, song mỗi thành...',
              timeAgo: '2 ngày trước',
            ),
            _buildNewsCard(
              context,
              title: 'GHÍ CHẾP PHẬT Y 3 - NHỮNG THỨ THẾ KHÔNG HOÀN CHÍNH - LƯU BẮT BẮC',
              description: '"Ghí chếp phật y - Những thứ thế không chính" là phần thứ 3, tiếp nối series đình đám...',
              timeAgo: '2 ngày trước',
            ),
          ],
        ),
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

  Widget _buildNewsCard(BuildContext context, {required String title, String? description, required String timeAgo}) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              timeAgo,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}