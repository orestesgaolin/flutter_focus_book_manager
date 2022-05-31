// ignore_for_file: unused_element

import 'package:book_manager/books/books.dart';
import 'package:book_manager/l10n/l10n.dart';
import 'package:book_manager/table/table.dart' as table;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksTableView extends StatelessWidget {
  const BooksTableView({
    required this.books,
    super.key,
  });

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final tableState = context.watch<table.TableCubit<Book>>().state;
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                for (final property in BookProperty.values)
                  _Header(property: property),
              ],
            ),
          );
        }
        final book = books[index - 1];
        return Row(
          children: [
            for (final property in BookProperty.values)
              if (property == BookProperty.imageLink)
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    'assets/${book.imageLink!}',
                    fit: BoxFit.contain,
                    width: 40,
                    height: 50,
                  ),
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
        );
      },
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
        table.CopyIntent: table.CopyAction(book.valueForProperty(property)),
      },
      child: InkWell(
        onTap: () {
          Actions.invoke(
            context,
            table.EditCellIntent(
              index,
              property.index,
              book,
            ),
          );
        },
        child: SizedBox(
          height: 60,
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
  });

  final BookProperty property;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: property.isSortable
            ? () {
                Actions.invoke(
                  context,
                  table.SortIntent(property.index, true),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            property.localized(context),
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
    }
  }
}
