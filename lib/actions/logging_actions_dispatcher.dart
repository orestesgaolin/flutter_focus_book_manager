import 'dart:developer';

import 'package:flutter/material.dart';

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    log('Action invoked: $action($intent) from $context');
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
