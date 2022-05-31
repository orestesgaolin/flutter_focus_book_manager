import 'package:flutter/material.dart';

/// An ActionDispatcher that logs all the actions that it invokes.
class LoggingActionDispatcher extends ActionDispatcher {
  OverlayEntry? currentOverlay;

  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    // ignore: avoid_print
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);
    if (context != null) {
      showOverlay(context, intent, action);
    }

    return null;
  }

  Future<void> showOverlay(
    BuildContext context,
    Intent intent,
    Action<Intent> action,
  ) async {
    final overlayState = Overlay.of(context);

    if (currentOverlay?.mounted == true) {
      currentOverlay?.remove();
    }

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
                    child: Column(
                      children: [
                        Text(
                          'Intent: ${intent.toStringShort()}',
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          'Action: ${action.toStringShort()}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
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
    currentOverlay = overlayEntry;

    // Awaiting for 3 seconds
    await Future<void>.delayed(
      const Duration(seconds: 2),
      () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      },
    );
  }
}
