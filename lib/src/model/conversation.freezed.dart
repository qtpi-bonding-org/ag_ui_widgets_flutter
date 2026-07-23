// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimelineItem {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is TimelineItem);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'TimelineItem()';
  }
}

/// @nodoc
class $TimelineItemCopyWith<$Res> {
  $TimelineItemCopyWith(TimelineItem _, $Res Function(TimelineItem) __);
}

/// Adds pattern-matching-related methods to [TimelineItem].
extension TimelineItemPatterns on TimelineItem {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TextTimelineItem value)? text,
    TResult Function(TextStreamTimelineItem value)? textStream,
    TResult Function(ToolCallTimelineItem value)? toolCall,
    TResult Function(PermissionTimelineItem value)? permission,
    TResult Function(ElicitationTimelineItem value)? elicitation,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(_that);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(_that);
      case PermissionTimelineItem() when permission != null:
        return permission(_that);
      case ElicitationTimelineItem() when elicitation != null:
        return elicitation(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TextTimelineItem value) text,
    required TResult Function(TextStreamTimelineItem value) textStream,
    required TResult Function(ToolCallTimelineItem value) toolCall,
    required TResult Function(PermissionTimelineItem value) permission,
    required TResult Function(ElicitationTimelineItem value) elicitation,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem():
        return text(_that);
      case TextStreamTimelineItem():
        return textStream(_that);
      case ToolCallTimelineItem():
        return toolCall(_that);
      case PermissionTimelineItem():
        return permission(_that);
      case ElicitationTimelineItem():
        return elicitation(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TextTimelineItem value)? text,
    TResult? Function(TextStreamTimelineItem value)? textStream,
    TResult? Function(ToolCallTimelineItem value)? toolCall,
    TResult? Function(PermissionTimelineItem value)? permission,
    TResult? Function(ElicitationTimelineItem value)? elicitation,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(_that);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(_that);
      case PermissionTimelineItem() when permission != null:
        return permission(_that);
      case ElicitationTimelineItem() when elicitation != null:
        return elicitation(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, ChatMessageKind kind, String role, String text)?
        text,
    TResult Function(String id, String role, String text)? textStream,
    TResult Function(String id, String name, String args, String? result)?
        toolCall,
    TResult Function(String requestId)? permission,
    TResult Function(String requestId)? elicitation,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that.id, _that.kind, _that.role, _that.text);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(_that.id, _that.role, _that.text);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(_that.id, _that.name, _that.args, _that.result);
      case PermissionTimelineItem() when permission != null:
        return permission(_that.requestId);
      case ElicitationTimelineItem() when elicitation != null:
        return elicitation(_that.requestId);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id, ChatMessageKind kind, String role, String text)
        text,
    required TResult Function(String id, String role, String text) textStream,
    required TResult Function(
            String id, String name, String args, String? result)
        toolCall,
    required TResult Function(String requestId) permission,
    required TResult Function(String requestId) elicitation,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem():
        return text(_that.id, _that.kind, _that.role, _that.text);
      case TextStreamTimelineItem():
        return textStream(_that.id, _that.role, _that.text);
      case ToolCallTimelineItem():
        return toolCall(_that.id, _that.name, _that.args, _that.result);
      case PermissionTimelineItem():
        return permission(_that.requestId);
      case ElicitationTimelineItem():
        return elicitation(_that.requestId);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id, ChatMessageKind kind, String role, String text)?
        text,
    TResult? Function(String id, String role, String text)? textStream,
    TResult? Function(String id, String name, String args, String? result)?
        toolCall,
    TResult? Function(String requestId)? permission,
    TResult? Function(String requestId)? elicitation,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that.id, _that.kind, _that.role, _that.text);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(_that.id, _that.role, _that.text);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(_that.id, _that.name, _that.args, _that.result);
      case PermissionTimelineItem() when permission != null:
        return permission(_that.requestId);
      case ElicitationTimelineItem() when elicitation != null:
        return elicitation(_that.requestId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class TextTimelineItem implements TimelineItem {
  const TextTimelineItem(
      {required this.id,
      required this.kind,
      required this.role,
      required this.text});

  final String id;
  final ChatMessageKind kind;
  final String role;
  final String text;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TextTimelineItemCopyWith<TextTimelineItem> get copyWith =>
      _$TextTimelineItemCopyWithImpl<TextTimelineItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TextTimelineItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, kind, role, text);

  @override
  String toString() {
    return 'TimelineItem.text(id: $id, kind: $kind, role: $role, text: $text)';
  }
}

/// @nodoc
abstract mixin class $TextTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $TextTimelineItemCopyWith(
          TextTimelineItem value, $Res Function(TextTimelineItem) _then) =
      _$TextTimelineItemCopyWithImpl;
  @useResult
  $Res call({String id, ChatMessageKind kind, String role, String text});
}

/// @nodoc
class _$TextTimelineItemCopyWithImpl<$Res>
    implements $TextTimelineItemCopyWith<$Res> {
  _$TextTimelineItemCopyWithImpl(this._self, this._then);

  final TextTimelineItem _self;
  final $Res Function(TextTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? kind = null,
    Object? role = null,
    Object? text = null,
  }) {
    return _then(TextTimelineItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ChatMessageKind,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class TextStreamTimelineItem implements TimelineItem {
  const TextStreamTimelineItem(
      {required this.id, required this.role, required this.text});

  final String id;
  final String role;
  final String text;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TextStreamTimelineItemCopyWith<TextStreamTimelineItem> get copyWith =>
      _$TextStreamTimelineItemCopyWithImpl<TextStreamTimelineItem>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TextStreamTimelineItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, role, text);

  @override
  String toString() {
    return 'TimelineItem.textStream(id: $id, role: $role, text: $text)';
  }
}

/// @nodoc
abstract mixin class $TextStreamTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $TextStreamTimelineItemCopyWith(TextStreamTimelineItem value,
          $Res Function(TextStreamTimelineItem) _then) =
      _$TextStreamTimelineItemCopyWithImpl;
  @useResult
  $Res call({String id, String role, String text});
}

/// @nodoc
class _$TextStreamTimelineItemCopyWithImpl<$Res>
    implements $TextStreamTimelineItemCopyWith<$Res> {
  _$TextStreamTimelineItemCopyWithImpl(this._self, this._then);

  final TextStreamTimelineItem _self;
  final $Res Function(TextStreamTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = null,
  }) {
    return _then(TextStreamTimelineItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ToolCallTimelineItem implements TimelineItem {
  const ToolCallTimelineItem(
      {required this.id, required this.name, this.args = '', this.result});

  final String id;
  final String name;
  @JsonKey()
  final String args;
  final String? result;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolCallTimelineItemCopyWith<ToolCallTimelineItem> get copyWith =>
      _$ToolCallTimelineItemCopyWithImpl<ToolCallTimelineItem>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolCallTimelineItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.args, args) || other.args == args) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, args, result);

  @override
  String toString() {
    return 'TimelineItem.toolCall(id: $id, name: $name, args: $args, result: $result)';
  }
}

/// @nodoc
abstract mixin class $ToolCallTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ToolCallTimelineItemCopyWith(ToolCallTimelineItem value,
          $Res Function(ToolCallTimelineItem) _then) =
      _$ToolCallTimelineItemCopyWithImpl;
  @useResult
  $Res call({String id, String name, String args, String? result});
}

/// @nodoc
class _$ToolCallTimelineItemCopyWithImpl<$Res>
    implements $ToolCallTimelineItemCopyWith<$Res> {
  _$ToolCallTimelineItemCopyWithImpl(this._self, this._then);

  final ToolCallTimelineItem _self;
  final $Res Function(ToolCallTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? args = null,
    Object? result = freezed,
  }) {
    return _then(ToolCallTimelineItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      args: null == args
          ? _self.args
          : args // ignore: cast_nullable_to_non_nullable
              as String,
      result: freezed == result
          ? _self.result
          : result // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class PermissionTimelineItem implements TimelineItem {
  const PermissionTimelineItem({required this.requestId});

  final String requestId;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PermissionTimelineItemCopyWith<PermissionTimelineItem> get copyWith =>
      _$PermissionTimelineItemCopyWithImpl<PermissionTimelineItem>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PermissionTimelineItem &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId);

  @override
  String toString() {
    return 'TimelineItem.permission(requestId: $requestId)';
  }
}

/// @nodoc
abstract mixin class $PermissionTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $PermissionTimelineItemCopyWith(PermissionTimelineItem value,
          $Res Function(PermissionTimelineItem) _then) =
      _$PermissionTimelineItemCopyWithImpl;
  @useResult
  $Res call({String requestId});
}

/// @nodoc
class _$PermissionTimelineItemCopyWithImpl<$Res>
    implements $PermissionTimelineItemCopyWith<$Res> {
  _$PermissionTimelineItemCopyWithImpl(this._self, this._then);

  final PermissionTimelineItem _self;
  final $Res Function(PermissionTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
  }) {
    return _then(PermissionTimelineItem(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ElicitationTimelineItem implements TimelineItem {
  const ElicitationTimelineItem({required this.requestId});

  final String requestId;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ElicitationTimelineItemCopyWith<ElicitationTimelineItem> get copyWith =>
      _$ElicitationTimelineItemCopyWithImpl<ElicitationTimelineItem>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ElicitationTimelineItem &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId);

  @override
  String toString() {
    return 'TimelineItem.elicitation(requestId: $requestId)';
  }
}

/// @nodoc
abstract mixin class $ElicitationTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ElicitationTimelineItemCopyWith(ElicitationTimelineItem value,
          $Res Function(ElicitationTimelineItem) _then) =
      _$ElicitationTimelineItemCopyWithImpl;
  @useResult
  $Res call({String requestId});
}

/// @nodoc
class _$ElicitationTimelineItemCopyWithImpl<$Res>
    implements $ElicitationTimelineItemCopyWith<$Res> {
  _$ElicitationTimelineItemCopyWithImpl(this._self, this._then);

  final ElicitationTimelineItem _self;
  final $Res Function(ElicitationTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
  }) {
    return _then(ElicitationTimelineItem(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$SessionState {
  Map<String, dynamic>? get permission;
  Map<String, dynamic>? get elicitation;
  Map<String, dynamic>? get modes;
  Map<String, dynamic>? get config;
  Map<String, dynamic>? get plan;
  String? get title;
  bool get isRunning;
  String? get runError;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionStateCopyWith<SessionState> get copyWith =>
      _$SessionStateCopyWithImpl<SessionState>(
          this as SessionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionState &&
            const DeepCollectionEquality()
                .equals(other.permission, permission) &&
            const DeepCollectionEquality()
                .equals(other.elicitation, elicitation) &&
            const DeepCollectionEquality().equals(other.modes, modes) &&
            const DeepCollectionEquality().equals(other.config, config) &&
            const DeepCollectionEquality().equals(other.plan, plan) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.runError, runError) ||
                other.runError == runError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(permission),
      const DeepCollectionEquality().hash(elicitation),
      const DeepCollectionEquality().hash(modes),
      const DeepCollectionEquality().hash(config),
      const DeepCollectionEquality().hash(plan),
      title,
      isRunning,
      runError);

  @override
  String toString() {
    return 'SessionState(permission: $permission, elicitation: $elicitation, modes: $modes, config: $config, plan: $plan, title: $title, isRunning: $isRunning, runError: $runError)';
  }
}

/// @nodoc
abstract mixin class $SessionStateCopyWith<$Res> {
  factory $SessionStateCopyWith(
          SessionState value, $Res Function(SessionState) _then) =
      _$SessionStateCopyWithImpl;
  @useResult
  $Res call(
      {Map<String, dynamic>? permission,
      Map<String, dynamic>? elicitation,
      Map<String, dynamic>? modes,
      Map<String, dynamic>? config,
      Map<String, dynamic>? plan,
      String? title,
      bool isRunning,
      String? runError});
}

/// @nodoc
class _$SessionStateCopyWithImpl<$Res> implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._self, this._then);

  final SessionState _self;
  final $Res Function(SessionState) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? permission = freezed,
    Object? elicitation = freezed,
    Object? modes = freezed,
    Object? config = freezed,
    Object? plan = freezed,
    Object? title = freezed,
    Object? isRunning = null,
    Object? runError = freezed,
  }) {
    return _then(_self.copyWith(
      permission: freezed == permission
          ? _self.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      elicitation: freezed == elicitation
          ? _self.elicitation
          : elicitation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      modes: freezed == modes
          ? _self.modes
          : modes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      config: freezed == config
          ? _self.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      plan: freezed == plan
          ? _self.plan
          : plan // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      isRunning: null == isRunning
          ? _self.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      runError: freezed == runError
          ? _self.runError
          : runError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SessionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SessionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SessionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            Map<String, dynamic>? permission,
            Map<String, dynamic>? elicitation,
            Map<String, dynamic>? modes,
            Map<String, dynamic>? config,
            Map<String, dynamic>? plan,
            String? title,
            bool isRunning,
            String? runError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
        return $default(
            _that.permission,
            _that.elicitation,
            _that.modes,
            _that.config,
            _that.plan,
            _that.title,
            _that.isRunning,
            _that.runError);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            Map<String, dynamic>? permission,
            Map<String, dynamic>? elicitation,
            Map<String, dynamic>? modes,
            Map<String, dynamic>? config,
            Map<String, dynamic>? plan,
            String? title,
            bool isRunning,
            String? runError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState():
        return $default(
            _that.permission,
            _that.elicitation,
            _that.modes,
            _that.config,
            _that.plan,
            _that.title,
            _that.isRunning,
            _that.runError);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            Map<String, dynamic>? permission,
            Map<String, dynamic>? elicitation,
            Map<String, dynamic>? modes,
            Map<String, dynamic>? config,
            Map<String, dynamic>? plan,
            String? title,
            bool isRunning,
            String? runError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionState() when $default != null:
        return $default(
            _that.permission,
            _that.elicitation,
            _that.modes,
            _that.config,
            _that.plan,
            _that.title,
            _that.isRunning,
            _that.runError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SessionState extends SessionState {
  const _SessionState(
      {final Map<String, dynamic>? permission,
      final Map<String, dynamic>? elicitation,
      final Map<String, dynamic>? modes,
      final Map<String, dynamic>? config,
      final Map<String, dynamic>? plan,
      this.title,
      this.isRunning = false,
      this.runError})
      : _permission = permission,
        _elicitation = elicitation,
        _modes = modes,
        _config = config,
        _plan = plan,
        super._();

  final Map<String, dynamic>? _permission;
  @override
  Map<String, dynamic>? get permission {
    final value = _permission;
    if (value == null) return null;
    if (_permission is EqualUnmodifiableMapView) return _permission;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _elicitation;
  @override
  Map<String, dynamic>? get elicitation {
    final value = _elicitation;
    if (value == null) return null;
    if (_elicitation is EqualUnmodifiableMapView) return _elicitation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _modes;
  @override
  Map<String, dynamic>? get modes {
    final value = _modes;
    if (value == null) return null;
    if (_modes is EqualUnmodifiableMapView) return _modes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _config;
  @override
  Map<String, dynamic>? get config {
    final value = _config;
    if (value == null) return null;
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _plan;
  @override
  Map<String, dynamic>? get plan {
    final value = _plan;
    if (value == null) return null;
    if (_plan is EqualUnmodifiableMapView) return _plan;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? title;
  @override
  @JsonKey()
  final bool isRunning;
  @override
  final String? runError;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionStateCopyWith<_SessionState> get copyWith =>
      __$SessionStateCopyWithImpl<_SessionState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionState &&
            const DeepCollectionEquality()
                .equals(other._permission, _permission) &&
            const DeepCollectionEquality()
                .equals(other._elicitation, _elicitation) &&
            const DeepCollectionEquality().equals(other._modes, _modes) &&
            const DeepCollectionEquality().equals(other._config, _config) &&
            const DeepCollectionEquality().equals(other._plan, _plan) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            (identical(other.runError, runError) ||
                other.runError == runError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_permission),
      const DeepCollectionEquality().hash(_elicitation),
      const DeepCollectionEquality().hash(_modes),
      const DeepCollectionEquality().hash(_config),
      const DeepCollectionEquality().hash(_plan),
      title,
      isRunning,
      runError);

  @override
  String toString() {
    return 'SessionState(permission: $permission, elicitation: $elicitation, modes: $modes, config: $config, plan: $plan, title: $title, isRunning: $isRunning, runError: $runError)';
  }
}

/// @nodoc
abstract mixin class _$SessionStateCopyWith<$Res>
    implements $SessionStateCopyWith<$Res> {
  factory _$SessionStateCopyWith(
          _SessionState value, $Res Function(_SessionState) _then) =
      __$SessionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic>? permission,
      Map<String, dynamic>? elicitation,
      Map<String, dynamic>? modes,
      Map<String, dynamic>? config,
      Map<String, dynamic>? plan,
      String? title,
      bool isRunning,
      String? runError});
}

/// @nodoc
class __$SessionStateCopyWithImpl<$Res>
    implements _$SessionStateCopyWith<$Res> {
  __$SessionStateCopyWithImpl(this._self, this._then);

  final _SessionState _self;
  final $Res Function(_SessionState) _then;

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? permission = freezed,
    Object? elicitation = freezed,
    Object? modes = freezed,
    Object? config = freezed,
    Object? plan = freezed,
    Object? title = freezed,
    Object? isRunning = null,
    Object? runError = freezed,
  }) {
    return _then(_SessionState(
      permission: freezed == permission
          ? _self._permission
          : permission // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      elicitation: freezed == elicitation
          ? _self._elicitation
          : elicitation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      modes: freezed == modes
          ? _self._modes
          : modes // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      config: freezed == config
          ? _self._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      plan: freezed == plan
          ? _self._plan
          : plan // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      isRunning: null == isRunning
          ? _self.isRunning
          : isRunning // ignore: cast_nullable_to_non_nullable
              as bool,
      runError: freezed == runError
          ? _self.runError
          : runError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$Conversation {
  List<TimelineItem> get timeline;
  SessionState get sessionState;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConversationCopyWith<Conversation> get copyWith =>
      _$ConversationCopyWithImpl<Conversation>(
          this as Conversation, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Conversation &&
            const DeepCollectionEquality().equals(other.timeline, timeline) &&
            (identical(other.sessionState, sessionState) ||
                other.sessionState == sessionState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(timeline), sessionState);

  @override
  String toString() {
    return 'Conversation(timeline: $timeline, sessionState: $sessionState)';
  }
}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) _then) =
      _$ConversationCopyWithImpl;
  @useResult
  $Res call({List<TimelineItem> timeline, SessionState sessionState});

  $SessionStateCopyWith<$Res> get sessionState;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res> implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._self, this._then);

  final Conversation _self;
  final $Res Function(Conversation) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timeline = null,
    Object? sessionState = null,
  }) {
    return _then(_self.copyWith(
      timeline: null == timeline
          ? _self.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<TimelineItem>,
      sessionState: null == sessionState
          ? _self.sessionState
          : sessionState // ignore: cast_nullable_to_non_nullable
              as SessionState,
    ));
  }

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionStateCopyWith<$Res> get sessionState {
    return $SessionStateCopyWith<$Res>(_self.sessionState, (value) {
      return _then(_self.copyWith(sessionState: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Conversation].
extension ConversationPatterns on Conversation {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Conversation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Conversation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Conversation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<TimelineItem> timeline, SessionState sessionState)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that.timeline, _that.sessionState);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<TimelineItem> timeline, SessionState sessionState)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation():
        return $default(_that.timeline, _that.sessionState);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<TimelineItem> timeline, SessionState sessionState)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that.timeline, _that.sessionState);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Conversation extends Conversation {
  const _Conversation(
      {final List<TimelineItem> timeline = const <TimelineItem>[],
      this.sessionState = SessionState.empty})
      : _timeline = timeline,
        super._();

  final List<TimelineItem> _timeline;
  @override
  @JsonKey()
  List<TimelineItem> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  @JsonKey()
  final SessionState sessionState;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConversationCopyWith<_Conversation> get copyWith =>
      __$ConversationCopyWithImpl<_Conversation>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Conversation &&
            const DeepCollectionEquality().equals(other._timeline, _timeline) &&
            (identical(other.sessionState, sessionState) ||
                other.sessionState == sessionState));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_timeline), sessionState);

  @override
  String toString() {
    return 'Conversation(timeline: $timeline, sessionState: $sessionState)';
  }
}

/// @nodoc
abstract mixin class _$ConversationCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$ConversationCopyWith(
          _Conversation value, $Res Function(_Conversation) _then) =
      __$ConversationCopyWithImpl;
  @override
  @useResult
  $Res call({List<TimelineItem> timeline, SessionState sessionState});

  @override
  $SessionStateCopyWith<$Res> get sessionState;
}

/// @nodoc
class __$ConversationCopyWithImpl<$Res>
    implements _$ConversationCopyWith<$Res> {
  __$ConversationCopyWithImpl(this._self, this._then);

  final _Conversation _self;
  final $Res Function(_Conversation) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? timeline = null,
    Object? sessionState = null,
  }) {
    return _then(_Conversation(
      timeline: null == timeline
          ? _self._timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<TimelineItem>,
      sessionState: null == sessionState
          ? _self.sessionState
          : sessionState // ignore: cast_nullable_to_non_nullable
              as SessionState,
    ));
  }

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionStateCopyWith<$Res> get sessionState {
    return $SessionStateCopyWith<$Res>(_self.sessionState, (value) {
      return _then(_self.copyWith(sessionState: value));
    });
  }
}

// dart format on
