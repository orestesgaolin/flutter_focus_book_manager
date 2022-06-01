import 'dart:math';

import 'package:book_manager/books_repository/books_repository.dart';
import 'package:rxdart/subjects.dart';

class BooksRepository {
  BooksRepository() {
    final books = {
      for (var i = 0; i < booksData.length; i++)
        i: Book(
          i,
          booksData[i]['author'] as String?,
          booksData[i]['country'] as String?,
          booksData[i]['imageLink'] as String?,
          booksData[i]['language'] as String?,
          booksData[i]['link'] as String?,
          booksData[i]['pages'] as int?,
          booksData[i]['title'] as String?,
          booksData[i]['year'] as int?,
          Random().nextInt(10).isEven,
        )
    };
    _bookController.add(books);
  }

  final _bookController = BehaviorSubject<Map<int, Book>>();

  Stream<Map<int, Book>> books() => _bookController.stream;

  Future<void> updateBook(Book book) async {
    final books = await _bookController.first;
    final map = Map<int, Book>.from(books);
    map[book.id] = book;
    _bookController.add(map);
  }
}
