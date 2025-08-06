// Tạo file mới: book_reader_page.dart

import 'package:flutter/material.dart';

class BookReaderPage extends StatelessWidget {
  final List<String> pages;
  final String title;

  const BookReaderPage({super.key, required this.pages, required this.title});

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              pages[index],
              style: const TextStyle(fontSize: 18, height: 1.5),
            ),
          );
        },
      ),
    );
  }
}
