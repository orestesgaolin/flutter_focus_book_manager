// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:book_manager/app/app.dart';
import 'package:book_manager/books_repository/books_repository.dart';
import 'package:book_manager/bootstrap.dart';

void main() {
  final booksRepository = BooksRepository();
  bootstrap(
    () => App(
      booksRepository: booksRepository,
    ),
  );
}
