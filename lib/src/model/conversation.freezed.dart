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
mixin _$PermissionOption {
  String get optionId;
  String get label;
  String get kind;
  Map<String, dynamic> get extras;

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
            (identical(other.kind, kind) || other.kind == kind) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, optionId, label, kind,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'PermissionOption(optionId: $optionId, label: $label, kind: $kind, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $PermissionOptionCopyWith<$Res> {
  factory $PermissionOptionCopyWith(
          PermissionOption value, $Res Function(PermissionOption) _then) =
      _$PermissionOptionCopyWithImpl;
  @useResult
  $Res call(
      {String optionId,
      String label,
      String kind,
      Map<String, dynamic> extras});
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
    Object? extras = null,
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
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
    TResult Function(String optionId, String label, String kind,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PermissionOption() when $default != null:
        return $default(_that.optionId, _that.label, _that.kind, _that.extras);
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
    TResult Function(String optionId, String label, String kind,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PermissionOption():
        return $default(_that.optionId, _that.label, _that.kind, _that.extras);
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
    TResult? Function(String optionId, String label, String kind,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PermissionOption() when $default != null:
        return $default(_that.optionId, _that.label, _that.kind, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PermissionOption implements PermissionOption {
  const _PermissionOption(
      {required this.optionId,
      required this.label,
      required this.kind,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras;

  @override
  final String optionId;
  @override
  final String label;
  @override
  final String kind;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

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
            (identical(other.kind, kind) || other.kind == kind) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, optionId, label, kind,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'PermissionOption(optionId: $optionId, label: $label, kind: $kind, extras: $extras)';
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
  $Res call(
      {String optionId,
      String label,
      String kind,
      Map<String, dynamic> extras});
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
    Object? extras = null,
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
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$OrderKey {
  int get seq;
  int get sub;

  /// Create a copy of OrderKey
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<OrderKey> get copyWith =>
      _$OrderKeyCopyWithImpl<OrderKey>(this as OrderKey, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OrderKey &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.sub, sub) || other.sub == sub));
  }

  @override
  int get hashCode => Object.hash(runtimeType, seq, sub);

  @override
  String toString() {
    return 'OrderKey(seq: $seq, sub: $sub)';
  }
}

/// @nodoc
abstract mixin class $OrderKeyCopyWith<$Res> {
  factory $OrderKeyCopyWith(OrderKey value, $Res Function(OrderKey) _then) =
      _$OrderKeyCopyWithImpl;
  @useResult
  $Res call({int seq, int sub});
}

/// @nodoc
class _$OrderKeyCopyWithImpl<$Res> implements $OrderKeyCopyWith<$Res> {
  _$OrderKeyCopyWithImpl(this._self, this._then);

  final OrderKey _self;
  final $Res Function(OrderKey) _then;

  /// Create a copy of OrderKey
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? seq = null,
    Object? sub = null,
  }) {
    return _then(_self.copyWith(
      seq: null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      sub: null == sub
          ? _self.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [OrderKey].
extension OrderKeyPatterns on OrderKey {
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
    TResult Function(_OrderKey value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderKey() when $default != null:
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
    TResult Function(_OrderKey value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderKey():
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
    TResult? Function(_OrderKey value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderKey() when $default != null:
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
    TResult Function(int seq, int sub)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OrderKey() when $default != null:
        return $default(_that.seq, _that.sub);
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
    TResult Function(int seq, int sub) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderKey():
        return $default(_that.seq, _that.sub);
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
    TResult? Function(int seq, int sub)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OrderKey() when $default != null:
        return $default(_that.seq, _that.sub);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _OrderKey extends OrderKey {
  const _OrderKey(this.seq, [this.sub = 0]) : super._();

  @override
  final int seq;
  @override
  @JsonKey()
  final int sub;

  /// Create a copy of OrderKey
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OrderKeyCopyWith<_OrderKey> get copyWith =>
      __$OrderKeyCopyWithImpl<_OrderKey>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OrderKey &&
            (identical(other.seq, seq) || other.seq == seq) &&
            (identical(other.sub, sub) || other.sub == sub));
  }

  @override
  int get hashCode => Object.hash(runtimeType, seq, sub);

  @override
  String toString() {
    return 'OrderKey(seq: $seq, sub: $sub)';
  }
}

/// @nodoc
abstract mixin class _$OrderKeyCopyWith<$Res>
    implements $OrderKeyCopyWith<$Res> {
  factory _$OrderKeyCopyWith(_OrderKey value, $Res Function(_OrderKey) _then) =
      __$OrderKeyCopyWithImpl;
  @override
  @useResult
  $Res call({int seq, int sub});
}

/// @nodoc
class __$OrderKeyCopyWithImpl<$Res> implements _$OrderKeyCopyWith<$Res> {
  __$OrderKeyCopyWithImpl(this._self, this._then);

  final _OrderKey _self;
  final $Res Function(_OrderKey) _then;

  /// Create a copy of OrderKey
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? seq = null,
    Object? sub = null,
  }) {
    return _then(_OrderKey(
      null == seq
          ? _self.seq
          : seq // ignore: cast_nullable_to_non_nullable
              as int,
      null == sub
          ? _self.sub
          : sub // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$TimelineItem {
  OrderKey get order;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TimelineItemCopyWith<TimelineItem> get copyWith =>
      _$TimelineItemCopyWithImpl<TimelineItem>(
          this as TimelineItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TimelineItem &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, order);

  @override
  String toString() {
    return 'TimelineItem(order: $order)';
  }
}

/// @nodoc
abstract mixin class $TimelineItemCopyWith<$Res> {
  factory $TimelineItemCopyWith(
          TimelineItem value, $Res Function(TimelineItem) _then) =
      _$TimelineItemCopyWithImpl;
  @useResult
  $Res call({OrderKey order});

  $OrderKeyCopyWith<$Res> get order;
}

/// @nodoc
class _$TimelineItemCopyWithImpl<$Res> implements $TimelineItemCopyWith<$Res> {
  _$TimelineItemCopyWithImpl(this._self, this._then);

  final TimelineItem _self;
  final $Res Function(TimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? order = null,
  }) {
    return _then(_self.copyWith(
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
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
    TResult Function(MediaTimelineItem value)? media,
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
      case MediaTimelineItem() when media != null:
        return media(_that);
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
    required TResult Function(MediaTimelineItem value) media,
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
      case MediaTimelineItem():
        return media(_that);
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
    TResult? Function(MediaTimelineItem value)? media,
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
      case MediaTimelineItem() when media != null:
        return media(_that);
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
    TResult Function(String id, ChatMessageKind kind, String role, String text,
            OrderKey order)?
        text,
    TResult Function(String id, ChatMessageKind kind, String role, String text,
            OrderKey order)?
        textStream,
    TResult Function(
            String id,
            String name,
            OrderKey order,
            String args,
            String? result,
            List<ToolDiff> diffs,
            String? toolKind,
            bool hasEnded,
            String? status,
            List<ToolLocation> locations,
            List<ToolTerminal> terminals,
            List<ToolPatch> patches,
            List<MediaDescriptor> media,
            List<ToolResultPart> resultParts,
            Map<String, dynamic>? meta)?
        toolCall,
    TResult Function(String id, String? messageId, MediaDescriptor media,
            OrderKey order)?
        media,
    TResult Function(
            String requestId,
            String? toolTitle,
            String? toolCallId,
            String? toolKind,
            String? description,
            String? toolArgs,
            List<PermissionOption> options,
            OrderKey order,
            List<ToolContent> content,
            Map<String, dynamic>? meta,
            String? sessionId,
            Map<String, dynamic> extras)?
        permissionRequest,
    TResult Function(
            String requestId,
            String? toolCallId,
            String message,
            String mode,
            OrderKey order,
            Map<String, dynamic>? schema,
            String? url,
            ElicitationScope? scope,
            Map<String, dynamic>? meta,
            Map<String, dynamic>? rawMode,
            Map<String, dynamic> extras)?
        elicitationRequest,
    TResult Function(String requestId, String toolName, OrderKey order,
            String? toolTitle, String? toolKind, String argsJson)?
        toolRequest,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that.id, _that.kind, _that.role, _that.text, _that.order);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(
            _that.id, _that.kind, _that.role, _that.text, _that.order);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(
            _that.id,
            _that.name,
            _that.order,
            _that.args,
            _that.result,
            _that.diffs,
            _that.toolKind,
            _that.hasEnded,
            _that.status,
            _that.locations,
            _that.terminals,
            _that.patches,
            _that.media,
            _that.resultParts,
            _that.meta);
      case MediaTimelineItem() when media != null:
        return media(_that.id, _that.messageId, _that.media, _that.order);
      case PermissionRequestTimelineItem() when permissionRequest != null:
        return permissionRequest(
            _that.requestId,
            _that.toolTitle,
            _that.toolCallId,
            _that.toolKind,
            _that.description,
            _that.toolArgs,
            _that.options,
            _that.order,
            _that.content,
            _that.meta,
            _that.sessionId,
            _that.extras);
      case ElicitationRequestTimelineItem() when elicitationRequest != null:
        return elicitationRequest(
            _that.requestId,
            _that.toolCallId,
            _that.message,
            _that.mode,
            _that.order,
            _that.schema,
            _that.url,
            _that.scope,
            _that.meta,
            _that.rawMode,
            _that.extras);
      case ToolRequestTimelineItem() when toolRequest != null:
        return toolRequest(_that.requestId, _that.toolName, _that.order,
            _that.toolTitle, _that.toolKind, _that.argsJson);
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
    required TResult Function(String id, ChatMessageKind kind, String role,
            String text, OrderKey order)
        text,
    required TResult Function(String id, ChatMessageKind kind, String role,
            String text, OrderKey order)
        textStream,
    required TResult Function(
            String id,
            String name,
            OrderKey order,
            String args,
            String? result,
            List<ToolDiff> diffs,
            String? toolKind,
            bool hasEnded,
            String? status,
            List<ToolLocation> locations,
            List<ToolTerminal> terminals,
            List<ToolPatch> patches,
            List<MediaDescriptor> media,
            List<ToolResultPart> resultParts,
            Map<String, dynamic>? meta)
        toolCall,
    required TResult Function(
            String id, String? messageId, MediaDescriptor media, OrderKey order)
        media,
    required TResult Function(
            String requestId,
            String? toolTitle,
            String? toolCallId,
            String? toolKind,
            String? description,
            String? toolArgs,
            List<PermissionOption> options,
            OrderKey order,
            List<ToolContent> content,
            Map<String, dynamic>? meta,
            String? sessionId,
            Map<String, dynamic> extras)
        permissionRequest,
    required TResult Function(
            String requestId,
            String? toolCallId,
            String message,
            String mode,
            OrderKey order,
            Map<String, dynamic>? schema,
            String? url,
            ElicitationScope? scope,
            Map<String, dynamic>? meta,
            Map<String, dynamic>? rawMode,
            Map<String, dynamic> extras)
        elicitationRequest,
    required TResult Function(String requestId, String toolName, OrderKey order,
            String? toolTitle, String? toolKind, String argsJson)
        toolRequest,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem():
        return text(_that.id, _that.kind, _that.role, _that.text, _that.order);
      case TextStreamTimelineItem():
        return textStream(
            _that.id, _that.kind, _that.role, _that.text, _that.order);
      case ToolCallTimelineItem():
        return toolCall(
            _that.id,
            _that.name,
            _that.order,
            _that.args,
            _that.result,
            _that.diffs,
            _that.toolKind,
            _that.hasEnded,
            _that.status,
            _that.locations,
            _that.terminals,
            _that.patches,
            _that.media,
            _that.resultParts,
            _that.meta);
      case MediaTimelineItem():
        return media(_that.id, _that.messageId, _that.media, _that.order);
      case PermissionRequestTimelineItem():
        return permissionRequest(
            _that.requestId,
            _that.toolTitle,
            _that.toolCallId,
            _that.toolKind,
            _that.description,
            _that.toolArgs,
            _that.options,
            _that.order,
            _that.content,
            _that.meta,
            _that.sessionId,
            _that.extras);
      case ElicitationRequestTimelineItem():
        return elicitationRequest(
            _that.requestId,
            _that.toolCallId,
            _that.message,
            _that.mode,
            _that.order,
            _that.schema,
            _that.url,
            _that.scope,
            _that.meta,
            _that.rawMode,
            _that.extras);
      case ToolRequestTimelineItem():
        return toolRequest(_that.requestId, _that.toolName, _that.order,
            _that.toolTitle, _that.toolKind, _that.argsJson);
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
    TResult? Function(String id, ChatMessageKind kind, String role, String text,
            OrderKey order)?
        text,
    TResult? Function(String id, ChatMessageKind kind, String role, String text,
            OrderKey order)?
        textStream,
    TResult? Function(
            String id,
            String name,
            OrderKey order,
            String args,
            String? result,
            List<ToolDiff> diffs,
            String? toolKind,
            bool hasEnded,
            String? status,
            List<ToolLocation> locations,
            List<ToolTerminal> terminals,
            List<ToolPatch> patches,
            List<MediaDescriptor> media,
            List<ToolResultPart> resultParts,
            Map<String, dynamic>? meta)?
        toolCall,
    TResult? Function(String id, String? messageId, MediaDescriptor media,
            OrderKey order)?
        media,
    TResult? Function(
            String requestId,
            String? toolTitle,
            String? toolCallId,
            String? toolKind,
            String? description,
            String? toolArgs,
            List<PermissionOption> options,
            OrderKey order,
            List<ToolContent> content,
            Map<String, dynamic>? meta,
            String? sessionId,
            Map<String, dynamic> extras)?
        permissionRequest,
    TResult? Function(
            String requestId,
            String? toolCallId,
            String message,
            String mode,
            OrderKey order,
            Map<String, dynamic>? schema,
            String? url,
            ElicitationScope? scope,
            Map<String, dynamic>? meta,
            Map<String, dynamic>? rawMode,
            Map<String, dynamic> extras)?
        elicitationRequest,
    TResult? Function(String requestId, String toolName, OrderKey order,
            String? toolTitle, String? toolKind, String argsJson)?
        toolRequest,
  }) {
    final _that = this;
    switch (_that) {
      case TextTimelineItem() when text != null:
        return text(_that.id, _that.kind, _that.role, _that.text, _that.order);
      case TextStreamTimelineItem() when textStream != null:
        return textStream(
            _that.id, _that.kind, _that.role, _that.text, _that.order);
      case ToolCallTimelineItem() when toolCall != null:
        return toolCall(
            _that.id,
            _that.name,
            _that.order,
            _that.args,
            _that.result,
            _that.diffs,
            _that.toolKind,
            _that.hasEnded,
            _that.status,
            _that.locations,
            _that.terminals,
            _that.patches,
            _that.media,
            _that.resultParts,
            _that.meta);
      case MediaTimelineItem() when media != null:
        return media(_that.id, _that.messageId, _that.media, _that.order);
      case PermissionRequestTimelineItem() when permissionRequest != null:
        return permissionRequest(
            _that.requestId,
            _that.toolTitle,
            _that.toolCallId,
            _that.toolKind,
            _that.description,
            _that.toolArgs,
            _that.options,
            _that.order,
            _that.content,
            _that.meta,
            _that.sessionId,
            _that.extras);
      case ElicitationRequestTimelineItem() when elicitationRequest != null:
        return elicitationRequest(
            _that.requestId,
            _that.toolCallId,
            _that.message,
            _that.mode,
            _that.order,
            _that.schema,
            _that.url,
            _that.scope,
            _that.meta,
            _that.rawMode,
            _that.extras);
      case ToolRequestTimelineItem() when toolRequest != null:
        return toolRequest(_that.requestId, _that.toolName, _that.order,
            _that.toolTitle, _that.toolKind, _that.argsJson);
      case _:
        return null;
    }
  }
}

/// @nodoc

class TextTimelineItem extends TimelineItem {
  const TextTimelineItem(
      {required this.id,
      required this.kind,
      required this.role,
      required this.text,
      required this.order})
      : super._();

  final String id;
  final ChatMessageKind kind;
  final String role;
  final String text;
  @override
  final OrderKey order;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
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
            (identical(other.text, text) || other.text == text) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, kind, role, text, order);

  @override
  String toString() {
    return 'TimelineItem.text(id: $id, kind: $kind, role: $role, text: $text, order: $order)';
  }
}

/// @nodoc
abstract mixin class $TextTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $TextTimelineItemCopyWith(
          TextTimelineItem value, $Res Function(TextTimelineItem) _then) =
      _$TextTimelineItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      ChatMessageKind kind,
      String role,
      String text,
      OrderKey order});

  @override
  $OrderKeyCopyWith<$Res> get order;
}

/// @nodoc
class _$TextTimelineItemCopyWithImpl<$Res>
    implements $TextTimelineItemCopyWith<$Res> {
  _$TextTimelineItemCopyWithImpl(this._self, this._then);

  final TextTimelineItem _self;
  final $Res Function(TextTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? kind = null,
    Object? role = null,
    Object? text = null,
    Object? order = null,
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
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

/// @nodoc

class TextStreamTimelineItem extends TimelineItem {
  const TextStreamTimelineItem(
      {required this.id,
      this.kind = ChatMessageKind.text,
      required this.role,
      required this.text,
      required this.order})
      : super._();

  final String id;
  @JsonKey()
  final ChatMessageKind kind;
  final String role;
  final String text;
  @override
  final OrderKey order;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
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
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, kind, role, text, order);

  @override
  String toString() {
    return 'TimelineItem.textStream(id: $id, kind: $kind, role: $role, text: $text, order: $order)';
  }
}

/// @nodoc
abstract mixin class $TextStreamTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $TextStreamTimelineItemCopyWith(TextStreamTimelineItem value,
          $Res Function(TextStreamTimelineItem) _then) =
      _$TextStreamTimelineItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      ChatMessageKind kind,
      String role,
      String text,
      OrderKey order});

  @override
  $OrderKeyCopyWith<$Res> get order;
}

/// @nodoc
class _$TextStreamTimelineItemCopyWithImpl<$Res>
    implements $TextStreamTimelineItemCopyWith<$Res> {
  _$TextStreamTimelineItemCopyWithImpl(this._self, this._then);

  final TextStreamTimelineItem _self;
  final $Res Function(TextStreamTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? kind = null,
    Object? role = null,
    Object? text = null,
    Object? order = null,
  }) {
    return _then(TextStreamTimelineItem(
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
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

/// @nodoc

class ToolCallTimelineItem extends TimelineItem {
  const ToolCallTimelineItem(
      {required this.id,
      required this.name,
      required this.order,
      this.args = '',
      this.result,
      final List<ToolDiff> diffs = const <ToolDiff>[],
      this.toolKind,
      this.hasEnded = false,
      this.status,
      final List<ToolLocation> locations = const <ToolLocation>[],
      final List<ToolTerminal> terminals = const <ToolTerminal>[],
      final List<ToolPatch> patches = const <ToolPatch>[],
      final List<MediaDescriptor> media = const <MediaDescriptor>[],
      final List<ToolResultPart> resultParts = const <ToolResultPart>[],
      final Map<String, dynamic>? meta})
      : _diffs = diffs,
        _locations = locations,
        _terminals = terminals,
        _patches = patches,
        _media = media,
        _resultParts = resultParts,
        _meta = meta,
        super._();

  final String id;
  final String name;
  @override
  final OrderKey order;
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

  final String? toolKind;
  @JsonKey()
  final bool hasEnded;
  final String? status;
  final List<ToolLocation> _locations;
  @JsonKey()
  List<ToolLocation> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  final List<ToolTerminal> _terminals;
  @JsonKey()
  List<ToolTerminal> get terminals {
    if (_terminals is EqualUnmodifiableListView) return _terminals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_terminals);
  }

  final List<ToolPatch> _patches;
  @JsonKey()
  List<ToolPatch> get patches {
    if (_patches is EqualUnmodifiableListView) return _patches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_patches);
  }

  final List<MediaDescriptor> _media;
  @JsonKey()
  List<MediaDescriptor> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  final List<ToolResultPart> _resultParts;
  @JsonKey()
  List<ToolResultPart> get resultParts {
    if (_resultParts is EqualUnmodifiableListView) return _resultParts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_resultParts);
  }

  final Map<String, dynamic>? _meta;
  Map<String, dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
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
            (identical(other.order, order) || other.order == order) &&
            (identical(other.args, args) || other.args == args) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality().equals(other._diffs, _diffs) &&
            (identical(other.toolKind, toolKind) ||
                other.toolKind == toolKind) &&
            (identical(other.hasEnded, hasEnded) ||
                other.hasEnded == hasEnded) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._locations, _locations) &&
            const DeepCollectionEquality()
                .equals(other._terminals, _terminals) &&
            const DeepCollectionEquality().equals(other._patches, _patches) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality()
                .equals(other._resultParts, _resultParts) &&
            const DeepCollectionEquality().equals(other._meta, _meta));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      order,
      args,
      result,
      const DeepCollectionEquality().hash(_diffs),
      toolKind,
      hasEnded,
      status,
      const DeepCollectionEquality().hash(_locations),
      const DeepCollectionEquality().hash(_terminals),
      const DeepCollectionEquality().hash(_patches),
      const DeepCollectionEquality().hash(_media),
      const DeepCollectionEquality().hash(_resultParts),
      const DeepCollectionEquality().hash(_meta));

  @override
  String toString() {
    return 'TimelineItem.toolCall(id: $id, name: $name, order: $order, args: $args, result: $result, diffs: $diffs, toolKind: $toolKind, hasEnded: $hasEnded, status: $status, locations: $locations, terminals: $terminals, patches: $patches, media: $media, resultParts: $resultParts, meta: $meta)';
  }
}

/// @nodoc
abstract mixin class $ToolCallTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ToolCallTimelineItemCopyWith(ToolCallTimelineItem value,
          $Res Function(ToolCallTimelineItem) _then) =
      _$ToolCallTimelineItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      OrderKey order,
      String args,
      String? result,
      List<ToolDiff> diffs,
      String? toolKind,
      bool hasEnded,
      String? status,
      List<ToolLocation> locations,
      List<ToolTerminal> terminals,
      List<ToolPatch> patches,
      List<MediaDescriptor> media,
      List<ToolResultPart> resultParts,
      Map<String, dynamic>? meta});

  @override
  $OrderKeyCopyWith<$Res> get order;
}

/// @nodoc
class _$ToolCallTimelineItemCopyWithImpl<$Res>
    implements $ToolCallTimelineItemCopyWith<$Res> {
  _$ToolCallTimelineItemCopyWithImpl(this._self, this._then);

  final ToolCallTimelineItem _self;
  final $Res Function(ToolCallTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? order = null,
    Object? args = null,
    Object? result = freezed,
    Object? diffs = null,
    Object? toolKind = freezed,
    Object? hasEnded = null,
    Object? status = freezed,
    Object? locations = null,
    Object? terminals = null,
    Object? patches = null,
    Object? media = null,
    Object? resultParts = null,
    Object? meta = freezed,
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
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
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
      toolKind: freezed == toolKind
          ? _self.toolKind
          : toolKind // ignore: cast_nullable_to_non_nullable
              as String?,
      hasEnded: null == hasEnded
          ? _self.hasEnded
          : hasEnded // ignore: cast_nullable_to_non_nullable
              as bool,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      locations: null == locations
          ? _self._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<ToolLocation>,
      terminals: null == terminals
          ? _self._terminals
          : terminals // ignore: cast_nullable_to_non_nullable
              as List<ToolTerminal>,
      patches: null == patches
          ? _self._patches
          : patches // ignore: cast_nullable_to_non_nullable
              as List<ToolPatch>,
      media: null == media
          ? _self._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaDescriptor>,
      resultParts: null == resultParts
          ? _self._resultParts
          : resultParts // ignore: cast_nullable_to_non_nullable
              as List<ToolResultPart>,
      meta: freezed == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

/// @nodoc

class MediaTimelineItem extends TimelineItem {
  const MediaTimelineItem(
      {required this.id,
      this.messageId,
      required this.media,
      required this.order})
      : super._();

  final String id;
  final String? messageId;
  final MediaDescriptor media;
  @override
  final OrderKey order;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaTimelineItemCopyWith<MediaTimelineItem> get copyWith =>
      _$MediaTimelineItemCopyWithImpl<MediaTimelineItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaTimelineItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.media, media) || other.media == media) &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, messageId, media, order);

  @override
  String toString() {
    return 'TimelineItem.media(id: $id, messageId: $messageId, media: $media, order: $order)';
  }
}

/// @nodoc
abstract mixin class $MediaTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $MediaTimelineItemCopyWith(
          MediaTimelineItem value, $Res Function(MediaTimelineItem) _then) =
      _$MediaTimelineItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String? messageId, MediaDescriptor media, OrderKey order});

  $MediaDescriptorCopyWith<$Res> get media;
  @override
  $OrderKeyCopyWith<$Res> get order;
}

/// @nodoc
class _$MediaTimelineItemCopyWithImpl<$Res>
    implements $MediaTimelineItemCopyWith<$Res> {
  _$MediaTimelineItemCopyWithImpl(this._self, this._then);

  final MediaTimelineItem _self;
  final $Res Function(MediaTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? messageId = freezed,
    Object? media = null,
    Object? order = null,
  }) {
    return _then(MediaTimelineItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: freezed == messageId
          ? _self.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      media: null == media
          ? _self.media
          : media // ignore: cast_nullable_to_non_nullable
              as MediaDescriptor,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MediaDescriptorCopyWith<$Res> get media {
    return $MediaDescriptorCopyWith<$Res>(_self.media, (value) {
      return _then(_self.copyWith(media: value));
    });
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

/// @nodoc

class PermissionRequestTimelineItem extends TimelineItem {
  const PermissionRequestTimelineItem(
      {required this.requestId,
      this.toolTitle,
      this.toolCallId,
      this.toolKind,
      this.description,
      this.toolArgs,
      required final List<PermissionOption> options,
      required this.order,
      final List<ToolContent> content = const <ToolContent>[],
      final Map<String, dynamic>? meta,
      this.sessionId,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _options = options,
        _content = content,
        _meta = meta,
        _extras = extras,
        super._();

  final String requestId;
  final String? toolTitle;
  final String? toolCallId;
  final String? toolKind;
  final String? description;
  final String? toolArgs;
  final List<PermissionOption> _options;
  List<PermissionOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final OrderKey order;
  final List<ToolContent> _content;
  @JsonKey()
  List<ToolContent> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  final Map<String, dynamic>? _meta;
  Map<String, dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final String? sessionId;
  final Map<String, dynamic> _extras;
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
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
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            (identical(other.toolKind, toolKind) ||
                other.toolKind == toolKind) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.toolArgs, toolArgs) ||
                other.toolArgs == toolArgs) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestId,
      toolTitle,
      toolCallId,
      toolKind,
      description,
      toolArgs,
      const DeepCollectionEquality().hash(_options),
      order,
      const DeepCollectionEquality().hash(_content),
      const DeepCollectionEquality().hash(_meta),
      sessionId,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'TimelineItem.permissionRequest(requestId: $requestId, toolTitle: $toolTitle, toolCallId: $toolCallId, toolKind: $toolKind, description: $description, toolArgs: $toolArgs, options: $options, order: $order, content: $content, meta: $meta, sessionId: $sessionId, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $PermissionRequestTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $PermissionRequestTimelineItemCopyWith(
          PermissionRequestTimelineItem value,
          $Res Function(PermissionRequestTimelineItem) _then) =
      _$PermissionRequestTimelineItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String requestId,
      String? toolTitle,
      String? toolCallId,
      String? toolKind,
      String? description,
      String? toolArgs,
      List<PermissionOption> options,
      OrderKey order,
      List<ToolContent> content,
      Map<String, dynamic>? meta,
      String? sessionId,
      Map<String, dynamic> extras});

  @override
  $OrderKeyCopyWith<$Res> get order;
}

/// @nodoc
class _$PermissionRequestTimelineItemCopyWithImpl<$Res>
    implements $PermissionRequestTimelineItemCopyWith<$Res> {
  _$PermissionRequestTimelineItemCopyWithImpl(this._self, this._then);

  final PermissionRequestTimelineItem _self;
  final $Res Function(PermissionRequestTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? toolTitle = freezed,
    Object? toolCallId = freezed,
    Object? toolKind = freezed,
    Object? description = freezed,
    Object? toolArgs = freezed,
    Object? options = null,
    Object? order = null,
    Object? content = null,
    Object? meta = freezed,
    Object? sessionId = freezed,
    Object? extras = null,
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
      toolCallId: freezed == toolCallId
          ? _self.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String?,
      toolKind: freezed == toolKind
          ? _self.toolKind
          : toolKind // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      toolArgs: freezed == toolArgs
          ? _self.toolArgs
          : toolArgs // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<PermissionOption>,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
      content: null == content
          ? _self._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<ToolContent>,
      meta: freezed == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      sessionId: freezed == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }
}

/// @nodoc

class ElicitationRequestTimelineItem extends TimelineItem {
  const ElicitationRequestTimelineItem(
      {required this.requestId,
      this.toolCallId,
      required this.message,
      required this.mode,
      required this.order,
      final Map<String, dynamic>? schema,
      this.url,
      this.scope,
      final Map<String, dynamic>? meta,
      final Map<String, dynamic>? rawMode,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _schema = schema,
        _meta = meta,
        _rawMode = rawMode,
        _extras = extras,
        super._();

  final String requestId;
  final String? toolCallId;
  final String message;
  final String mode;
  @override
  final OrderKey order;
  final Map<String, dynamic>? _schema;
  Map<String, dynamic>? get schema {
    final value = _schema;
    if (value == null) return null;
    if (_schema is EqualUnmodifiableMapView) return _schema;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final String? url;
  final ElicitationScope? scope;
  final Map<String, dynamic>? _meta;
  Map<String, dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _rawMode;
  Map<String, dynamic>? get rawMode {
    final value = _rawMode;
    if (value == null) return null;
    if (_rawMode is EqualUnmodifiableMapView) return _rawMode;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic> _extras;
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
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
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.order, order) || other.order == order) &&
            const DeepCollectionEquality().equals(other._schema, _schema) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._rawMode, _rawMode) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      requestId,
      toolCallId,
      message,
      mode,
      order,
      const DeepCollectionEquality().hash(_schema),
      url,
      scope,
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_rawMode),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'TimelineItem.elicitationRequest(requestId: $requestId, toolCallId: $toolCallId, message: $message, mode: $mode, order: $order, schema: $schema, url: $url, scope: $scope, meta: $meta, rawMode: $rawMode, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ElicitationRequestTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ElicitationRequestTimelineItemCopyWith(
          ElicitationRequestTimelineItem value,
          $Res Function(ElicitationRequestTimelineItem) _then) =
      _$ElicitationRequestTimelineItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String requestId,
      String? toolCallId,
      String message,
      String mode,
      OrderKey order,
      Map<String, dynamic>? schema,
      String? url,
      ElicitationScope? scope,
      Map<String, dynamic>? meta,
      Map<String, dynamic>? rawMode,
      Map<String, dynamic> extras});

  @override
  $OrderKeyCopyWith<$Res> get order;
  $ElicitationScopeCopyWith<$Res>? get scope;
}

/// @nodoc
class _$ElicitationRequestTimelineItemCopyWithImpl<$Res>
    implements $ElicitationRequestTimelineItemCopyWith<$Res> {
  _$ElicitationRequestTimelineItemCopyWithImpl(this._self, this._then);

  final ElicitationRequestTimelineItem _self;
  final $Res Function(ElicitationRequestTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? toolCallId = freezed,
    Object? message = null,
    Object? mode = null,
    Object? order = null,
    Object? schema = freezed,
    Object? url = freezed,
    Object? scope = freezed,
    Object? meta = freezed,
    Object? rawMode = freezed,
    Object? extras = null,
  }) {
    return _then(ElicitationRequestTimelineItem(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      toolCallId: freezed == toolCallId
          ? _self.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
      schema: freezed == schema
          ? _self._schema
          : schema // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      scope: freezed == scope
          ? _self.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as ElicitationScope?,
      meta: freezed == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      rawMode: freezed == rawMode
          ? _self._rawMode
          : rawMode // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
  }

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ElicitationScopeCopyWith<$Res>? get scope {
    if (_self.scope == null) {
      return null;
    }

    return $ElicitationScopeCopyWith<$Res>(_self.scope!, (value) {
      return _then(_self.copyWith(scope: value));
    });
  }
}

/// @nodoc

class ToolRequestTimelineItem extends TimelineItem {
  const ToolRequestTimelineItem(
      {required this.requestId,
      required this.toolName,
      required this.order,
      this.toolTitle,
      this.toolKind,
      required this.argsJson})
      : super._();

  final String requestId;
  final String toolName;
  @override
  final OrderKey order;
  final String? toolTitle;
  final String? toolKind;
  final String argsJson;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
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
            (identical(other.toolName, toolName) ||
                other.toolName == toolName) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.toolTitle, toolTitle) ||
                other.toolTitle == toolTitle) &&
            (identical(other.toolKind, toolKind) ||
                other.toolKind == toolKind) &&
            (identical(other.argsJson, argsJson) ||
                other.argsJson == argsJson));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, requestId, toolName, order, toolTitle, toolKind, argsJson);

  @override
  String toString() {
    return 'TimelineItem.toolRequest(requestId: $requestId, toolName: $toolName, order: $order, toolTitle: $toolTitle, toolKind: $toolKind, argsJson: $argsJson)';
  }
}

/// @nodoc
abstract mixin class $ToolRequestTimelineItemCopyWith<$Res>
    implements $TimelineItemCopyWith<$Res> {
  factory $ToolRequestTimelineItemCopyWith(ToolRequestTimelineItem value,
          $Res Function(ToolRequestTimelineItem) _then) =
      _$ToolRequestTimelineItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String requestId,
      String toolName,
      OrderKey order,
      String? toolTitle,
      String? toolKind,
      String argsJson});

  @override
  $OrderKeyCopyWith<$Res> get order;
}

/// @nodoc
class _$ToolRequestTimelineItemCopyWithImpl<$Res>
    implements $ToolRequestTimelineItemCopyWith<$Res> {
  _$ToolRequestTimelineItemCopyWithImpl(this._self, this._then);

  final ToolRequestTimelineItem _self;
  final $Res Function(ToolRequestTimelineItem) _then;

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? requestId = null,
    Object? toolName = null,
    Object? order = null,
    Object? toolTitle = freezed,
    Object? toolKind = freezed,
    Object? argsJson = null,
  }) {
    return _then(ToolRequestTimelineItem(
      requestId: null == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String,
      toolName: null == toolName
          ? _self.toolName
          : toolName // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _self.order
          : order // ignore: cast_nullable_to_non_nullable
              as OrderKey,
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

  /// Create a copy of TimelineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderKeyCopyWith<$Res> get order {
    return $OrderKeyCopyWith<$Res>(_self.order, (value) {
      return _then(_self.copyWith(order: value));
    });
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

  /// Set while the agent process is spawning/handshaking (see
  /// `acp.session_phase` CustomEvent), before it has produced any real
  /// output. Independent of isRunning — never derived from it and never
  /// re-derives it. False for backends that never emit `acp.session_phase`
  /// (e.g. a local, already-warm model).
  bool get isStarting;
  String? get runError;
  RunOutcome? get runOutcome;
  String? get threadId;
  String? get runId;
  String? get stopReason;
  String? get runErrorCode;
  AgentState? get agent;
  ModeState? get mode;
  CommandsState? get commands;
  ConfigState? get configState;
  UsageState? get usage;
  SessionInfo? get sessionInfo;
  PlansState get plans;
  Map<String, dynamic> get responseMeta;

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
            (identical(other.isStarting, isStarting) ||
                other.isStarting == isStarting) &&
            (identical(other.runError, runError) ||
                other.runError == runError) &&
            (identical(other.runOutcome, runOutcome) ||
                other.runOutcome == runOutcome) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.stopReason, stopReason) ||
                other.stopReason == stopReason) &&
            (identical(other.runErrorCode, runErrorCode) ||
                other.runErrorCode == runErrorCode) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.commands, commands) ||
                other.commands == commands) &&
            (identical(other.configState, configState) ||
                other.configState == configState) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.sessionInfo, sessionInfo) ||
                other.sessionInfo == sessionInfo) &&
            (identical(other.plans, plans) || other.plans == plans) &&
            const DeepCollectionEquality()
                .equals(other.responseMeta, responseMeta));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(permission),
        const DeepCollectionEquality().hash(elicitation),
        const DeepCollectionEquality().hash(modes),
        const DeepCollectionEquality().hash(config),
        const DeepCollectionEquality().hash(plan),
        title,
        isRunning,
        isStarting,
        runError,
        runOutcome,
        threadId,
        runId,
        stopReason,
        runErrorCode,
        agent,
        mode,
        commands,
        configState,
        usage,
        sessionInfo,
        plans,
        const DeepCollectionEquality().hash(responseMeta)
      ]);

  @override
  String toString() {
    return 'SessionState(permission: $permission, elicitation: $elicitation, modes: $modes, config: $config, plan: $plan, title: $title, isRunning: $isRunning, isStarting: $isStarting, runError: $runError, runOutcome: $runOutcome, threadId: $threadId, runId: $runId, stopReason: $stopReason, runErrorCode: $runErrorCode, agent: $agent, mode: $mode, commands: $commands, configState: $configState, usage: $usage, sessionInfo: $sessionInfo, plans: $plans, responseMeta: $responseMeta)';
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
      bool isStarting,
      String? runError,
      RunOutcome? runOutcome,
      String? threadId,
      String? runId,
      String? stopReason,
      String? runErrorCode,
      AgentState? agent,
      ModeState? mode,
      CommandsState? commands,
      ConfigState? configState,
      UsageState? usage,
      SessionInfo? sessionInfo,
      PlansState plans,
      Map<String, dynamic> responseMeta});

  $AgentStateCopyWith<$Res>? get agent;
  $ModeStateCopyWith<$Res>? get mode;
  $CommandsStateCopyWith<$Res>? get commands;
  $ConfigStateCopyWith<$Res>? get configState;
  $UsageStateCopyWith<$Res>? get usage;
  $SessionInfoCopyWith<$Res>? get sessionInfo;
  $PlansStateCopyWith<$Res> get plans;
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
    Object? isStarting = null,
    Object? runError = freezed,
    Object? runOutcome = freezed,
    Object? threadId = freezed,
    Object? runId = freezed,
    Object? stopReason = freezed,
    Object? runErrorCode = freezed,
    Object? agent = freezed,
    Object? mode = freezed,
    Object? commands = freezed,
    Object? configState = freezed,
    Object? usage = freezed,
    Object? sessionInfo = freezed,
    Object? plans = null,
    Object? responseMeta = null,
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
      isStarting: null == isStarting
          ? _self.isStarting
          : isStarting // ignore: cast_nullable_to_non_nullable
              as bool,
      runError: freezed == runError
          ? _self.runError
          : runError // ignore: cast_nullable_to_non_nullable
              as String?,
      runOutcome: freezed == runOutcome
          ? _self.runOutcome
          : runOutcome // ignore: cast_nullable_to_non_nullable
              as RunOutcome?,
      threadId: freezed == threadId
          ? _self.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String?,
      stopReason: freezed == stopReason
          ? _self.stopReason
          : stopReason // ignore: cast_nullable_to_non_nullable
              as String?,
      runErrorCode: freezed == runErrorCode
          ? _self.runErrorCode
          : runErrorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      agent: freezed == agent
          ? _self.agent
          : agent // ignore: cast_nullable_to_non_nullable
              as AgentState?,
      mode: freezed == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ModeState?,
      commands: freezed == commands
          ? _self.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as CommandsState?,
      configState: freezed == configState
          ? _self.configState
          : configState // ignore: cast_nullable_to_non_nullable
              as ConfigState?,
      usage: freezed == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as UsageState?,
      sessionInfo: freezed == sessionInfo
          ? _self.sessionInfo
          : sessionInfo // ignore: cast_nullable_to_non_nullable
              as SessionInfo?,
      plans: null == plans
          ? _self.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as PlansState,
      responseMeta: null == responseMeta
          ? _self.responseMeta
          : responseMeta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgentStateCopyWith<$Res>? get agent {
    if (_self.agent == null) {
      return null;
    }

    return $AgentStateCopyWith<$Res>(_self.agent!, (value) {
      return _then(_self.copyWith(agent: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModeStateCopyWith<$Res>? get mode {
    if (_self.mode == null) {
      return null;
    }

    return $ModeStateCopyWith<$Res>(_self.mode!, (value) {
      return _then(_self.copyWith(mode: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommandsStateCopyWith<$Res>? get commands {
    if (_self.commands == null) {
      return null;
    }

    return $CommandsStateCopyWith<$Res>(_self.commands!, (value) {
      return _then(_self.copyWith(commands: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConfigStateCopyWith<$Res>? get configState {
    if (_self.configState == null) {
      return null;
    }

    return $ConfigStateCopyWith<$Res>(_self.configState!, (value) {
      return _then(_self.copyWith(configState: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageStateCopyWith<$Res>? get usage {
    if (_self.usage == null) {
      return null;
    }

    return $UsageStateCopyWith<$Res>(_self.usage!, (value) {
      return _then(_self.copyWith(usage: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionInfoCopyWith<$Res>? get sessionInfo {
    if (_self.sessionInfo == null) {
      return null;
    }

    return $SessionInfoCopyWith<$Res>(_self.sessionInfo!, (value) {
      return _then(_self.copyWith(sessionInfo: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlansStateCopyWith<$Res> get plans {
    return $PlansStateCopyWith<$Res>(_self.plans, (value) {
      return _then(_self.copyWith(plans: value));
    });
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
            bool isStarting,
            String? runError,
            RunOutcome? runOutcome,
            String? threadId,
            String? runId,
            String? stopReason,
            String? runErrorCode,
            AgentState? agent,
            ModeState? mode,
            CommandsState? commands,
            ConfigState? configState,
            UsageState? usage,
            SessionInfo? sessionInfo,
            PlansState plans,
            Map<String, dynamic> responseMeta)?
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
            _that.isStarting,
            _that.runError,
            _that.runOutcome,
            _that.threadId,
            _that.runId,
            _that.stopReason,
            _that.runErrorCode,
            _that.agent,
            _that.mode,
            _that.commands,
            _that.configState,
            _that.usage,
            _that.sessionInfo,
            _that.plans,
            _that.responseMeta);
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
            bool isStarting,
            String? runError,
            RunOutcome? runOutcome,
            String? threadId,
            String? runId,
            String? stopReason,
            String? runErrorCode,
            AgentState? agent,
            ModeState? mode,
            CommandsState? commands,
            ConfigState? configState,
            UsageState? usage,
            SessionInfo? sessionInfo,
            PlansState plans,
            Map<String, dynamic> responseMeta)
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
            _that.isStarting,
            _that.runError,
            _that.runOutcome,
            _that.threadId,
            _that.runId,
            _that.stopReason,
            _that.runErrorCode,
            _that.agent,
            _that.mode,
            _that.commands,
            _that.configState,
            _that.usage,
            _that.sessionInfo,
            _that.plans,
            _that.responseMeta);
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
            bool isStarting,
            String? runError,
            RunOutcome? runOutcome,
            String? threadId,
            String? runId,
            String? stopReason,
            String? runErrorCode,
            AgentState? agent,
            ModeState? mode,
            CommandsState? commands,
            ConfigState? configState,
            UsageState? usage,
            SessionInfo? sessionInfo,
            PlansState plans,
            Map<String, dynamic> responseMeta)?
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
            _that.isStarting,
            _that.runError,
            _that.runOutcome,
            _that.threadId,
            _that.runId,
            _that.stopReason,
            _that.runErrorCode,
            _that.agent,
            _that.mode,
            _that.commands,
            _that.configState,
            _that.usage,
            _that.sessionInfo,
            _that.plans,
            _that.responseMeta);
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
      this.isStarting = false,
      this.runError,
      this.runOutcome,
      this.threadId,
      this.runId,
      this.stopReason,
      this.runErrorCode,
      this.agent,
      this.mode,
      this.commands,
      this.configState,
      this.usage,
      this.sessionInfo,
      this.plans = const PlansState(),
      final Map<String, dynamic> responseMeta = const <String, dynamic>{}})
      : _permission = permission,
        _elicitation = elicitation,
        _modes = modes,
        _config = config,
        _plan = plan,
        _responseMeta = responseMeta,
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

  /// Set while the agent process is spawning/handshaking (see
  /// `acp.session_phase` CustomEvent), before it has produced any real
  /// output. Independent of isRunning — never derived from it and never
  /// re-derives it. False for backends that never emit `acp.session_phase`
  /// (e.g. a local, already-warm model).
  @override
  @JsonKey()
  final bool isStarting;
  @override
  final String? runError;
  @override
  final RunOutcome? runOutcome;
  @override
  final String? threadId;
  @override
  final String? runId;
  @override
  final String? stopReason;
  @override
  final String? runErrorCode;
  @override
  final AgentState? agent;
  @override
  final ModeState? mode;
  @override
  final CommandsState? commands;
  @override
  final ConfigState? configState;
  @override
  final UsageState? usage;
  @override
  final SessionInfo? sessionInfo;
  @override
  @JsonKey()
  final PlansState plans;
  final Map<String, dynamic> _responseMeta;
  @override
  @JsonKey()
  Map<String, dynamic> get responseMeta {
    if (_responseMeta is EqualUnmodifiableMapView) return _responseMeta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_responseMeta);
  }

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
            (identical(other.isStarting, isStarting) ||
                other.isStarting == isStarting) &&
            (identical(other.runError, runError) ||
                other.runError == runError) &&
            (identical(other.runOutcome, runOutcome) ||
                other.runOutcome == runOutcome) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.runId, runId) || other.runId == runId) &&
            (identical(other.stopReason, stopReason) ||
                other.stopReason == stopReason) &&
            (identical(other.runErrorCode, runErrorCode) ||
                other.runErrorCode == runErrorCode) &&
            (identical(other.agent, agent) || other.agent == agent) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.commands, commands) ||
                other.commands == commands) &&
            (identical(other.configState, configState) ||
                other.configState == configState) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            (identical(other.sessionInfo, sessionInfo) ||
                other.sessionInfo == sessionInfo) &&
            (identical(other.plans, plans) || other.plans == plans) &&
            const DeepCollectionEquality()
                .equals(other._responseMeta, _responseMeta));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_permission),
        const DeepCollectionEquality().hash(_elicitation),
        const DeepCollectionEquality().hash(_modes),
        const DeepCollectionEquality().hash(_config),
        const DeepCollectionEquality().hash(_plan),
        title,
        isRunning,
        isStarting,
        runError,
        runOutcome,
        threadId,
        runId,
        stopReason,
        runErrorCode,
        agent,
        mode,
        commands,
        configState,
        usage,
        sessionInfo,
        plans,
        const DeepCollectionEquality().hash(_responseMeta)
      ]);

  @override
  String toString() {
    return 'SessionState(permission: $permission, elicitation: $elicitation, modes: $modes, config: $config, plan: $plan, title: $title, isRunning: $isRunning, isStarting: $isStarting, runError: $runError, runOutcome: $runOutcome, threadId: $threadId, runId: $runId, stopReason: $stopReason, runErrorCode: $runErrorCode, agent: $agent, mode: $mode, commands: $commands, configState: $configState, usage: $usage, sessionInfo: $sessionInfo, plans: $plans, responseMeta: $responseMeta)';
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
      bool isStarting,
      String? runError,
      RunOutcome? runOutcome,
      String? threadId,
      String? runId,
      String? stopReason,
      String? runErrorCode,
      AgentState? agent,
      ModeState? mode,
      CommandsState? commands,
      ConfigState? configState,
      UsageState? usage,
      SessionInfo? sessionInfo,
      PlansState plans,
      Map<String, dynamic> responseMeta});

  @override
  $AgentStateCopyWith<$Res>? get agent;
  @override
  $ModeStateCopyWith<$Res>? get mode;
  @override
  $CommandsStateCopyWith<$Res>? get commands;
  @override
  $ConfigStateCopyWith<$Res>? get configState;
  @override
  $UsageStateCopyWith<$Res>? get usage;
  @override
  $SessionInfoCopyWith<$Res>? get sessionInfo;
  @override
  $PlansStateCopyWith<$Res> get plans;
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
    Object? isStarting = null,
    Object? runError = freezed,
    Object? runOutcome = freezed,
    Object? threadId = freezed,
    Object? runId = freezed,
    Object? stopReason = freezed,
    Object? runErrorCode = freezed,
    Object? agent = freezed,
    Object? mode = freezed,
    Object? commands = freezed,
    Object? configState = freezed,
    Object? usage = freezed,
    Object? sessionInfo = freezed,
    Object? plans = null,
    Object? responseMeta = null,
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
      isStarting: null == isStarting
          ? _self.isStarting
          : isStarting // ignore: cast_nullable_to_non_nullable
              as bool,
      runError: freezed == runError
          ? _self.runError
          : runError // ignore: cast_nullable_to_non_nullable
              as String?,
      runOutcome: freezed == runOutcome
          ? _self.runOutcome
          : runOutcome // ignore: cast_nullable_to_non_nullable
              as RunOutcome?,
      threadId: freezed == threadId
          ? _self.threadId
          : threadId // ignore: cast_nullable_to_non_nullable
              as String?,
      runId: freezed == runId
          ? _self.runId
          : runId // ignore: cast_nullable_to_non_nullable
              as String?,
      stopReason: freezed == stopReason
          ? _self.stopReason
          : stopReason // ignore: cast_nullable_to_non_nullable
              as String?,
      runErrorCode: freezed == runErrorCode
          ? _self.runErrorCode
          : runErrorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      agent: freezed == agent
          ? _self.agent
          : agent // ignore: cast_nullable_to_non_nullable
              as AgentState?,
      mode: freezed == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ModeState?,
      commands: freezed == commands
          ? _self.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as CommandsState?,
      configState: freezed == configState
          ? _self.configState
          : configState // ignore: cast_nullable_to_non_nullable
              as ConfigState?,
      usage: freezed == usage
          ? _self.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as UsageState?,
      sessionInfo: freezed == sessionInfo
          ? _self.sessionInfo
          : sessionInfo // ignore: cast_nullable_to_non_nullable
              as SessionInfo?,
      plans: null == plans
          ? _self.plans
          : plans // ignore: cast_nullable_to_non_nullable
              as PlansState,
      responseMeta: null == responseMeta
          ? _self._responseMeta
          : responseMeta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgentStateCopyWith<$Res>? get agent {
    if (_self.agent == null) {
      return null;
    }

    return $AgentStateCopyWith<$Res>(_self.agent!, (value) {
      return _then(_self.copyWith(agent: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ModeStateCopyWith<$Res>? get mode {
    if (_self.mode == null) {
      return null;
    }

    return $ModeStateCopyWith<$Res>(_self.mode!, (value) {
      return _then(_self.copyWith(mode: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CommandsStateCopyWith<$Res>? get commands {
    if (_self.commands == null) {
      return null;
    }

    return $CommandsStateCopyWith<$Res>(_self.commands!, (value) {
      return _then(_self.copyWith(commands: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConfigStateCopyWith<$Res>? get configState {
    if (_self.configState == null) {
      return null;
    }

    return $ConfigStateCopyWith<$Res>(_self.configState!, (value) {
      return _then(_self.copyWith(configState: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageStateCopyWith<$Res>? get usage {
    if (_self.usage == null) {
      return null;
    }

    return $UsageStateCopyWith<$Res>(_self.usage!, (value) {
      return _then(_self.copyWith(usage: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionInfoCopyWith<$Res>? get sessionInfo {
    if (_self.sessionInfo == null) {
      return null;
    }

    return $SessionInfoCopyWith<$Res>(_self.sessionInfo!, (value) {
      return _then(_self.copyWith(sessionInfo: value));
    });
  }

  /// Create a copy of SessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlansStateCopyWith<$Res> get plans {
    return $PlansStateCopyWith<$Res>(_self.plans, (value) {
      return _then(_self.copyWith(plans: value));
    });
  }
}

/// @nodoc
mixin _$Conversation {
  List<TimelineItem> get timeline;
  SessionState get sessionState;
  List<Diagnostic> get diagnostics;
  List<Map<String, dynamic>> get sourceRecords;

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
                other.sessionState == sessionState) &&
            const DeepCollectionEquality()
                .equals(other.diagnostics, diagnostics) &&
            const DeepCollectionEquality()
                .equals(other.sourceRecords, sourceRecords));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(timeline),
      sessionState,
      const DeepCollectionEquality().hash(diagnostics),
      const DeepCollectionEquality().hash(sourceRecords));

  @override
  String toString() {
    return 'Conversation(timeline: $timeline, sessionState: $sessionState, diagnostics: $diagnostics, sourceRecords: $sourceRecords)';
  }
}

/// @nodoc
abstract mixin class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) _then) =
      _$ConversationCopyWithImpl;
  @useResult
  $Res call(
      {List<TimelineItem> timeline,
      SessionState sessionState,
      List<Diagnostic> diagnostics,
      List<Map<String, dynamic>> sourceRecords});

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
    Object? diagnostics = null,
    Object? sourceRecords = null,
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
      diagnostics: null == diagnostics
          ? _self.diagnostics
          : diagnostics // ignore: cast_nullable_to_non_nullable
              as List<Diagnostic>,
      sourceRecords: null == sourceRecords
          ? _self.sourceRecords
          : sourceRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
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
    TResult Function(
            List<TimelineItem> timeline,
            SessionState sessionState,
            List<Diagnostic> diagnostics,
            List<Map<String, dynamic>> sourceRecords)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that.timeline, _that.sessionState, _that.diagnostics,
            _that.sourceRecords);
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
            List<TimelineItem> timeline,
            SessionState sessionState,
            List<Diagnostic> diagnostics,
            List<Map<String, dynamic>> sourceRecords)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation():
        return $default(_that.timeline, _that.sessionState, _that.diagnostics,
            _that.sourceRecords);
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
            List<TimelineItem> timeline,
            SessionState sessionState,
            List<Diagnostic> diagnostics,
            List<Map<String, dynamic>> sourceRecords)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Conversation() when $default != null:
        return $default(_that.timeline, _that.sessionState, _that.diagnostics,
            _that.sourceRecords);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Conversation extends Conversation {
  const _Conversation(
      {final List<TimelineItem> timeline = const <TimelineItem>[],
      this.sessionState = SessionState.empty,
      final List<Diagnostic> diagnostics = const <Diagnostic>[],
      final List<Map<String, dynamic>> sourceRecords =
          const <Map<String, dynamic>>[]})
      : _timeline = timeline,
        _diagnostics = diagnostics,
        _sourceRecords = sourceRecords,
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
  final List<Diagnostic> _diagnostics;
  @override
  @JsonKey()
  List<Diagnostic> get diagnostics {
    if (_diagnostics is EqualUnmodifiableListView) return _diagnostics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diagnostics);
  }

  final List<Map<String, dynamic>> _sourceRecords;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get sourceRecords {
    if (_sourceRecords is EqualUnmodifiableListView) return _sourceRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sourceRecords);
  }

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
                other.sessionState == sessionState) &&
            const DeepCollectionEquality()
                .equals(other._diagnostics, _diagnostics) &&
            const DeepCollectionEquality()
                .equals(other._sourceRecords, _sourceRecords));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_timeline),
      sessionState,
      const DeepCollectionEquality().hash(_diagnostics),
      const DeepCollectionEquality().hash(_sourceRecords));

  @override
  String toString() {
    return 'Conversation(timeline: $timeline, sessionState: $sessionState, diagnostics: $diagnostics, sourceRecords: $sourceRecords)';
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
  $Res call(
      {List<TimelineItem> timeline,
      SessionState sessionState,
      List<Diagnostic> diagnostics,
      List<Map<String, dynamic>> sourceRecords});

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
    Object? diagnostics = null,
    Object? sourceRecords = null,
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
      diagnostics: null == diagnostics
          ? _self._diagnostics
          : diagnostics // ignore: cast_nullable_to_non_nullable
              as List<Diagnostic>,
      sourceRecords: null == sourceRecords
          ? _self._sourceRecords
          : sourceRecords // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
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
