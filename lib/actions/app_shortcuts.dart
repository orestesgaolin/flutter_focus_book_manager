import 'package:book_manager/actions/actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppShortcuts extends StatelessWidget {
  const AppShortcuts({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      manager: LoggingShortcutManager(),
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.save): const SaveAllIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS):
            const SaveAllIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyA):
            Intent.doNothing,
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyC):
            const CopyIntent(),
        LogicalKeySet(LogicalKeyboardKey.f2): const ActivateIntent(),
        // other ways:
        const CharacterActivator('x'): Intent.doNothing,
        const SingleActivator(LogicalKeyboardKey.comma): Intent.doNothing,
      },
      child: child,
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
