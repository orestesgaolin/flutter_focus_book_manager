import 'package:book_manager/l10n/l10n.dart';
import 'package:book_manager/settings/cubit/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;

    return Column(
      children: [
        CheckboxListTile(
          value: state.experimentalTable,
          title: Text(context.l10n.experimentalTable),
          onChanged: (_) {
            context.read<SettingsCubit>().toggleExperimentalTable();
          },
        ),
        Text(context.l10n.disclaimer),
      ],
    );
  }
}
