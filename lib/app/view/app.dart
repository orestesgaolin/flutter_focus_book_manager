// Copyright (c) 2022, Dominik Roszkowski
// https://roszkowski.dev
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyW):
            const SelectAllIntent(),
      },
      child: Actions(
        dispatcher: LoggingActionDispatcher(),
        actions: <Type, Action<Intent>>{
          SelectAllIntent: SelectAllAction(),
        },
        child: const HomePage(),
      ),
    );
  }
}

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);
    if (context != null) {
      showOverlay(context, intent);
    }

    return null;
  }

  Future<void> showOverlay(BuildContext context, Intent intent) async {
    final overlayState = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Stack(
            children: [
              Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Intent: ${intent.toStringShort()}',
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Inserting the OverlayEntry into the Overlay
    overlayState?.insert(overlayEntry);

    // Awaiting for 3 seconds
    await Future<void>.delayed(const Duration(seconds: 2));

    // Removing the OverlayEntry from the Overlay
    overlayEntry.remove();
  }
}

/// A ShortcutManager that logs all keys that it handles.
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event) {
    final result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}

/// An intent that is bound to SelectAllAction to select all the text in its
/// controller.
class SelectAllIntent extends Intent {
  const SelectAllIntent();
}

/// An action that is bound to SelectAllAction that selects all text in its
/// TextEditingController.
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction();

  @override
  Object? invoke(covariant SelectAllIntent intent) {
    print('Hello');
    return null;
  }
}
