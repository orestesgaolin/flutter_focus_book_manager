import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusSandboxView extends StatefulWidget {
  const FocusSandboxView({super.key});

  @override
  State<FocusSandboxView> createState() => _FocusSandboxViewState();
}

class _FocusSandboxViewState extends State<FocusSandboxView> {
  final count = 24;
  final focusNodes = <FocusNode>[];
  int? _focused;
  int? _hovering;
  final scrollController = ScrollController();
  String lastKey = '';

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < count; i++) {
      focusNodes.add(FocusNode(debugLabel: 'grid_focus_node_$i'));
    }
  }

  @override
  void dispose() {
    for (final node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleFocusHighlight(int? index) {
    setState(() {
      _focused = index;
    });
  }

  void _handleHoverHighlight(int? index) {
    setState(() {
      _hovering = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('FocusableActionDetector'),
        Expanded(
          child: FocusScope(
            debugLabel: 'grid_focus_scope',
            onKey: (node, key) {
              final keyLabel = key.logicalKey.keyLabel;
              final shift = key.isShiftPressed &&
                      key.logicalKey != LogicalKeyboardKey.shiftLeft
                  ? 'shift +'
                  : '';
              setState(() {
                lastKey = '$shift$keyLabel';
              });
              return KeyEventResult.ignored;
            },
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              controller: scrollController,
              itemCount: count,
              itemBuilder: (context, index) {
                return FocusableActionDetector(
                  focusNode: focusNodes[index],
                  shortcuts: {
                    const SingleActivator(LogicalKeyboardKey.escape):
                        UnfocusIntent(),
                  },
                  actions: {
                    UnfocusIntent: CallbackAction<UnfocusIntent>(
                      onInvoke: (_) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Unfocusing $index'),
                          ),
                        );
                        focusNodes[index].unfocus();
                        return null;
                      },
                    ),
                  },
                  onShowFocusHighlight: (val) =>
                      _handleFocusHighlight(val ? index : null),
                  onShowHoverHighlight: (val) =>
                      _handleHoverHighlight(val ? index : null),
                  child: SizedBox.square(
                    child: GestureDetector(
                      onTap: () {
                        focusNodes[index].requestFocus();
                      },
                      child: ColoredBox(
                        color: _hovering == index
                            ? Colors.grey.withOpacity(0.2)
                            : _focused == index
                                ? Colors.grey
                                : Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$index'),
                            if (_hovering == index)
                              const Text('Hovered')
                            else
                              const Text(''),
                            if (_focused == index)
                              const Text('Focused')
                            else
                              const Text(''),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Text(
          'Recent key: $lastKey',
          style: const TextStyle(fontSize: 37),
        ),
      ],
    );
  }
}

class UnfocusIntent extends Intent {}
