import 'package:book_manager/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MobileDisclaimer extends StatelessWidget {
  const MobileDisclaimer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return const SizedBox.shrink();
            }
            return Material(
              color: Colors.white70,
              child: Text(
                context.l10n.disclaimer,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ],
    );
  }
}
