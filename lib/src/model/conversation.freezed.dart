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
mixin _$ToolDiff {
  String get path;
  String get oldText;
  String get newText;

  /// Create a copy of ToolDiff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolDiffCopyWith<ToolDiff> get copyWith =>
      _$ToolDiffCopyWithImpl<ToolDiff>(this as ToolDiff, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolDiff &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.oldText, oldText) || other.oldText == oldText) &&
            (identical(other.newText, newText) || other.newText == newText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path, oldText, newText);

  @override
  String toString() {
    return 'ToolDiff(path: $path, oldText: $oldText, newText: $newText)';
  }
}

/// @nodoc
abstract mixin class $ToolDiffCopyWith<$Res> {
  factory $ToolDiffCopyWith(ToolDiff value, $Res Function(ToolDiff) _then) =
      _$ToolDiffCopyWithImpl;
  @useResult
  $Res call({String path, String oldText, String newText});
}

/// @nodoc
class _$ToolDiffCopyWithImpl<$Res> implements $ToolDiffCopyWith<$Res> {
  _$ToolDiffCopyWithImpl(this._self, this._then);

  final ToolDiff _self;
  final $Res Function(ToolDiff) _then;

  /// Create a copy of ToolDiff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? oldText = null,
    Object? newText = null,
  }) {
    return _then(_self.copyWith(
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      oldText: null == oldText
          ? _self.oldText
          : oldText // ignore: cast_nullable_to_non_nullable
              as String,
      newText: null == newText
          ? _self.newText
          : newText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ToolDiff].
extension ToolDiffPatterns on ToolDiff {
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
    TResult Function(_ToolDiff value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolDiff() when $default != null:
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
    TResult Function(_ToolDiff value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolDiff():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_ToolDiff value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolDiff() when $default != null:
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
    TResult Function(String path, String oldText, String newText)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolDiff() when $default != null:
        return $default(_that.path, _that.oldText, _that.newText);
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
    TResult Function(String path, String oldText, String newText) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolDiff():
        return $default(_that.path, _that.oldText, _that.newText);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(String path, String oldText, String newText)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolDiff() when $default != null:
        return $default(_that.path, _that.oldText, _that.newText);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ToolDiff implements ToolDiff {
  const _ToolDiff(
      {required this.path, this.oldText = '', required this.newText});

  @override
  final String path;
  @override
  @JsonKey()
  final String oldText;
  @override
  final String newText;

  /// Create a copy of ToolDiff
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ToolDiffCopyWith<_ToolDiff> get copyWith =>
      __$ToolDiffCopyWithImpl<_ToolDiff>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ToolDiff &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.oldText, oldText) || other.oldText == oldText) &&
            (identical(other.newText, newText) || other.newText == newText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path, oldText, newText);

  @override
  String toString() {
    return 'ToolDiff(path: $path, oldText: $oldText, newText: $newText)';
  }
}

/// @nodoc
abstract mixin class _$ToolDiffCopyWith<$Res>
    implements $ToolDiffCopyWith<$Res> {
  factory _$ToolDiffCopyWith(_ToolDiff value, $Res Function(_ToolDiff) _then) =
      __$ToolDiffCopyWithImpl;
  @override
  @useResult
  $Res call({String path, String oldText, String newText});
}

/// @nodoc
class __$ToolDiffCopyWithImpl<$Res> implements _$ToolDiffCopyWith<$Res> {
  __$ToolDiffCopyWithImpl(this._self, this._then);

  final _ToolDiff _self;
  final $Res Function(_ToolDiff) _then;

  /// Create a copy of ToolDiff
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? path = null,
    Object? oldText = null,
    Object? newText = null,
  }) {
    return _then(_ToolDiff(
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      oldText: null == oldText
          ? _self.oldText
          : oldText // ignore: cast_nullable_to_non_nullable
              as String,
      newText: null == newText
          ? _self.newText
          : newText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PermissionOption {
  String get optionId;
  String get label;
  String get kind;

  /// Create a copy of PermissionOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PermissionOptionCopyWith<PermissionOption> get copyWith =>
      _$PermissionOptionCopyWithImpl<PermissionOption>(
          this as PermissionOption, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PermissionOption &&
            (identical(other.optionId, optionId) ||
                other.optionId == optionId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @override
  int get hashCode => Object.hash(runtimeType, optionId, label, kind);

  @override
  String toString() {
    return 'PermissionOption(optionId: $optionId, label: $label, kind: $kind)';
  }
}

/// @nodoc
abstract mixin class $PermissionOptionCopyWith<$Res> {
  factory $PermissionOptionCopyWith(
          PermissionOption value, $Res Function(PermissionOption) _then) =
      _$PermissionOptionCopyWithImpl;
  @useResult
  $Res call({String optionId, String label, String kind});
}

/// @nodoc
class _$PermissionOptionCopyWithImpl<$Res>
    implements $PermissionOptionCopyWith<$Res> {
  _$PermissionOptionCopyWithImpl(this._self, this._then);

  final PermissionOption _self;
  final $Res Function(PermissionOption) _then;

  /// Create a copy of PermissionOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionId = null,
    Object? label = null,
    Object? kind = null,
  }) {
    return _then(_self.copyWith(
      optionId: null == optionId
          ? _self.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PermissionOption].
extension PermissionOptionPatterns on PermissionOption {
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
    TResult Function(_PermissionOption value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PermissionOption() when $default != null:
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
    TResult Function(_PermissionOption value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PermissionOption():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(_PermissionOption value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PermissionOption() when $default != null:
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
    TResult Function(String optionId, String label, String kind)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PermissionOption() when $default != null:
        return $default(_that.optionId, _that.label, _that.kind);
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
    TResult Function(String optionId, String label, String kind) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PermissionOption():
        return $default(_that.optionId, _that.label, _that.kind);
      case _:
        throw StateError('Unexpected subclass');
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
    TResult? Function(String optionId, String label, String kind)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PermissionOption() when $default != null:
        return $default(_that.optionId, _that.label, _that.kind);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PermissionOption implements PermissionOption {
  const _PermissionOption(
      {required this.optionId, required this.label, required this.kind});

  @override
  final String optionId;
  @override
  final String label;
  @override
  final String kind;

  /// Create a copy of PermissionOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PermissionOptionCopyWith<_PermissionOption> get copyWith =>
      __$PermissionOptionCopyWithImpl<_PermissionOption>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PermissionOption &&
            (identical(other.optionId, optionId) ||
                other.optionId == optionId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @override
  int get hashCode => Object.hash(runtimeType, optionId, label, kind);

  @override
  String toString() {
    return 'PermissionOption(optionId: $optionId, label: $label, kind: $kind)';
  }
}

/// @nodoc
abstract mixin class _$PermissionOptionCopyWith<$Res>
    implements $PermissionOptionCopyWith<$Res> {
  factory _$PermissionOptionCopyWith(
          _PermissionOption value, $Res Function(_PermissionOption) _then) =
      __$PermissionOptionCopyWithImpl;
  @override
  @useResult
  $Res call({String optionId, String label, String kind});
}

/// @nodoc
class __$PermissionOptionCopyWithImpl<$Res>
    implements _$PermissionOptionCopyWith<$Res> {
  __$PermissionOptionCopyWithImpl(this._self, this._then);

  final _PermissionOption _self;
  final $Res Function(_PermissionOption) _then;

  /// Create a copy of PermissionOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? optionId = null,
    Object? label = null,
    Object? kind = null,
  }) {
    return _then(_PermissionOption(
      optionId: null == optionId
          ? _self.optionId
          : optionId // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _self.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

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
    TResult Function(PermissionRequestTimelineItem value)? permissionRequest,
    TResult Function(ElicitationRequestTimelineItem value)? elicitationRequest,
    TResult Function(ToolRequestTimelineItem value)? toolRequest,
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
      case PermissionRequestTimelineItem() when permissionRequest != null:
        return permissionRequest(_that);
      case ElicitationRequestTimelineItem() when elicitationRequest != null:
        return elicitationRequest(_that);
      case ToolRequestTimelineItem() when toolRequest != null:
        return toolRequest(_that);
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
    required TResult Function(PermissionRequestTimelineItem value)
        permissionRequest,
    required TResult Function(ElicitationRequestTimelineItem value)
        elicitationRequest,
    required TResult Function(ToolRequestTimelineItem value) toolRequest,
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
      case PermissionRequestTimelineItem():
        return permissionRequest(_that);
      case ElicitationRequestTimelineItem():
        return elicitationRequest(_that);
      case ToolRequestTimelineItem():
        return toolRequest(_that);
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
    TResult? Function(PermissionRequestTimelineItem value)? permissionRequest,
    TResult? Function(ElicitationRequestTimelineItem value)? elicitationRequest,
    TResult? Function(ToolRequestTimelineItem value)? toolRequest,
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
      case PermissionRequestTimelineItem() when permissionRequest != null:
        return permissionRequest(_that);
      case ElicitationRequestTimelineItem() when elicitationRequest != null:
        return elicitationRequest(_that);
      case ToolRequestTimelineItem() when toolRequest != null:
        return toolRequest(_that);
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
    TResult Function(String id, String name, String args, String? result,
            List<ToolDiff> diffs)?
        toolCall,
    TResult Function(String requestId)? permission,
    TResult Function(String requestId)? elicitation,
    TResult Function(String requestId, String? toolTitle, String? toolKind,
            String? description, List<PermissionOption> options)?
        permissionRequest,
    TResult Function(String requestId, String message, String mode,
            Map<String, dynamic>? schema, String? url)?
        elicitationRequest,
    TResult Function(String requestId, String? toolTitle, String? toolKind,
            String argsJson)?
        toolRequest,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that.id, _that.kind, _that.role, _that.text);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(_that.id, _that.role, _that.text);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(
            _that.id, _that.name, _that.args, _that.result, _that.diffs);
      case PermissionTimelineItem() when permission != null:
        return permission(_that.requestId);
      case ElicitationTimelineItem() when elicitation != null:
        return elicitation(_that.requestId);
      case PermissionRequestTimelineItem() when permissionRequest != null:
        return permissionRequest(_that.requestId, _that.toolTitle,
            _that.toolKind, _that.description, _that.options);
      case ElicitationRequestTimelineItem() when elicitationRequest != null:
        return elicitationRequest(_that.requestId, _that.message, _that.mode,
            _that.schema, _that.url);
      case ToolRequestTimelineItem() when toolRequest != null:
        return toolRequest(
            _that.requestId, _that.toolTitle, _that.toolKind, _that.argsJson);
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
    required TResult Function(String id, String name, String args,
            String? result, List<ToolDiff> diffs)
        toolCall,
    required TResult Function(String requestId) permission,
    required TResult Function(String requestId) elicitation,
    required TResult Function(
            String requestId,
            String? toolTitle,
            String? toolKind,
            String? description,
            List<PermissionOption> options)
        permissionRequest,
    required TResult Function(String requestId, String message, String mode,
            Map<String, dynamic>? schema, String? url)
        elicitationRequest,
    required TResult Function(String requestId, String? toolTitle,
            String? toolKind, String argsJson)
        toolRequest,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem():
        return text(_that.id, _that.kind, _that.role, _that.text);
      case TextStreamTimelineItem():
        return textStream(_that.id, _that.role, _that.text);
      case ToolCallTimelineItem():
        return toolCall(
            _that.id, _that.name, _that.args, _that.result, _that.diffs);
      case PermissionTimelineItem():
        return permission(_that.requestId);
      case ElicitationTimelineItem():
        return elicitation(_that.requestId);
      case PermissionRequestTimelineItem():
        return permissionRequest(_that.requestId, _that.toolTitle,
            _that.toolKind, _that.description, _that.options);
      case ElicitationRequestTimelineItem():
        return elicitationRequest(_that.requestId, _that.message, _that.mode,
            _that.schema, _that.url);
      case ToolRequestTimelineItem():
        return toolRequest(
            _that.requestId, _that.toolTitle, _that.toolKind, _that.argsJson);
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
    TResult? Function(String id, String name, String args, String? result,
            List<ToolDiff> diffs)?
        toolCall,
    TResult? Function(String requestId)? permission,
    TResult? Function(String requestId)? elicitation,
    TResult? Function(String requestId, String? toolTitle, String? toolKind,
            String? description, List<PermissionOption> options)?
        permissionRequest,
    TResult? Function(String requestId, String message, String mode,
            Map<String, dynamic>? schema, String? url)?
        elicitationRequest,
    TResult? Function(String requestId, String? toolTitle, String? toolKind,
            String argsJson)?
        toolRequest,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that.id, _that.kind, _that.role, _that.text);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(_that.id, _that.role, _that.text);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(
            _that.id, _that.name, _that.args, _that.result, _that.diffs);
      case PermissionTimelineItem() when permission != null:
        return permission(_that.requestId);
      case ElicitationTimelineItem() when elicitation != null:
        return elicitation(_that.requestId);
      case PermissionRequestTimelineItem() when permissionRequest != null:
        return permissionRequest(_that.requestId, _that.toolTitle,
            _that.toolKind, _that.description, _that.options);
      case ElicitationRequestTimelineItem() when elicitationRequest != null:
        return elicitationRequest(_that.requestId, _that.message, _that.mode,
            _that.schema, _that.url);
      case ToolRequestTimelineItem() when toolRequest != null:
        return toolRequest(
            _that.requestId, _that.toolTitle, _that.toolKind, _that.argsJson);
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
      {required this.id,
      required this.name,
      this.args = '',
      this.result,
      final List<ToolDiff> diffs = const <ToolDiff>[]})
      : _diffs = diffs;

  final String id;
  final String name;
  @JsonKey()
  final String args;
  final String? result;
  final List<ToolDiff> _diffs;
  @JsonKey()
  List<ToolDiff> get diffs {
    if (_diffs is EqualUnmodifiableListView) return _diffs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diffs);
  }

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
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(other._diffs, _diffs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, args, result,
      const DeepCollectionEquality().hash(_diffs));

  @override
  String toString() {
    return 'TimelineItem.toolCall(id: $id, name: $name, args: $args, result: $result, diffs: $diffs)';
  }
}

/// @nodoc
abstract mixin class $ToolCallTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ToolCallTimelineItemCopyWith(ToolCallTimelineItem value,
          $Res Function(ToolCallTimelineItem) _then) =
      _$ToolCallTimelineItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String args,
      String? result,
      List<ToolDiff> diffs});
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
    Object? diffs = null,
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
      diffs: null == diffs
          ? _self._diffs
          : diffs // ignore: cast_nullable_to_non_nullable
              as List<ToolDiff>,
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

class PermissionRequestTimelineItem implements TimelineItem {
  const PermissionRequestTimelineItem(
      {required this.requestId,
      this.toolTitle,
      this.toolKind,
      this.description,
      required final List<PermissionOption> options})
      : _options = options;

  final String requestId;
  final String? toolTitle;
  final String? toolKind;
  final String? description;
  final List<PermissionOption> _options;
  List<PermissionOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PermissionRequestTimelineItemCopyWith<PermissionRequestTimelineItem>
      get copyWith => _$PermissionRequestTimelineItemCopyWithImpl<
          PermissionRequestTimelineItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PermissionRequestTimelineItem &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.toolTitle, toolTitle) ||
                other.toolTitle == toolTitle) &&
            (identical(other.toolKind, toolKind) ||
                other.toolKind == toolKind) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId, toolTitle, toolKind,
      description, const DeepCollectionEquality().hash(_options));

  @override
  String toString() {
    return 'TimelineItem.permissionRequest(requestId: $requestId, toolTitle: $toolTitle, toolKind: $toolKind, description: $description, options: $options)';
  }
}

/// @nodoc
abstract mixin class $PermissionRequestTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $PermissionRequestTimelineItemCopyWith(
          PermissionRequestTimelineItem value,
          $Res Function(PermissionRequestTimelineItem) _then) =
      _$PermissionRequestTimelineItemCopyWithImpl;
  @useResult
  $Res call(
      {String requestId,
      String? toolTitle,
      String? toolKind,
      String? description,
      List<PermissionOption> options});
}

/// @nodoc
class _$PermissionRequestTimelineItemCopyWithImpl<$Res>
    implements $PermissionRequestTimelineItemCopyWith<$Res> {
  _$PermissionRequestTimelineItemCopyWithImpl(this._self, this._then);

  final PermissionRequestTimelineItem _self;
  final $Res Function(PermissionRequestTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? toolTitle = freezed,
    Object? toolKind = freezed,
    Object? description = freezed,
    Object? options = null,
  }) {
    return _then(PermissionRequestTimelineItem(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      toolTitle: freezed == toolTitle
          ? _self.toolTitle
          : toolTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      toolKind: freezed == toolKind
          ? _self.toolKind
          : toolKind // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PermissionOption>,
    ));
  }
}

/// @nodoc

class ElicitationRequestTimelineItem implements TimelineItem {
  const ElicitationRequestTimelineItem(
      {required this.requestId,
      required this.message,
      required this.mode,
      final Map<String, dynamic>? schema,
      this.url})
      : _schema = schema;

  final String requestId;
  final String message;
  final String mode;
  final Map<String, dynamic>? _schema;
  Map<String, dynamic>? get schema {
    final value = _schema;
    if (value == null) return null;
    if (_schema is EqualUnmodifiableMapView) return _schema;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final String? url;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ElicitationRequestTimelineItemCopyWith<ElicitationRequestTimelineItem>
      get copyWith => _$ElicitationRequestTimelineItemCopyWithImpl<
          ElicitationRequestTimelineItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ElicitationRequestTimelineItem &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            const DeepCollectionEquality().equals(other._schema, _schema) &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, requestId, message, mode,
      const DeepCollectionEquality().hash(_schema), url);

  @override
  String toString() {
    return 'TimelineItem.elicitationRequest(requestId: $requestId, message: $message, mode: $mode, schema: $schema, url: $url)';
  }
}

/// @nodoc
abstract mixin class $ElicitationRequestTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ElicitationRequestTimelineItemCopyWith(
          ElicitationRequestTimelineItem value,
          $Res Function(ElicitationRequestTimelineItem) _then) =
      _$ElicitationRequestTimelineItemCopyWithImpl;
  @useResult
  $Res call(
      {String requestId,
      String message,
      String mode,
      Map<String, dynamic>? schema,
      String? url});
}

/// @nodoc
class _$ElicitationRequestTimelineItemCopyWithImpl<$Res>
    implements $ElicitationRequestTimelineItemCopyWith<$Res> {
  _$ElicitationRequestTimelineItemCopyWithImpl(this._self, this._then);

  final ElicitationRequestTimelineItem _self;
  final $Res Function(ElicitationRequestTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? message = null,
    Object? mode = null,
    Object? schema = freezed,
    Object? url = freezed,
  }) {
    return _then(ElicitationRequestTimelineItem(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      schema: freezed == schema
          ? _self._schema
          : schema // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class ToolRequestTimelineItem implements TimelineItem {
  const ToolRequestTimelineItem(
      {required this.requestId,
      this.toolTitle,
      this.toolKind,
      required this.argsJson});

  final String requestId;
  final String? toolTitle;
  final String? toolKind;
  final String argsJson;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolRequestTimelineItemCopyWith<ToolRequestTimelineItem> get copyWith =>
      _$ToolRequestTimelineItemCopyWithImpl<ToolRequestTimelineItem>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolRequestTimelineItem &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.toolTitle, toolTitle) ||
                other.toolTitle == toolTitle) &&
            (identical(other.toolKind, toolKind) ||
                other.toolKind == toolKind) &&
            (identical(other.argsJson, argsJson) ||
                other.argsJson == argsJson));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, requestId, toolTitle, toolKind, argsJson);

  @override
  String toString() {
    return 'TimelineItem.toolRequest(requestId: $requestId, toolTitle: $toolTitle, toolKind: $toolKind, argsJson: $argsJson)';
  }
}

/// @nodoc
abstract mixin class $ToolRequestTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ToolRequestTimelineItemCopyWith(ToolRequestTimelineItem value,
          $Res Function(ToolRequestTimelineItem) _then) =
      _$ToolRequestTimelineItemCopyWithImpl;
  @useResult
  $Res call(
      {String requestId, String? toolTitle, String? toolKind, String argsJson});
}

/// @nodoc
class _$ToolRequestTimelineItemCopyWithImpl<$Res>
    implements $ToolRequestTimelineItemCopyWith<$Res> {
  _$ToolRequestTimelineItemCopyWithImpl(this._self, this._then);

  final ToolRequestTimelineItem _self;
  final $Res Function(ToolRequestTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? toolTitle = freezed,
    Object? toolKind = freezed,
    Object? argsJson = null,
  }) {
    return _then(ToolRequestTimelineItem(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      toolTitle: freezed == toolTitle
          ? _self.toolTitle
          : toolTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      toolKind: freezed == toolKind
          ? _self.toolKind
          : toolKind // ignore: cast_nullable_to_non_nullable
              as String?,
      argsJson: null == argsJson
          ? _self.argsJson
          : argsJson // ignore: cast_nullable_to_non_nullable
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
