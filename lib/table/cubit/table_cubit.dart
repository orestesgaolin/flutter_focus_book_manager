import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'table_state.dart';

class TableCubit<T> extends Cubit<TableState<T>> {
  TableCubit() : super(TableState<T>());

  void setSort(int index, bool sort) {
    emit(
      state.copyWith(
        sortOrderColumn: index,
        sortAscending: sort,
      ),
    );
  }

  void setEditingLocation(int index, int column, T entity) {
    emit(
      state.copyWith(
        editingLocation: TableLocation<T>(
          row: index,
          column: column,
          entity: entity,
        ),
      ),
    );
  }

  bool unfocus() {
    final wasFocused = state.editingLocation != null;
    emit(state.copyWith(clearEditingLocation: true));
    return wasFocused;
  }
}
