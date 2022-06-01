import 'dart:async';

import 'package:book_manager/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(seconds: 1),
      () => showDialog<void>(
        context: context,
        builder: (context) {
          return const WelcomeDialog();
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          child: const Text('OK'),
        ),
        const GitHubLink(),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.homePart1),
          Text(context.l10n.homePart2),
          Text(context.l10n.disclaimer),
        ],
      ),
    );
  }
}

class GitHubLink extends StatelessWidget {
  const GitHubLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: Uri.parse(
        'https://github.com/orestesgaolin/flutter_focus_book_manager',
      ),
      builder: (context, follow) {
        return ElevatedButton(
          onPressed: () {
            follow?.call();
          },
          child: const Text('GitHub'),
        );
      },
    );
  }
}
