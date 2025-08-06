import 'package:flutter/material.dart';
import '../models/book.dart';

class DetailPage extends StatefulWidget {
  final Book book;

  const DetailPage({super.key, required this.book});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late PageController _pageController;
  late List<String> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pages = [
      "Trang 1: Đây là trang đầu tiên của sách '${widget.book.title}'. Nội dung mô phỏng sẽ được hiển thị ở đây. Tác giả ${widget.book.authors.join(', ')} đã viết cuốn sách này với mục đích chia sẻ kiến thức thú vị.",
      "Trang 2: Đây là trang thứ hai. Bạn có thể lật trang bằng cách vuốt sang trái hoặc phải. Nội dung này chỉ là ví dụ, bạn có thể thay thế bằng nội dung thực tế từ sách.",
      "Trang 3: Trang cuối cùng của phần mô phỏng. Cảm ơn bạn đã đọc! Bạn có thể quay lại trang chính hoặc thêm chức năng khác như đánh dấu trang.",
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.book.thumbnail.isNotEmpty
                          ? Image.network(
                        widget.book.thumbnail,
                        width: 150,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 150),
                      )
                          : const Icon(Icons.book, size: 150),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.book.title,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.authors.isNotEmpty
                        ? 'Tác giả: ${widget.book.authors.join(', ')}'
                        : 'Tác giả: Unknown Author',
                    style:
                    const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Giới thiệu',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.book.description.isNotEmpty
                        ? widget.book.description
                        : 'Không có mô tả.',
                    style:
                    const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Đọc sách'),
                            content: SizedBox(
                              width: double.maxFinite,
                              height: 400,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _pages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SingleChildScrollView(
                                      child: Text(
                                        _pages[index],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Đóng'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text(
                        'Đọc sách',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite_border,
                          color: Colors.black87, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        '165',
                        style:
                        TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.visibility,
                          color: Colors.black87, size: 24),
                      const SizedBox(width: 8),
                      const Text(
                        '1.3K',
                        style:
                        TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
