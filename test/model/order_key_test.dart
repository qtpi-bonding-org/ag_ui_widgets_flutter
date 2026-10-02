import 'package:flutter_test/flutter_test.dart';
import 'package:ag_ui_widgets_flutter/src/model/conversation.dart';

void main() {
  test('orders by seq, then sub', () {
    expect(const OrderKey(1).compareTo(const OrderKey(2)), isNegative);
    expect(const OrderKey(2, 1).compareTo(const OrderKey(2)), isPositive);
    expect(const OrderKey(2, 1).compareTo(const OrderKey(2, 1)), isZero);
  });

  test('has value equality and defaults sub to 0', () {
    expect(const OrderKey(3), const OrderKey(3, 0));
    expect(const OrderKey(3).hashCode, const OrderKey(3, 0).hashCode);
    expect(const OrderKey(3, 1), isNot(const OrderKey(3, 2)));
  });

  test('copyWith changes one component', () {
    expect(const OrderKey(3, 1).copyWith(sub: 2), const OrderKey(3, 2));
  });
}
