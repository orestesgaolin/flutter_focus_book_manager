part of 'table_cubit.dart';

class TableLocation<T> extends Equatable {
  const TableLocation({
    required this.row,
    required this.column,
    required this.entity,
  });

  final int row;
  final int column;
  final T entity;

  @override
  List<Object?> get props => [
        row,
        column,
        entity,
      ];
}

class TableState<T> extends Equatable {
  const TableState({
    this.sortOrderColumn = 1,
    this.sortAscending = true,
    this.editingLocation,
  });

  final int sortOrderColumn;
  final bool sortAscending;
  final TableLocation<T>? editingLocation;

  @override
  List<Object?> get props => [
        sortOrderColumn,
        sortAscending,
        editingLocation,
      ];

  TableState<T> copyWith({
    int? sortOrderColumn,
    bool? sortAscending,
    TableLocation<T>? editingLocation,
    bool clearEditingLocation = false,
  }) {
    return TableState<T>(
      sortOrderColumn: sortOrderColumn ?? this.sortOrderColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      editingLocation:
          clearEditingLocation ? null : editingLocation ?? this.editingLocation,
    );
  }
}
