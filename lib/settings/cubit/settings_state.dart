part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.experimentalTable = false,
  });

  final bool experimentalTable;

  @override
  List<Object?> get props => [experimentalTable];

  SettingsState copyWith({
    bool? experimentalTable,
  }) {
    return SettingsState(
      experimentalTable: experimentalTable ?? this.experimentalTable,
    );
  }
}
