// test/widgets/streaming_markdown_content_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flyer_chat_text_stream_message/flyer_chat_text_stream_message.dart'
    as chat_stream;

import 'package:ag_ui_widgets_flutter/src/widgets/streaming_markdown_content.dart';

void main() {
  Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('buildStreamingMarkdownContent', () {
    testWidgets('StreamStateLoading renders the loadingBuilder fallback default (no loadingBuilder given)',
        (tester) async {
      await tester.pumpWidget(host(Builder(
        builder: (context) => buildStreamingMarkdownContent(
          context,
          const chat_stream.StreamStateLoading(),
          paragraphStyle: const TextStyle(),
        ),
      )));
      await tester.pump();
      expect(find.text('...'), findsOneWidget);
    });

    testWidgets('StreamStateLoading uses a custom loadingBuilder when provided', (tester) async {
      await tester.pumpWidget(host(Builder(
        builder: (context) => buildStreamingMarkdownContent(
          context,
          const chat_stream.StreamStateLoading(),
          paragraphStyle: const TextStyle(),
          loadingBuilder: (context, style) => const Text('CUSTOM'),
        ),
      )));
      await tester.pump();
      expect(find.text('CUSTOM'), findsOneWidget);
      expect(find.text('...'), findsNothing);
    });

    testWidgets('StreamStateStreaming with empty text falls back to loading, not an empty markdown body',
        (tester) async {
      await tester.pumpWidget(host(Builder(
        builder: (context) => buildStreamingMarkdownContent(
          context,
          const chat_stream.StreamStateStreaming(''),
          paragraphStyle: const TextStyle(),
        ),
      )));
      await tester.pump();
      expect(find.text('...'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsNothing);
    });

    testWidgets('StreamStateStreaming with content renders via chatMarkdownBody', (tester) async {
      await tester.pumpWidget(host(Builder(
        builder: (context) => buildStreamingMarkdownContent(
          context,
          const chat_stream.StreamStateStreaming('**bold**'),
          paragraphStyle: const TextStyle(),
        ),
      )));
      await tester.pump();
      expect(find.byType(MarkdownBody), findsOneWidget);
      expect(find.text('**bold**'), findsNothing);
    });

    testWidgets('StreamStateCompleted renders via chatMarkdownBody', (tester) async {
      await tester.pumpWidget(host(Builder(
        builder: (context) => buildStreamingMarkdownContent(
          context,
          const chat_stream.StreamStateCompleted('done **now**'),
          paragraphStyle: const TextStyle(),
        ),
      )));
      await tester.pump();
      expect(find.byType(MarkdownBody), findsOneWidget);
    });

    testWidgets('StreamStateError renders accumulated text plus the error message',
        (tester) async {
      await tester.pumpWidget(host(Builder(
        builder: (context) => buildStreamingMarkdownContent(
          context,
          const chat_stream.StreamStateError('boom', accumulatedText: 'partial'),
          paragraphStyle: const TextStyle(),
        ),
      )));
      await tester.pump();
      expect(find.textContaining('partial'), findsOneWidget);
      expect(find.textContaining('boom'), findsOneWidget);
    });
  });
}
