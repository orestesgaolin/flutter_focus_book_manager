import 'package:book_manager/actions/actions.dart';
import 'package:flutter/material.dart';

class EditableCellContent<T> extends StatefulWidget {
  const EditableCellContent({
    super.key,
    required this.content,
    required this.onModifiedEntity,
    this.isEdited = false,
  });

  final String? content;
  final bool isEdited;
  final T Function(String value) onModifiedEntity;

  @override
  State<EditableCellContent> createState() => _EditableCellContentState<T>();
}

class _EditableCellContentState<T> extends State<EditableCellContent<T>> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasPrimaryFocus == false) {
        Actions.invoke(
          context,
          const DismissDueToLosingFocusIntent(),
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant EditableCellContent<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // capture focus when changed to edit mode
    if (oldWidget.isEdited == false && widget.isEdited == true) {
      focusNode.requestFocus();
      controller.text = widget.content ?? '';
      // ignore: cascade_invocations
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: widget.content?.length ?? 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEdited) {
      return TextFormField(
        controller: controller,
        focusNode: focusNode,
        decoration: const InputDecoration(
          suffix: Icon(
            Icons.edit_outlined,
            size: 14,
          ),
        ),
        style: const TextStyle(fontSize: 14),
        onFieldSubmitted: (value) {
          Actions.invoke<SaveCellContentIntent>(
            context,
            SaveCellContentIntent(widget.onModifiedEntity(value) as Object),
          );
        },
      );
    }
    return Text(
      widget.content ?? '',
    );
  }
}
