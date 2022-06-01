import 'package:equatable/equatable.dart';

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
    this.read,
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
  final bool read;

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
      read,
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
    bool? read,
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
      read ?? this.read,
    );
  }
}
