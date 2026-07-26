import "package:flutter_test/flutter_test.dart";
import "package:ag_ui_widgets_flutter/src/transport/ag_ui_transport.dart";

void main() {
  test("AgUiContextItem carries uri and text", () {
    const item = AgUiContextItem(uri: "note:abc", text: "hello");
    expect(item.uri, "note:abc");
    expect(item.text, "hello");
  });

  test("AgUiContextItem supports equality (freezed value semantics)", () {
    const a = AgUiContextItem(uri: "note:abc", text: "hello");
    const b = AgUiContextItem(uri: "note:abc", text: "hello");
    expect(a, equals(b));
  });
}