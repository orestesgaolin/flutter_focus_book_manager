import 'package:book_manager/focus_tree/focus_tree.dart';
import 'package:book_manager/home/home.dart';
import 'package:book_manager/home/view/adaptive_scaffold.dart';
import 'package:book_manager/l10n/l10n.dart';
import 'package:book_manager/settings/settings.dart';
import 'package:book_manager/table/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeNavigationCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeNavigationCubit>().state;
    return AdaptiveScaffold(
      currentIndex: state,
      onNavigationIndexChange: (index) {
        context.read<HomeNavigationCubit>().select(index);
      },
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.book),
          Text(context.l10n.bookManager),
        ],
      ),
      destinations: [
        AdaptiveScaffoldDestination(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_filled,
          title: context.l10n.books,
        ),
        AdaptiveScaffoldDestination(
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          title: context.l10n.authors,
        ),
        AdaptiveScaffoldDestination(
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          title: context.l10n.settings,
        ),
      ],
      body: IndexedStack(
        index: state,
        children: [
          ExcludeFocus(
            excluding: state != 0,
            child: const BooksTable(),
          ),
          ExcludeFocus(
            excluding: state != 1,
            child: const FocusTree(),
          ),
          ExcludeFocus(
            excluding: state != 2,
            child: const SettingsView(),
          ),
        ],
      ),
    );
  }
}
