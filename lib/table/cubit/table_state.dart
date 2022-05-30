part of 'table_cubit.dart';

class TableLocation extends Equatable {
  const TableLocation({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;

  @override
  List<Object?> get props => [row, column];
}

class TableState extends Equatable {
  const TableState({
    this.sortOrderColumn = 1,
    this.sortAscending = false,
    this.editingLocation,
  });

  final int sortOrderColumn;
  final bool sortAscending;
  final TableLocation? editingLocation;

  @override
  List<Object?> get props => [
        sortOrderColumn,
        sortAscending,
        editingLocation,
      ];

  TableState copyWith({
    int? sortOrderColumn,
    bool? sortAscending,
    TableLocation? editingLocation,
    bool clearEditingLocation = false,
  }) {
    return TableState(
      sortOrderColumn: sortOrderColumn ?? this.sortOrderColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      editingLocation:
          clearEditingLocation ? null : editingLocation ?? this.editingLocation,
    );
  }
}
