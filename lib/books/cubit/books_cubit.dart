import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:book_manager/books_repository/books_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit(this.booksRepository) : super(const BooksState(books: {}));

  final BooksRepository booksRepository;
  StreamSubscription<Map<int, Book>>? _subscription;

  Future<void> initialize() async {
    _subscription = booksRepository.books().listen((event) {
      emit(state.copyWith(books: event));
    });
  }

  void update(Book book) {
    booksRepository.updateBook(book);
  }

  void saveAll() {
    // booksRepository.saveAll(state.books);
    emit(state);
  }

  void setSort(
    bool ascending,
    BookProperty property,
  ) {
    emit(state.copyWith(booksSortOrder: BooksSortOrder(ascending, property)));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
