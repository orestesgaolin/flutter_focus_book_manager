import 'package:book_manager/home/home.dart';
import 'package:book_manager/l10n/l10n.dart';
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
    return Scaffold(
      body: Row(
        children: const [
          HomeNavigationRail(),
          Expanded(
            child: BooksTable(),
          )
        ],
      ),
    );
  }
}

class HomeNavigationRail extends StatelessWidget {
  const HomeNavigationRail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: NavigationRail(
        selectedIndex: context.watch<HomeNavigationCubit>().state,
        onDestinationSelected: (index) {
          context.read<HomeNavigationCubit>().select(index);
        },
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_filled),
            label: Text(context.l10n.books),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: Text(context.l10n.authors),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: Text(context.l10n.settings),
          ),
        ],
      ),
    );
  }
}
