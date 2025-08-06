const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const axios = require('axios');

// Khởi tạo Firebase Admin
admin.initializeApp();
const db = admin.firestore();

// Khởi tạo Express
const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// Middleware kiểm tra xác thực
const authenticate = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).send('Unauthorized: No token provided');
  }

  const idToken = authHeader.split('Bearer ')[1];
  try {
    await admin.auth().verifyIdToken(idToken);
    next();
  } catch (error) {
    res.status(401).send(`Unauthorized: Invalid token - ${error.message}`);
  }
};

// Lấy danh sách sách
app.get('/books', async (req, res) => {
  try {
    const query = req.query.q;
    if (!query) {
      return res.status(400).send('Missing query parameter: q');
    }
    const response = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=${encodeURIComponent(query)}`);
    const books = response.data.items ? response.data.items.map(item => ({
      id: item.id,
      title: item.volumeInfo.title || 'No Title',
      authors: item.volumeInfo.authors || [],
      description: item.volumeInfo.description || '',
      thumbnail: item.volumeInfo.imageLinks?.thumbnail || '',
    })) : [];
    res.status(200).json({ items: books });
  } catch (error) {
    res.status(500).send(`Error fetching books: ${error.message}`);
  }
});

// Thêm sách mới (yêu cầu xác thực)
app.post('/books', authenticate, async (req, res) => {
  try {
    const { id, title, authors, description, thumbnail } = req.body;
    if (!id || !title) {
      return res.status(400).send('Missing required fields: id, title');
    }

    await db.collection('books').doc(id).set({
      id,
      title,
      authors: authors || [],
      description: description || '',
      thumbnail: thumbnail || '',
    });

    res.status(201).send('Book added successfully');
  } catch (error) {
    res.status(500).send(`Error adding book: ${error.message}`);
  }
});

// Thêm sách vào danh sách yêu thích
app.post('/favorites', authenticate, async (req, res) => {
  try {
    const decodedToken = await admin.auth().verifyIdToken(req.headers.authorization.split('Bearer ')[1]);
    const userId = decodedToken.uid;
    const { id, title, authors, description, thumbnail } = req.body;

    await db.collection('favorites').doc(userId).collection('books').doc(id).set({
      id,
      title,
      authors: authors || [],
      description: description || '',
      thumbnail: thumbnail || '',
    });

    res.status(201).send('Book added to favorites');
  } catch (error) {
    res.status(500).send(`Error adding favorite: ${error.message}`);
  }
});

// Thêm dữ liệu mẫu sách
app.post('/seed-books', async (req, res) => {
  try {
    const books = [
      {
        id: 'book1',
        title: 'Flutter for Beginners',
        authors: ['John Doe'],
        description: 'A guide to building apps with Flutter',
        thumbnail: 'https://example.com/book1.jpg',
      },
      {
        id: 'book2',
        title: 'Dart Programming',
        authors: ['Jane Smith'],
        description: 'Learn Dart for Flutter development',
        thumbnail: 'https://example.com/book2.jpg',
      },
    ];

    for (const book of books) {
      await db.collection('books').doc(book.id).set(book);
    }

    res.status(201).send('Books seeded successfully');
  } catch (error) {
    res.status(500).send(`Error seeding books: ${error.message}`);
  }
});

// Lấy danh sách sách yêu thích
app.get('/favorites', authenticate, async (req, res) => {
  try {
    const decodedToken = await admin.auth().verifyIdToken(req.headers.authorization.split('Bearer ')[1]);
    const userId = decodedToken.uid;

    const snapshot = await db.collection('favorites').doc(userId).collection('books').get();
    const books = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    res.status(200).json(books);
  } catch (error) {
    res.status(500).send(`Error fetching favorites: ${error.message}`);
  }
});

app.get('/sync-books', async (req, res) => {
  try {
    const query = req.query.q;
    if (!query) {
      return res.status(400).send('Missing query parameter: q');
    }
    const response = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=${encodeURIComponent(query)}`);
    const books = response.data.items ? response.data.items.map(item => ({
      id: item.id,
      title: item.volumeInfo.title,
      authors: item.volumeInfo.authors || [],
      description: item.volumeInfo.description || '',
      thumbnail: item.volumeInfo.imageLinks?.thumbnail || '',
    })) : [];

    for (const book of books) {
      await db.collection('books').doc(book.id).set(book);
    }

    res.status(201).send('Books synced successfully');
  } catch (error) {
    res.status(500).send(`Error syncing books: ${error.message}`);
  }
});
// Endpoint để lấy từ khóa
app.get('/keywords', async (req, res) => {
  try {
    const keywordsDoc = await db.collection('metadata').doc('keywords').get();
    if (!keywordsDoc.exists) {
      // Nếu không có dữ liệu trong Firestore, trả về dữ liệu mặc định
      const defaultKeywords = {
        Sách: [
          'Flutter for Beginners',
          'Dart Programming',
          'Học Flutter',
          'Lập trình Dart',
          'Ứng dụng di động',
        ],
        Tác_giả: [
          'Nguyễn Nhật Ánh',
          'Nam Cao',
          'Nguyen Ngoc Tu',
          'Bill Gates',
          'John Doe',
        ],
        Danh_mục: [
          'Văn học',
          'Kinh tế',
          'Lịch sử',
          'Tâm lý',
          'Khoa học',
        ],
        Danh_ngôn: [
          'Tình yêu',
          'Ước mơ',
          'Nỗ lực',
          'Thanh xuân',
          'Bình tĩnh',
        ],
        Bộ_sưu_tập: [
          'Sách nổi bật',
          'Sách mới',
          'Top 100',
          'Tuổi thơ',
          'Hướng nội',
        ],
      };
      // Lưu dữ liệu mặc định vào Firestore
      await db.collection('metadata').doc('keywords').set(defaultKeywords);
      return res.status(200).json(defaultKeywords);
    }
    res.status(200).json(keywordsDoc.data());
  } catch (error) {
    res.status(500).send(`Error fetching keywords: ${error.message}`);
  }
});

// Endpoint để cập nhật từ khóa (tùy chọn, nếu bạn muốn admin có thể cập nhật từ khóa)
app.post('/keywords', async (req, res) => {
  try {
    const newKeywords = req.body;
    await db.collection('metadata').doc('keywords').set(newKeywords);
    res.status(201).send('Keywords updated successfully');
  } catch (error) {
    res.status(500).send(`Error updating keywords: ${error.message}`);
  }
});

// Endpoint cho từ khóa gần đây
// Endpoint cho từ khóa gần đây
app.get('/recent-keywords', async (req, res) => {
  try {
    const recentKeywords = {
      Sách: [
        'Flutter for Beginners',
        'Dart Programming',
        'Học Flutter',
      ],
      Tác_giả: [
        'Nguyễn Nhật Ánh',
        'Nam Cao',
        'John Doe',
      ],
      Danh_mục: [
        'Văn học',
        'Kinh tế',
        'Khoa học',
      ],
      Danh_ngôn: [
        'Tình yêu',
        'Ước mơ',
        'Nỗ lực',
      ],
      Bộ_sưu_tập: [
        'Sách nổi bật',
        'Sách mới',
        'Top 100',
      ],
    };
    // Lưu vào Firestore nếu cần (tùy chọn)
    await db.collection('metadata').doc('recent-keywords').set(recentKeywords);
    res.status(200).json(recentKeywords);
  } catch (error) {
    res.status(500).send(`Error fetching recent keywords: ${error.message}`);
  }
});
// Endpoint cho từ khóa nổi bật
app.get('/featured-keywords', (req, res) => {
  const featuredKeywords = [
    '50 Đề Minh Họa TN THPT 2025 Môn Toán',
    'Yêu Nhung Điều Khong Hoàn Hảo',
    '999 Lá Thư Gửi Cho Chính Minh',
    'Harry Potter',
  ];
  res.status(200).json(featuredKeywords);
});

app.get('/featured-keywords', (req, res) => {
  const featuredKeywords = [
    '50 Đề Minh Họa TN THPT 2025 Môn Toán',
    'Yêu Những Điều Không Hoàn Hảo',
    '999 Lá Thư Gửi Cho Chính Mình',
    'Harry Potter',
  ];
  res.status(200).json(featuredKeywords);
});
// Xuất API
exports.api = functions.https.onRequest(app);