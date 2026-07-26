// test/style/bubble_chat_style_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/style/bubble_chat_style.dart';

void main() {
  test('applies defaults for optional fields', () {
    const style = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
      maxWidth: 260,
    );
    expect(style.sentRadius, const BorderRadius.all(Radius.circular(12)));
    expect(style.receivedRadius, const BorderRadius.all(Radius.circular(12)));
    expect(style.padding, const EdgeInsets.symmetric(vertical: 8, horizontal: 12));
    expect(style.sentBorder, isNull);
    expect(style.receivedBorder, isNull);
  });

  test('required fields round-trip', () {
    const style = BubbleChatStyle(
      sentBackground: Colors.blue,
      receivedBackground: Colors.grey,
      textStyle: TextStyle(),
      maxWidth: 300,
    );
    expect(style.maxWidth, 300);
  });
}