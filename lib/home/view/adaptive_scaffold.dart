// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:book_manager/home/home.dart';
import 'package:book_manager/ui/ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

bool _isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > largeScreenBreakpoint;
}

bool _isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > mediumScreenBreakpoint;
}

/// See bottomNavigationBarItem or NavigationRailDestination
class AdaptiveScaffoldDestination extends Equatable {
  const AdaptiveScaffoldDestination({
    required this.title,
    required this.icon,
    required this.selectedIcon,
  });

  final String title;
  final IconData icon;
  final IconData selectedIcon;

  @override
  List<Object?> get props => [title, icon, selectedIcon];
}

/// A widget that adapts to the current display size, displaying a [Drawer],
/// [NavigationRail], or [BottomNavigationBar]. Navigation destinations are
/// defined in the [destinations] parameter.
class AdaptiveScaffold extends StatefulWidget {
  const AdaptiveScaffold({
    this.title,
    this.body,
    this.actions = const [],
    required this.currentIndex,
    required this.destinations,
    this.onNavigationIndexChange,
    this.floatingActionButton,
    super.key,
  });

  final Widget? title;
  final List<Widget> actions;
  final Widget? body;
  final int currentIndex;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int>? onNavigationIndexChange;
  final FloatingActionButton? floatingActionButton;

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  final focusNodes = <AdaptiveScaffoldDestination, FocusNode>{};
  @override
  void initState() {
    super.initState();
    for (final destination in widget.destinations) {
      focusNodes[destination] =
          FocusNode(debugLabel: 'menu_${destination.title}');
    }
  }

  @override
  void dispose() {
    for (final node in focusNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show a Drawer
    if (_isLargeScreen(context)) {
      return Row(
        children: [
          Drawer(
            child: FocusTraversalGroup(
              child: Column(
                children: [
                  DrawerHeader(
                    child: Center(
                      child: widget.title,
                    ),
                  ),
                  for (final d in widget.destinations)
                    ListTile(
                      leading:
                          widget.destinations.indexOf(d) == widget.currentIndex
                              ? Icon(d.selectedIcon)
                              : Icon(d.icon),
                      title: Text(d.title),
                      selected:
                          widget.destinations.indexOf(d) == widget.currentIndex,
                      onTap: () => _destinationTapped(d),
                      focusNode: focusNodes[d],
                    ),
                  const Spacer(),
                  const GitHubLink()
                ],
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Scaffold(
              body: widget.body,
              floatingActionButton: widget.floatingActionButton,
            ),
          ),
        ],
      );
    }

    // Show a navigation rail
    if (_isMediumScreen(context)) {
      return Scaffold(
        body: Row(
          children: [
            Column(
              children: [
                Flexible(
                  child: FocusTraversalGroup(
                    child: NavigationRail(
                      leading: widget.floatingActionButton,
                      destinations: [
                        ...widget.destinations.map(
                          (d) => NavigationRailDestination(
                            icon: Icon(d.icon),
                            selectedIcon: Icon(d.selectedIcon),
                            label: Text(d.title),
                          ),
                        ),
                      ],
                      selectedIndex: widget.currentIndex,
                      onDestinationSelected:
                          widget.onNavigationIndexChange ?? (_) {},
                    ),
                  ),
                ),
                const GitHubLink()
              ],
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Expanded(
              child: widget.body!,
            ),
          ],
        ),
      );
    }

    // Show a bottom app bar
    return Scaffold(
      body: widget.body,
      appBar: AppBar(
        title: widget.title,
        actions: widget.actions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          ...widget.destinations.map(
            (d) => BottomNavigationBarItem(
              icon: Icon(d.icon),
              activeIcon: Icon(d.selectedIcon),
              label: d.title,
            ),
          ),
        ],
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationIndexChange,
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  void _destinationTapped(AdaptiveScaffoldDestination destination) {
    final idx = widget.destinations.indexOf(destination);
    if (idx != widget.currentIndex) {
      widget.onNavigationIndexChange!(idx);
    }
  }
}
