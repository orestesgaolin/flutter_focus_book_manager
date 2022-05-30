import 'package:book_manager/books/books.dart';
import 'package:book_manager/l10n/l10n.dart';
import 'package:book_manager/table/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksTable extends StatelessWidget {
  const BooksTable({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BooksCubit>().state;

    if (state is BooksInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    final books = (state as BooksLoaded).books;
    return BlocProvider(
      create: (context) => TableCubit(),
      child: BooksTableView(books: books),
    );
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
    final tableState = context.watch<TableCubit>().state;
    return DataTable(
      onSelectAll: (x) {},
      sortColumnIndex: tableState.sortOrderColumn,
      sortAscending: tableState.sortAscending,
      columnSpacing: 8,
      columns: <DataColumn>[
        DataColumn(label: Text(context.l10n.cover)),
        DataColumn(
          label: Text(context.l10n.authorName),
          onSort: (index, sort) {
            context.read<TableCubit>().setSort(index, sort);
          },
        ),
        DataColumn(
          label: Text(context.l10n.title),
          onSort: (index, sort) {
            context.read<TableCubit>().setSort(index, sort);
          },
        ),
        DataColumn(
          label: Text(context.l10n.year),
          onSort: (index, sort) {
            context.read<TableCubit>().setSort(index, sort);
          },
          numeric: true,
        ),
        DataColumn(
          label: Text(context.l10n.language),
          onSort: (index, sort) {
            context.read<TableCubit>().setSort(index, sort);
          },
        ),
      ],
      rows: List<DataRow>.generate(
        books.length,
        (index) => DataRow(
          color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            // All rows will have the same selected color.
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.16);
            }
            // Even rows will have a grey color.
            if (index.isEven) {
              return Theme.of(context).colorScheme.primary.withOpacity(0.08);
            }
            return null;
          }),
          cells: [
            if (books[index].imageLink != null)
              DataCell(
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    'assets/${books[index].imageLink!}',
                    fit: BoxFit.cover,
                    width: 40,
                    height: 50,
                  ),
                ),
                onTap: () {},
              )
            else
              DataCell.empty,
            DataCell(
              EditableCellContent(
                book: books[index],
                index: index,
                column: 1,
              ),
              onTap: () {
                context.read<TableCubit>().setEditingLocation(index, 1);
              },
            ),
            DataCell(
              BlocBuilder<TableCubit, TableState>(
                builder: (context, state) {
                  if (state.editingLocation ==
                      TableLocation(row: index, column: 2)) {
                    return TextFormField(
                      initialValue: books[index].title,
                    );
                  }
                  return Text(books[index].title ?? '');
                },
              ),
              onTap: () {
                context.read<TableCubit>().setEditingLocation(index, 2);
              },
            ),
            DataCell(
              Text(books[index].year.toString()),
              onTap: () {
                context.read<TableCubit>().setEditingLocation(index, 3);
              },
            ),
            DataCell(
              Text(books[index].language ?? ''),
              onTap: () {
                context.read<TableCubit>().setEditingLocation(index, 4);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditableCellContent extends StatefulWidget {
  const EditableCellContent({
    super.key,
    required this.book,
    required this.index,
    required this.column,
  });

  final Book book;
  final int index;
  final int column;

  @override
  State<EditableCellContent> createState() => _EditableCellContentState();
}

class _EditableCellContentState extends State<EditableCellContent> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.text = widget.book.author ?? '';
    // ignore: cascade_invocations
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.book.author?.length ?? 0,
    );
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableCubit, TableState>(
      builder: (context, state) {
        if (state.editingLocation ==
            TableLocation(row: widget.index, column: widget.column)) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(fontSize: 14),
            onFieldSubmitted: (value) {
              context.read<TableCubit>().save();
            },
          );
        }
        return Text(widget.book.author ?? '');
      },
    );
  }
}
