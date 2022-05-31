// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:developer';

import 'package:book_manager/actions/actions.dart';
import 'package:book_manager/books/cubit/books_cubit.dart';
import 'package:book_manager/home/home.dart';
import 'package:book_manager/l10n/l10n.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BooksCubit()..initialize(),
        ),
      ],
      child: MaterialApp(
        theme: FlexThemeData.light(
          scheme: FlexScheme.greyLaw,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 20,
          appBarOpacity: 0.95,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            blendOnColors: false,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.greyLaw,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          appBarStyle: FlexAppBarStyle.background,
          appBarOpacity: 0.90,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 30,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily,
        ).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const ActionsHandling(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ActionsHandling extends StatelessWidget {
  const ActionsHandling({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      manager: LoggingShortcutManager(),
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS):
            const SaveAllIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyC):
            const CopyIntent(),
        LogicalKeySet(LogicalKeyboardKey.f2): const ActivateIntent(),
      },
      child: const HomePage(),
    );
  }
}

/// A ShortcutManager that logs all keys that it handles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event) {
    final result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      // ignore: avoid_print
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}
