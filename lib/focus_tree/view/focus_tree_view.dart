import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusTree extends StatefulWidget {
  const FocusTree({
    super.key,
  });

  @override
  State<FocusTree> createState() => _FocusTreeState();
}

class _FocusTreeState extends State<FocusTree> {
  String? tree;
  final focusNode1 = FocusNode(debugLabel: 'btn_show_focus_tree');
  final focusNode2 = FocusNode(debugLabel: 'btn_show_widget_tree');
  Timer? timer;

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            primary: false,
            child: SelectableText(
              tree ?? '',
              style: GoogleFonts.firaMono(fontSize: 14),
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton(
              focusNode: focusNode1,
              child: const Text('Print Focus Tree'),
              onPressed: () {
                final debugTree = debugDescribeFocusTree();
                setState(() {
                  tree = debugTree;
                });
              },
            ),
            ElevatedButton(
              focusNode: focusNode1,
              child: const Text('Print Focus Tree in 3 sec'),
              onPressed: () {
                if (timer != null) {
                  timer?.cancel();
                }
                timer = Timer(
                  const Duration(seconds: 3),
                  () {
                    final debugTree = debugDescribeFocusTree();
                    setState(() {
                      tree = debugTree;
                    });
                  },
                );
              },
            ),
            ElevatedButton(
              focusNode: focusNode2,
              child: const Text('Print Widget Tree'),
              onPressed: () {
                final debugTree =
                    WidgetsBinding.instance.renderViewElement!.toStringDeep();

                setState(() {
                  tree = debugTree;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
