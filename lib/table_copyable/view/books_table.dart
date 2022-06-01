// ignore_for_file: unused_element

import 'package:book_manager/actions/actions.dart';
import 'package:book_manager/books/books.dart';
import 'package:book_manager/books_repository/books_repository.dart';
import 'package:book_manager/l10n/l10n.dart';
import 'package:book_manager/table/table.dart' as table;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

const _rowHeight = 60.0;

class BooksTableView extends StatelessWidget {
  const BooksTableView({
    required this.books,
    this.horizontallyScrollable = false,
    super.key,
  });

  final List<Book> books;
  final bool horizontallyScrollable;

  @override
  Widget build(BuildContext context) {
    final tableState = context.watch<table.TableCubit<Book>>().state;

    return SizedBox(
      width: horizontallyScrollable ? 800 : null,
      child: ListView.separated(
        itemCount: books.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              children: [
                for (final property in BookProperty.values)
                  _Header(
                    property: property,
                    sorting: tableState.sortOrderColumn == property.index,
                  ),
              ]
                  .map(
                    (e) => Expanded(
                      child: e,
                    ),
                  )
                  .toList(),
            );
          }
          final book = books[index - 1];
          return ColoredBox(
            color: index.isEven
                ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
                : Colors.transparent,
            child: Row(
              children: [
                for (final property in BookProperty.values)
                  if (property == BookProperty.imageLink)
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image.asset(
                        'assets/${book.imageLink!}',
                        fit: BoxFit.contain,
                        width: 40,
                        height: _rowHeight,
                      ),
                    )
                  else if (property == BookProperty.read)
                    Checkbox(
                      value: book.read,
                      onChanged: (value) {
                        Actions.invoke(context, ToggleReadIntent(book));
                      },
                    )
                  else
                    MyDataCell(
                      book: book,
                      property: property,
                      index: index,
                      isEdited: tableState.editingLocation?.entity == book &&
                          tableState.editingLocation?.column == property.index,
                    )
              ]
                  .map(
                    (e) => Expanded(
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}

class MyDataCell extends StatelessWidget {
  const MyDataCell({
    super.key,
    required this.book,
    required this.property,
    required this.isEdited,
    required this.index,
  });

  final Book book;
  final BookProperty property;
  final bool isEdited;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        CopyIntent: CopyAction(book.valueForProperty(property)),
      },
      child: InkWell(
        onTap: () {
          Actions.invoke(
            context,
            EditCellIntent(
              index,
              property.index,
              book,
            ),
          );
        },
        child: SizedBox(
          height: _rowHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: table.EditableCellContent<Book>(
                content: book.valueForProperty(property),
                onModifiedEntity: (value) => book.copyWithForProperty(
                  value: value,
                  property: property,
                ),
                isEdited: isEdited,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
    required this.property,
    this.sorting = false,
  });

  final BookProperty property;
  final bool sorting;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: property.isSortable
          ? () {
              Actions.invoke(
                context,
                SortIntent(property.index, true),
              );
            }
          : null,
      child: SizedBox(
        height: _rowHeight,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              property.localized(context),
              style: GoogleFonts.sourceSansPro(
                fontWeight: FontWeight.bold,
                decoration: sorting ? TextDecoration.underline : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on BookProperty {
  String localized(BuildContext context) {
    switch (this) {
      case BookProperty.imageLink:
        return context.l10n.cover;
      case BookProperty.author:
        return context.l10n.authorName;
      case BookProperty.title:
        return context.l10n.title;
      case BookProperty.year:
        return context.l10n.year;
      case BookProperty.language:
        return context.l10n.language;
      case BookProperty.read:
        return context.l10n.readBook;
    }
  }
}
