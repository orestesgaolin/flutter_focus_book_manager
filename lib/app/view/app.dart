// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:book_manager/actions/actions.dart';
import 'package:book_manager/app/view/mobile_disclaimer.dart';
import 'package:book_manager/books/books.dart';
import 'package:book_manager/books_repository/repository.dart';
import 'package:book_manager/home/home.dart';
import 'package:book_manager/l10n/l10n.dart';
import 'package:book_manager/settings/settings.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.booksRepository,
  });

  final BooksRepository booksRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BooksCubit(booksRepository)..initialize(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
      ],
      child: MaterialApp(
        theme: FlexThemeData.light(
          scheme: FlexScheme.greyLaw,
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 4,
          appBarOpacity: 0.95,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            blendOnColors: false,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          textTheme: GoogleFonts.sourceSansProTextTheme(),
        ).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AppShortcuts(
          child: MobileDisclaimer(
            child: HomePage(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
