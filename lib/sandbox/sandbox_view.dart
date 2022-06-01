import 'package:flutter/material.dart';

class FocusSandboxView extends StatelessWidget {
  const FocusSandboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: 24,
      itemBuilder: (context, index) {
        return InkWell(
          focusNode: FocusNode(debugLabel: 'focus_node_$index'),
          onTap: () {},
          child: SizedBox.square(
            child: Center(child: Text('$index')),
          ),
        );
      },
    );
  }
}
