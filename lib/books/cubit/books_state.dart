part of 'books_cubit.dart';

@immutable
abstract class BooksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BooksInitial extends BooksState {}

class BooksLoaded extends BooksState {
  BooksLoaded(this.books);

  final List<Book> books;

  @override
  List<Object?> get props => [books];
}

class Book extends Equatable {
  const Book(
    this.author,
    this.country,
    this.imageLink,
    this.language,
    this.link,
    this.pages,
    this.title,
    this.year,
  );

  final String? author;
  final String? country;
  final String? imageLink;
  final String? language;
  final String? link;
  final int? pages;
  final String? title;
  final int? year;

  @override
  List<Object?> get props => [
        author,
        country,
        imageLink,
        language,
        link,
        pages,
        title,
        year,
      ];
}
