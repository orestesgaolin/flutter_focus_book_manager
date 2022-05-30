import 'package:bloc/bloc.dart';
import 'package:book_manager/books/cubit/books_data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(BooksInitial());

  Future<void> initialize() async {
    final books = booksData.map(
      (e) => Book(
        e['author'] as String?,
        e['country'] as String?,
        e['imageLink'] as String?,
        e['language'] as String?,
        e['link'] as String?,
        e['pages'] as int?,
        e['title'] as String?,
        e['year'] as int?,
      ),
    );
    emit(BooksLoaded(books.toList()));
  }
}
