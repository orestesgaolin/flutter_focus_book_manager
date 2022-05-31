import 'package:book_manager/actions/actions.dart';
import 'package:book_manager/books/books.dart';
import 'package:book_manager/table/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksActions extends StatelessWidget {
  const BooksActions({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Actions(
      dispatcher: LoggingActionDispatcher(),
      actions: <Type, Action<Intent>>{
        SaveAllIntent: SaveAllAction(
          onSave: () {
            context.read<TableCubit<Book>>().unfocus();
            context.read<BooksCubit>().saveAll();
          },
        ),
        UnfocusCellIntent: UnfocusCellAction(
          onSave: (value) {
            if (value is Book) {
              context.read<BooksCubit>().update(value);
              final wasFocused = context.read<TableCubit<Book>>().unfocus();
              if (wasFocused) {
                FocusScope.of(context).previousFocus();
              }
            }
          },
        ),
        SortIntent: SortAction(
          onSortChanged: (column, ascending) {
            context.read<TableCubit<Book>>().setSort(column, ascending);
            context
                .read<BooksCubit>()
                .setSort(ascending, BookProperty.values[column]);
          },
        ),
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (intent) {
            final wasFocused = context.read<TableCubit<Book>>().unfocus();
            if (wasFocused) {
              FocusScope.of(context).previousFocus();
            }
            return null;
          },
        ),
        DismissByLosingFocusIntent: CallbackAction<DismissByLosingFocusIntent>(
          onInvoke: (intent) {
            context.read<TableCubit<Book>>().unfocus();
            return null;
          },
        ),
        EditCellIntent: CallbackAction<EditCellIntent>(
          onInvoke: (intent) {
            context
                .read<TableCubit<Book>>()
                .setEditingLocation(intent.row, intent.column, intent.book);
            return null;
          },
        ),
      },
      child: child,
    );
  }
}
