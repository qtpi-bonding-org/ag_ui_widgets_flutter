// lib/src/widgets/transcript_scroll_controller.dart
//
// Stick-to-bottom policy for a NON-REVERSED transcript.
//
// Two hard-won constraints drive this design; neither is obvious.
//
// 1. Content growth does NOT dispatch ScrollMetricsNotification. Confirmed by
//    episutra via an isolated flutter_test repro (bare ListView.builder plus a
//    NotificationListener): growing itemCount through setState — the shape of
//    a streaming rebuild — never reaches a listener in this SDK version, even
//    after pumpAndSettle, while real drags dispatch correctly. So the re-stick
//    is driven by scheduleStick() on every rebuild, and notifications are used
//    ONLY to decide whether we are armed.
//
//    (flutter_chat_ui does listen for ScrollMetricsNotification and gets away
//    with it because SliverAnimatedList inserts dispatch. We are the setState
//    shape, so that route is unavailable.)
//
// 2. maxScrollExtent is unstable while a lazy sliver builds. Per
//    flutter_chat_ui's ChatAnimatedList (Apache-2.0), Flutter "might return a
//    bunch of 0 values for maxScrollExtent" as a list becomes scrollable, and
//    a single jump does not land. So: skip zero-extent frames, and re-jump on
//    successive frames until offset == maxScrollExtent.
//
// Arming keys off UserScrollNotification rather than a distance threshold,
// also following flutter_chat_ui: UserScrollNotification fires only for
// user-initiated drags, so our own jumpTo cannot accidentally disarm us.
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class TranscriptScrollController {
  TranscriptScrollController();

  /// Tolerance for "is at the end". Generous on purpose — this only needs to
  /// catch "basically at the bottom", and a single message easily exceeds it.
  static const double _endTolerance = 80.0;

  /// Cap on the re-jump chase. The extent must converge; this stops a
  /// pathological layout from spinning post-frame callbacks forever.
  static const int _maxSettleAttempts = 10;

  final ScrollController controller = ScrollController();

  bool _armed = true;
  bool _stickScheduled = false;
  int _settleAttempts = 0;
  bool _userScrollActive = false;

  bool get isArmed => _armed;

  /// Call on submit: the user just acted, so follow the output again.
  /// Schedules a stick itself — the caller may not trigger a rebuild.
  void rearm() {
    _armed = true;
    _settleAttempts = 0;
    scheduleStick();
  }

  void handleNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (!metrics.hasContentDimensions) return;

    // ORDERING IS LOAD-BEARING. UserScrollNotification is dispatched from
    // ScrollPositionWithSingleContext.applyUserOffset BEFORE setPixels runs
    // for that same delta, so its metrics predate the movement. When the user
    // starts dragging away from the end, those stale metrics still read "at
    // the end" — so re-arming from this notification would instantly undo the
    // disarm we just performed. Return early and let a later notification,
    // which carries post-movement metrics, do any re-arming.
    if (notification is UserScrollNotification) {
      _userScrollActive = notification.direction != ScrollDirection.idle;
      // forward == scrolling toward offset 0, i.e. away from the end on a
      // non-reversed list. Only a real drag can disarm; our own jumpTo emits
      // ScrollUpdateNotification but never UserScrollNotification.
      if (notification.direction == ScrollDirection.forward) {
        _armed = false;
        // Abandoning a chase mid-flight: clear the counter, or its leftover
        // value silently shortens the NEXT legitimate chase.
        _settleAttempts = 0;
      }
      return;
    }

    // Intermediate updates from a user gesture can still carry metrics
    // within the end tolerance. The completed gesture's metrics are the
    // ones that may re-arm the policy.
    if (_userScrollActive && notification is ScrollUpdateNotification) {
      return;
    }

    // ScrollUpdate / ScrollEnd carry post-movement metrics, so they can
    // safely re-arm once the user has actually returned to the end.
    if (metrics.maxScrollExtent - metrics.pixels <= _endTolerance) {
      if (!_armed) _settleAttempts = 0;
      _armed = true;
    }
  }

  /// Schedule a post-frame re-stick. Safe to call on every build; repeated
  /// calls within one frame collapse into one.
  void scheduleStick() {
    if (_stickScheduled) return;
    _stickScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stickScheduled = false;
      _stickIfArmed();
    });
  }

  void _stickIfArmed() {
    // Every path that ends a chase must clear the counter. A leftover count
    // from an abandoned chase would truncate an unrelated later one.
    if (!_armed || !controller.hasClients) {
      _settleAttempts = 0;
      return;
    }
    final position = controller.position;
    if (!position.hasContentDimensions) {
      _settleAttempts = 0;
      return;
    }

    // Constraint 2: a run of zeros means the list is not scrollable yet.
    // Returning without rescheduling ends this chase — the next build's
    // scheduleStick() starts a fresh one — so clear the counter too.
    if (position.maxScrollExtent == 0) {
      _settleAttempts = 0;
      return;
    }

    final target = position.maxScrollExtent;
    // Tolerance, not ==: scroll offsets are doubles and need not land exactly.
    if ((position.pixels - target).abs() < 0.5) {
      _settleAttempts = 0;
      return;
    }

    position.jumpTo(target);

    // The jump may not have landed if the sliver is still building — the
    // extent can grow again on the next frame. Chase it, but bounded.
    if (_settleAttempts++ < _maxSettleAttempts) {
      scheduleStick();
    } else {
      _settleAttempts = 0;
    }
  }

  void dispose() => controller.dispose();
}
