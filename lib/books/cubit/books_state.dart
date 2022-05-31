part of 'books_cubit.dart';

@immutable
class BooksState extends Equatable {
  const BooksState({
    required this.books,
    this.booksSortOrder = const BooksSortOrder(true, BookProperty.author),
  });

  final Map<int, Book> books;
  final BooksSortOrder booksSortOrder;

  List<Book> get booksList => books.values.toList()
    ..sort((a, b) {
      switch (booksSortOrder.property) {
        case BookProperty.author:
          if (booksSortOrder.sortAscending) {
            return a.author?.compareTo(b.author ?? '') ?? 0;
          } else {
            return b.author?.compareTo(a.author ?? '') ?? 0;
          }
        case BookProperty.title:
          if (booksSortOrder.sortAscending) {
            return a.title?.compareTo(b.title ?? '') ?? 0;
          } else {
            return b.title?.compareTo(a.title ?? '') ?? 0;
          }
        case BookProperty.year:
          if (booksSortOrder.sortAscending) {
            return a.year?.compareTo(b.year ?? 0) ?? 0;
          } else {
            return b.year?.compareTo(a.year ?? 0) ?? 0;
          }
        case BookProperty.language:
          if (booksSortOrder.sortAscending) {
            return a.language?.compareTo(b.language ?? '') ?? 0;
          } else {
            return b.language?.compareTo(a.language ?? '') ?? 0;
          }

        case BookProperty.imageLink:
          return 0;
      }
    });

  @override
  List<Object> get props => [
        books,
        booksSortOrder,
      ];

  BooksState copyWith({
    Map<int, Book>? books,
    BooksSortOrder? booksSortOrder,
  }) =>
      BooksState(
        books: books ?? this.books,
        booksSortOrder: booksSortOrder ?? this.booksSortOrder,
      );

  BooksState replace(Book book) => BooksState(
        books: Map.from(books)
          ..remove(book.id)
          ..putIfAbsent(book.id, () => book),
      );
}

enum BookProperty {
  imageLink,
  author,
  title,
  year,
  language;

  bool get isNumeric => this == BookProperty.year;

  bool get isSortable => this != BookProperty.imageLink;
}

class BooksSortOrder extends Equatable {
  const BooksSortOrder(this.sortAscending, this.property);

  final bool sortAscending;
  final BookProperty property;

  @override
  List<Object?> get props => [sortAscending, property];
}

class Book extends Equatable {
  const Book(
    this.id,
    this.author,
    this.country,
    this.imageLink,
    this.language,
    this.link,
    this.pages,
    this.title,
    this.year,
  );

  final int id;
  final String? author;
  final String? country;
  final String? imageLink;
  final String? language;
  final String? link;
  final int? pages;
  final String? title;
  final int? year;

  @override
  List<Object?> get props {
    return [
      id,
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

  Book copyWith({
    String? author,
    String? country,
    String? imageLink,
    String? language,
    String? link,
    int? pages,
    String? title,
    int? year,
  }) {
    return Book(
      id,
      author ?? this.author,
      country ?? this.country,
      imageLink ?? this.imageLink,
      language ?? this.language,
      link ?? this.link,
      pages ?? this.pages,
      title ?? this.title,
      year ?? this.year,
    );
  }

  Book copyWithForProperty({
    String? value,
    required BookProperty property,
  }) {
    switch (property) {
      case BookProperty.imageLink:
        return copyWith(imageLink: value);
      case BookProperty.author:
        return copyWith(author: value);
      case BookProperty.title:
        return copyWith(title: value);
      case BookProperty.year:
        return copyWith(year: int.tryParse(value ?? '') ?? year);
      case BookProperty.language:
        return copyWith(language: value);
    }
  }

  String? valueForProperty(BookProperty property) {
    switch (property) {
      case BookProperty.imageLink:
        return imageLink;
      case BookProperty.author:
        return author;
      case BookProperty.title:
        return title;
      case BookProperty.year:
        return year.toString();
      case BookProperty.language:
        return language;
    }
  }
}
