import 'package:bloc/bloc.dart';
import 'package:book_manager/books/cubit/books_data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(const BooksState(books: {}));

  Future<void> initialize() async {
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
        )
    };

    emit(BooksState(books: books));
  }

  void update(Book book) {
    emit(state.replace(book));
  }

  void saveAll() {
    //booksRepository.saveAll(state.books);
    emit(state);
  }

  void setSort(
    bool ascending,
    BookProperty property,
  ) {
    emit(state.copyWith(booksSortOrder: BooksSortOrder(ascending, property)));
  }
}
