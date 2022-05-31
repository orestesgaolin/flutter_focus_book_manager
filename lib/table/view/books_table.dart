import 'package:book_manager/actions/actions.dart';
import 'package:book_manager/books/books.dart';
import 'package:book_manager/l10n/l10n.dart';
import 'package:book_manager/table/table.dart';
import 'package:book_manager/table_copyable/table.dart' as copy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksTable extends StatelessWidget {
  const BooksTable({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BooksCubit>().state;

    final books = state.booksList;
    return BlocProvider(
      create: (context) => TableCubit<Book>(),
      child: LayoutBuilder(
        // builder: (context, box) {
        //   if (box.maxWidth < 800) {
        //     return SingleChildScrollView(
        //       scrollDirection: Axis.horizontal,
        //       child: BooksActions(child: BooksTableView(books: books)),
        //     );
        //   }
        //   return BooksActions(child: BooksTableView(books: books));
        // },
        builder: (context, box) {
          if (box.maxWidth < 800) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BooksActions(child: copy.BooksTableView(books: books)),
            );
          }
          return BooksActions(child: copy.BooksTableView(books: books));
        },
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

class BooksTableView extends StatelessWidget {
  const BooksTableView({
    required this.books,
    super.key,
  });

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final tableState = context.watch<TableCubit<Book>>().state;

    return DataTable(
      onSelectAll: (x) {},
      sortColumnIndex: tableState.sortOrderColumn,
      sortAscending: tableState.sortAscending,
      columnSpacing: 8,
      columns: <DataColumn>[
        for (final property in BookProperty.values)
          DataColumn(
            label: Text(property.localized(context)),
            onSort: property.isSortable
                ? (index, sort) {
                    Actions.invoke(context, SortIntent(property.index, sort));
                  }
                : null,
            numeric: property.isNumeric,
          )
      ],
      rows: List<DataRow>.generate(
        books.length,
        (index) {
          final book = books[index];
          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                // All rows will have the same selected color.
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.16);
                }
                // Even rows will have a grey color.
                if (index.isEven) {
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.08);
                }
                return null;
              },
            ),
            cells: [
              if (book.imageLink != null)
                DataCell(
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.asset(
                      'assets/${book.imageLink!}',
                      fit: BoxFit.cover,
                      width: 40,
                      height: 50,
                    ),
                  ),
                )
              else
                DataCell.empty,
              for (final property in BookProperty.values)
                if (property == BookProperty.author)
                  DataCell(
                    EditableCellContent<Book>(
                      content: book.author,
                      onModifiedEntity: (value) => book.copyWith(author: value),
                      isEdited: tableState.editingLocation?.entity == book &&
                          tableState.editingLocation?.column == property.index,
                    ),
                    onTap: () {
                      context
                          .read<TableCubit<Book>>()
                          .setEditingLocation(index, property.index, book);
                    },
                  )
                else if (property == BookProperty.title)
                  DataCell(
                    EditableCellContent<Book>(
                      content: book.title,
                      onModifiedEntity: (value) => book.copyWith(title: value),
                      isEdited: tableState.editingLocation?.entity == book &&
                          tableState.editingLocation?.column == property.index,
                    ),
                    onTap: () {
                      context
                          .read<TableCubit<Book>>()
                          .setEditingLocation(index, property.index, book);
                    },
                  )
                else if (property == BookProperty.year)
                  DataCell(
                    EditableCellContent<Book>(
                      content: book.year.toString(),
                      onModifiedEntity: (value) =>
                          book.copyWith(year: int.tryParse(value)),
                      isEdited: tableState.editingLocation?.entity == book &&
                          tableState.editingLocation?.column == property.index,
                    ),
                    onTap: () {
                      context
                          .read<TableCubit<Book>>()
                          .setEditingLocation(index, property.index, book);
                    },
                  )
                else if (property == BookProperty.language)
                  DataCell(
                    EditableCellContent<Book>(
                      content: book.language,
                      onModifiedEntity: (value) =>
                          book.copyWith(language: value),
                      isEdited: tableState.editingLocation?.entity == book &&
                          tableState.editingLocation?.column == property.index,
                    ),
                    onTap: () {
                      context
                          .read<TableCubit<Book>>()
                          .setEditingLocation(index, property.index, book);
                    },
                  )
                else if (property == BookProperty.read)
                  DataCell(
                    Checkbox(
                      value: book.read,
                      onChanged: (value) {
                        Actions.invoke(context, ToggleReadIntent(book));
                      },
                    ),
                  )
            ],
          );
        },
      ),
    );
  }
}
