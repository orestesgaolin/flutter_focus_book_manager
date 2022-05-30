import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'table_state.dart';

class TableCubit extends Cubit<TableState> {
  TableCubit() : super(const TableState());

  void setSort(int index, bool sort) {
    emit(
      state.copyWith(
        sortOrderColumn: index,
        sortAscending: sort,
      ),
    );
  }

  void setEditingLocation(int index, int column) {
    emit(
      state.copyWith(
        editingLocation: TableLocation(row: index, column: column),
      ),
    );
  }

  void save() {
    emit(state.copyWith(clearEditingLocation: true));
  }
}
