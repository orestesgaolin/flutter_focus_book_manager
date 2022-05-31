import 'package:book_manager/books/books.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// An intent that is bound to SaveAllAction to Save all the books
class SaveAllIntent extends Intent {
  const SaveAllIntent();
}

/// An action that is bound to SaveAllAction
class SaveAllAction extends Action<SaveAllIntent> {
  SaveAllAction({required this.onSave});

  final VoidCallback onSave;

  @override
  Object? invoke(covariant SaveAllIntent intent) {
    onSave();
    return null;
  }
}

class UnfocusCellIntent extends Intent {
  const UnfocusCellIntent(this.entity);

  final Object entity;
}

class UnfocusCellAction extends Action<UnfocusCellIntent> {
  UnfocusCellAction({required this.onSave});

  final Function(Object) onSave;

  @override
  Object? invoke(covariant UnfocusCellIntent intent) {
    onSave(intent.entity);
    return null;
  }
}

class SortIntent extends Intent {
  const SortIntent(this.index, this.ascending);

  final int index;
  final bool ascending;
}

class SortAction extends Action<SortIntent> {
  SortAction({required this.onSortChanged});

  final Function(int, bool) onSortChanged;

  @override
  Object? invoke(covariant SortIntent intent) {
    onSortChanged(intent.index, intent.ascending);
    return null;
  }
}

class CopyIntent extends Intent {
  const CopyIntent();
}

class CopyAction extends Action<CopyIntent> {
  CopyAction(this.value);

  final String? value;

  @override
  Object? invoke(covariant CopyIntent intent) {
    if (value != null) {
      Clipboard.setData(ClipboardData(text: value));
    }
    return null;
  }
}

class EditCellIntent extends Intent {
  const EditCellIntent(
    this.row,
    this.column,
    this.book,
  );
  final int row;
  final int column;
  final Book book;
}

class DismissByLosingFocusIntent extends Intent {
  const DismissByLosingFocusIntent();
}
