import 'package:book_manager/actions/actions.dart';
import 'package:book_manager/books/books.dart';
import 'package:book_manager/books_repository/books_repository.dart';
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
        SaveCellContentIntent: SaveCellContentAction(
          onSave: (value) {
            if (value is Book) {
              context.read<BooksCubit>().update(value);
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
        // when pressing Esc or equivalent
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (intent) {
            final wasFocused = context.read<TableCubit<Book>>().unfocus();
            if (wasFocused) {
              FocusScope.of(context).previousFocus();
            }
            return null;
          },
        ),
        // when leaving the TextField with Tab
        DismissDueToLosingFocusIntent:
            CallbackAction<DismissDueToLosingFocusIntent>(
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
        ToggleReadIntent: CallbackAction<ToggleReadIntent>(
          onInvoke: (intent) {
            context
                .read<BooksCubit>()
                .update(intent.book.copyWith(read: !intent.book.read));
            return null;
          },
        ),
      },
      child: child,
    );
  }
}
