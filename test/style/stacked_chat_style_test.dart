// test/style/stacked_chat_style_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/style/stacked_chat_style.dart';

void main() {
  test('applies defaults for optional fields', () {
    const style = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
    );
    expect(style.padding, const EdgeInsets.symmetric(vertical: 8, horizontal: 12));
    expect(style.cardRadius, const BorderRadius.all(Radius.circular(8)));
    expect(style.cardBorderColor, isNull);
    expect(style.aiLeadingIconBuilder, isNull);
    expect(style.markdownStyleSheetBuilder, isNull);
  });

  test('required fields round-trip', () {
    const style = StackedChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(fontSize: 14),
    );
    expect(style.sentBackground, Colors.blue);
    expect(style.receivedBackground, Colors.grey);
    expect(style.textStyle.fontSize, 14);
  });
}