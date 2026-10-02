// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_models.dart';

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
  Map<String, dynamic> get extras;

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
            (identical(other.newText, newText) || other.newText == newText) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path, oldText, newText,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ToolDiff(path: $path, oldText: $oldText, newText: $newText, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ToolDiffCopyWith<$Res> {
  factory $ToolDiffCopyWith(ToolDiff value, $Res Function(ToolDiff) _then) =
      _$ToolDiffCopyWithImpl;
  @useResult
  $Res call(
      {String path,
      String oldText,
      String newText,
      Map<String, dynamic> extras});
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
    Object? extras = null,
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
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
    TResult Function(String path, String oldText, String newText,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolDiff() when $default != null:
        return $default(_that.path, _that.oldText, _that.newText, _that.extras);
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
    TResult Function(String path, String oldText, String newText,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolDiff():
        return $default(_that.path, _that.oldText, _that.newText, _that.extras);
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
    TResult? Function(String path, String oldText, String newText,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolDiff() when $default != null:
        return $default(_that.path, _that.oldText, _that.newText, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ToolDiff implements ToolDiff {
  const _ToolDiff(
      {required this.path,
      this.oldText = '',
      required this.newText,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras;

  @override
  final String path;
  @override
  @JsonKey()
  final String oldText;
  @override
  final String newText;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

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
            (identical(other.newText, newText) || other.newText == newText) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path, oldText, newText,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ToolDiff(path: $path, oldText: $oldText, newText: $newText, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ToolDiffCopyWith<$Res>
    implements $ToolDiffCopyWith<$Res> {
  factory _$ToolDiffCopyWith(_ToolDiff value, $Res Function(_ToolDiff) _then) =
      __$ToolDiffCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String path,
      String oldText,
      String newText,
      Map<String, dynamic> extras});
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
    Object? extras = null,
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
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$ToolLocation {
  String get path;
  int? get line;
  Map<String, dynamic> get extras;

  /// Create a copy of ToolLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolLocationCopyWith<ToolLocation> get copyWith =>
      _$ToolLocationCopyWithImpl<ToolLocation>(
          this as ToolLocation, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolLocation &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.line, line) || other.line == line) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, path, line, const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ToolLocation(path: $path, line: $line, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ToolLocationCopyWith<$Res> {
  factory $ToolLocationCopyWith(
          ToolLocation value, $Res Function(ToolLocation) _then) =
      _$ToolLocationCopyWithImpl;
  @useResult
  $Res call({String path, int? line, Map<String, dynamic> extras});
}

/// @nodoc
class _$ToolLocationCopyWithImpl<$Res> implements $ToolLocationCopyWith<$Res> {
  _$ToolLocationCopyWithImpl(this._self, this._then);

  final ToolLocation _self;
  final $Res Function(ToolLocation) _then;

  /// Create a copy of ToolLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? line = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      line: freezed == line
          ? _self.line
          : line // ignore: cast_nullable_to_non_nullable
              as int?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ToolLocation].
extension ToolLocationPatterns on ToolLocation {
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
    TResult Function(_ToolLocation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolLocation() when $default != null:
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
    TResult Function(_ToolLocation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolLocation():
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
    TResult? Function(_ToolLocation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolLocation() when $default != null:
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
    TResult Function(String path, int? line, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolLocation() when $default != null:
        return $default(_that.path, _that.line, _that.extras);
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
    TResult Function(String path, int? line, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolLocation():
        return $default(_that.path, _that.line, _that.extras);
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
    TResult? Function(String path, int? line, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolLocation() when $default != null:
        return $default(_that.path, _that.line, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ToolLocation extends ToolLocation {
  const _ToolLocation(
      {required this.path,
      this.line,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String path;
  @override
  final int? line;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of ToolLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ToolLocationCopyWith<_ToolLocation> get copyWith =>
      __$ToolLocationCopyWithImpl<_ToolLocation>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ToolLocation &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.line, line) || other.line == line) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, path, line, const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ToolLocation(path: $path, line: $line, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ToolLocationCopyWith<$Res>
    implements $ToolLocationCopyWith<$Res> {
  factory _$ToolLocationCopyWith(
          _ToolLocation value, $Res Function(_ToolLocation) _then) =
      __$ToolLocationCopyWithImpl;
  @override
  @useResult
  $Res call({String path, int? line, Map<String, dynamic> extras});
}

/// @nodoc
class __$ToolLocationCopyWithImpl<$Res>
    implements _$ToolLocationCopyWith<$Res> {
  __$ToolLocationCopyWithImpl(this._self, this._then);

  final _ToolLocation _self;
  final $Res Function(_ToolLocation) _then;

  /// Create a copy of ToolLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? path = null,
    Object? line = freezed,
    Object? extras = null,
  }) {
    return _then(_ToolLocation(
      path: null == path
          ? _self.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      line: freezed == line
          ? _self.line
          : line // ignore: cast_nullable_to_non_nullable
              as int?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$ToolTerminal {
  String get terminalId;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of ToolTerminal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolTerminalCopyWith<ToolTerminal> get copyWith =>
      _$ToolTerminalCopyWithImpl<ToolTerminal>(
          this as ToolTerminal, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolTerminal &&
            (identical(other.terminalId, terminalId) ||
                other.terminalId == terminalId) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      terminalId,
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ToolTerminal(terminalId: $terminalId, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ToolTerminalCopyWith<$Res> {
  factory $ToolTerminalCopyWith(
          ToolTerminal value, $Res Function(ToolTerminal) _then) =
      _$ToolTerminalCopyWithImpl;
  @useResult
  $Res call(
      {String terminalId,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$ToolTerminalCopyWithImpl<$Res> implements $ToolTerminalCopyWith<$Res> {
  _$ToolTerminalCopyWithImpl(this._self, this._then);

  final ToolTerminal _self;
  final $Res Function(ToolTerminal) _then;

  /// Create a copy of ToolTerminal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? terminalId = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      terminalId: null == terminalId
          ? _self.terminalId
          : terminalId // ignore: cast_nullable_to_non_nullable
              as String,
      meta: freezed == meta
          ? _self.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ToolTerminal].
extension ToolTerminalPatterns on ToolTerminal {
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
    TResult Function(_ToolTerminal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolTerminal() when $default != null:
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
    TResult Function(_ToolTerminal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolTerminal():
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
    TResult? Function(_ToolTerminal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolTerminal() when $default != null:
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
    TResult Function(String terminalId, Map<String, dynamic>? meta,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolTerminal() when $default != null:
        return $default(_that.terminalId, _that.meta, _that.extras);
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
    TResult Function(String terminalId, Map<String, dynamic>? meta,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolTerminal():
        return $default(_that.terminalId, _that.meta, _that.extras);
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
    TResult? Function(String terminalId, Map<String, dynamic>? meta,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolTerminal() when $default != null:
        return $default(_that.terminalId, _that.meta, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ToolTerminal extends ToolTerminal {
  const _ToolTerminal(
      {required this.terminalId,
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _meta = meta,
        _extras = extras,
        super._();

  @override
  final String terminalId;
  final Map<String, dynamic>? _meta;
  @override
  Map<String, dynamic>? get meta {
    final value = _meta;
    if (value == null) return null;
    if (_meta is EqualUnmodifiableMapView) return _meta;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of ToolTerminal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ToolTerminalCopyWith<_ToolTerminal> get copyWith =>
      __$ToolTerminalCopyWithImpl<_ToolTerminal>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ToolTerminal &&
            (identical(other.terminalId, terminalId) ||
                other.terminalId == terminalId) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      terminalId,
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ToolTerminal(terminalId: $terminalId, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ToolTerminalCopyWith<$Res>
    implements $ToolTerminalCopyWith<$Res> {
  factory _$ToolTerminalCopyWith(
          _ToolTerminal value, $Res Function(_ToolTerminal) _then) =
      __$ToolTerminalCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String terminalId,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$ToolTerminalCopyWithImpl<$Res>
    implements _$ToolTerminalCopyWith<$Res> {
  __$ToolTerminalCopyWithImpl(this._self, this._then);

  final _ToolTerminal _self;
  final $Res Function(_ToolTerminal) _then;

  /// Create a copy of ToolTerminal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? terminalId = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_ToolTerminal(
      terminalId: null == terminalId
          ? _self.terminalId
          : terminalId // ignore: cast_nullable_to_non_nullable
              as String,
      meta: freezed == meta
          ? _self._meta
          : meta // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$ToolPatch {
  String? get format;
  String get patch;
  Map<String, dynamic> get extras;

  /// Create a copy of ToolPatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolPatchCopyWith<ToolPatch> get copyWith =>
      _$ToolPatchCopyWithImpl<ToolPatch>(this as ToolPatch, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolPatch &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.patch, patch) || other.patch == patch) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, format, patch, const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ToolPatch(format: $format, patch: $patch, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ToolPatchCopyWith<$Res> {
  factory $ToolPatchCopyWith(ToolPatch value, $Res Function(ToolPatch) _then) =
      _$ToolPatchCopyWithImpl;
  @useResult
  $Res call({String? format, String patch, Map<String, dynamic> extras});
}

/// @nodoc
class _$ToolPatchCopyWithImpl<$Res> implements $ToolPatchCopyWith<$Res> {
  _$ToolPatchCopyWithImpl(this._self, this._then);

  final ToolPatch _self;
  final $Res Function(ToolPatch) _then;

  /// Create a copy of ToolPatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? format = freezed,
    Object? patch = null,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      format: freezed == format
          ? _self.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      patch: null == patch
          ? _self.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as String,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ToolPatch].
extension ToolPatchPatterns on ToolPatch {
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
    TResult Function(_ToolPatch value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolPatch() when $default != null:
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
    TResult Function(_ToolPatch value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolPatch():
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
    TResult? Function(_ToolPatch value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolPatch() when $default != null:
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
    TResult Function(String? format, String patch, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ToolPatch() when $default != null:
        return $default(_that.format, _that.patch, _that.extras);
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
    TResult Function(String? format, String patch, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolPatch():
        return $default(_that.format, _that.patch, _that.extras);
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
    TResult? Function(
            String? format, String patch, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ToolPatch() when $default != null:
        return $default(_that.format, _that.patch, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ToolPatch extends ToolPatch {
  const _ToolPatch(
      {this.format,
      required this.patch,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String? format;
  @override
  final String patch;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of ToolPatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ToolPatchCopyWith<_ToolPatch> get copyWith =>
      __$ToolPatchCopyWithImpl<_ToolPatch>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ToolPatch &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.patch, patch) || other.patch == patch) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, format, patch, const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ToolPatch(format: $format, patch: $patch, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ToolPatchCopyWith<$Res>
    implements $ToolPatchCopyWith<$Res> {
  factory _$ToolPatchCopyWith(
          _ToolPatch value, $Res Function(_ToolPatch) _then) =
      __$ToolPatchCopyWithImpl;
  @override
  @useResult
  $Res call({String? format, String patch, Map<String, dynamic> extras});
}

/// @nodoc
class __$ToolPatchCopyWithImpl<$Res> implements _$ToolPatchCopyWith<$Res> {
  __$ToolPatchCopyWithImpl(this._self, this._then);

  final _ToolPatch _self;
  final $Res Function(_ToolPatch) _then;

  /// Create a copy of ToolPatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? format = freezed,
    Object? patch = null,
    Object? extras = null,
  }) {
    return _then(_ToolPatch(
      format: freezed == format
          ? _self.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      patch: null == patch
          ? _self.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as String,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$MediaDescriptor {
  String get kind;
  String? get mimeType;
  String? get uri;
  String? get name;
  String? get title;
  String? get description;
  String? get data;
  String? get blob;
  int? get size;
  String? get messageId;
  String? get toolCallId;
  Map<String, dynamic> get extras;

  /// Create a copy of MediaDescriptor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaDescriptorCopyWith<MediaDescriptor> get copyWith =>
      _$MediaDescriptorCopyWithImpl<MediaDescriptor>(
          this as MediaDescriptor, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaDescriptor &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.blob, blob) || other.blob == blob) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      kind,
      mimeType,
      uri,
      name,
      title,
      description,
      data,
      blob,
      size,
      messageId,
      toolCallId,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'MediaDescriptor(kind: $kind, mimeType: $mimeType, uri: $uri, name: $name, title: $title, description: $description, data: $data, blob: $blob, size: $size, messageId: $messageId, toolCallId: $toolCallId, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $MediaDescriptorCopyWith<$Res> {
  factory $MediaDescriptorCopyWith(
          MediaDescriptor value, $Res Function(MediaDescriptor) _then) =
      _$MediaDescriptorCopyWithImpl;
  @useResult
  $Res call(
      {String kind,
      String? mimeType,
      String? uri,
      String? name,
      String? title,
      String? description,
      String? data,
      String? blob,
      int? size,
      String? messageId,
      String? toolCallId,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$MediaDescriptorCopyWithImpl<$Res>
    implements $MediaDescriptorCopyWith<$Res> {
  _$MediaDescriptorCopyWithImpl(this._self, this._then);

  final MediaDescriptor _self;
  final $Res Function(MediaDescriptor) _then;

  /// Create a copy of MediaDescriptor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? mimeType = freezed,
    Object? uri = freezed,
    Object? name = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? data = freezed,
    Object? blob = freezed,
    Object? size = freezed,
    Object? messageId = freezed,
    Object? toolCallId = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: freezed == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      uri: freezed == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      blob: freezed == blob
          ? _self.blob
          : blob // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      messageId: freezed == messageId
          ? _self.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      toolCallId: freezed == toolCallId
          ? _self.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaDescriptor].
extension MediaDescriptorPatterns on MediaDescriptor {
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
    TResult Function(_MediaDescriptor value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaDescriptor() when $default != null:
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
    TResult Function(_MediaDescriptor value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDescriptor():
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
    TResult? Function(_MediaDescriptor value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDescriptor() when $default != null:
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
            String kind,
            String? mimeType,
            String? uri,
            String? name,
            String? title,
            String? description,
            String? data,
            String? blob,
            int? size,
            String? messageId,
            String? toolCallId,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaDescriptor() when $default != null:
        return $default(
            _that.kind,
            _that.mimeType,
            _that.uri,
            _that.name,
            _that.title,
            _that.description,
            _that.data,
            _that.blob,
            _that.size,
            _that.messageId,
            _that.toolCallId,
            _that.extras);
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
            String kind,
            String? mimeType,
            String? uri,
            String? name,
            String? title,
            String? description,
            String? data,
            String? blob,
            int? size,
            String? messageId,
            String? toolCallId,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDescriptor():
        return $default(
            _that.kind,
            _that.mimeType,
            _that.uri,
            _that.name,
            _that.title,
            _that.description,
            _that.data,
            _that.blob,
            _that.size,
            _that.messageId,
            _that.toolCallId,
            _that.extras);
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
    TResult? Function(
            String kind,
            String? mimeType,
            String? uri,
            String? name,
            String? title,
            String? description,
            String? data,
            String? blob,
            int? size,
            String? messageId,
            String? toolCallId,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDescriptor() when $default != null:
        return $default(
            _that.kind,
            _that.mimeType,
            _that.uri,
            _that.name,
            _that.title,
            _that.description,
            _that.data,
            _that.blob,
            _that.size,
            _that.messageId,
            _that.toolCallId,
            _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MediaDescriptor extends MediaDescriptor {
  const _MediaDescriptor(
      {required this.kind,
      this.mimeType,
      this.uri,
      this.name,
      this.title,
      this.description,
      this.data,
      this.blob,
      this.size,
      this.messageId,
      this.toolCallId,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String kind;
  @override
  final String? mimeType;
  @override
  final String? uri;
  @override
  final String? name;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? data;
  @override
  final String? blob;
  @override
  final int? size;
  @override
  final String? messageId;
  @override
  final String? toolCallId;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of MediaDescriptor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaDescriptorCopyWith<_MediaDescriptor> get copyWith =>
      __$MediaDescriptorCopyWithImpl<_MediaDescriptor>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaDescriptor &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.blob, blob) || other.blob == blob) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      kind,
      mimeType,
      uri,
      name,
      title,
      description,
      data,
      blob,
      size,
      messageId,
      toolCallId,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'MediaDescriptor(kind: $kind, mimeType: $mimeType, uri: $uri, name: $name, title: $title, description: $description, data: $data, blob: $blob, size: $size, messageId: $messageId, toolCallId: $toolCallId, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$MediaDescriptorCopyWith<$Res>
    implements $MediaDescriptorCopyWith<$Res> {
  factory _$MediaDescriptorCopyWith(
          _MediaDescriptor value, $Res Function(_MediaDescriptor) _then) =
      __$MediaDescriptorCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String kind,
      String? mimeType,
      String? uri,
      String? name,
      String? title,
      String? description,
      String? data,
      String? blob,
      int? size,
      String? messageId,
      String? toolCallId,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$MediaDescriptorCopyWithImpl<$Res>
    implements _$MediaDescriptorCopyWith<$Res> {
  __$MediaDescriptorCopyWithImpl(this._self, this._then);

  final _MediaDescriptor _self;
  final $Res Function(_MediaDescriptor) _then;

  /// Create a copy of MediaDescriptor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kind = null,
    Object? mimeType = freezed,
    Object? uri = freezed,
    Object? name = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? data = freezed,
    Object? blob = freezed,
    Object? size = freezed,
    Object? messageId = freezed,
    Object? toolCallId = freezed,
    Object? extras = null,
  }) {
    return _then(_MediaDescriptor(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: freezed == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      uri: freezed == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      data: freezed == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as String?,
      blob: freezed == blob
          ? _self.blob
          : blob // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      messageId: freezed == messageId
          ? _self.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String?,
      toolCallId: freezed == toolCallId
          ? _self.toolCallId
          : toolCallId // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$ToolContent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ToolContent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ToolContent()';
  }
}

/// @nodoc
class $ToolContentCopyWith<$Res> {
  $ToolContentCopyWith(ToolContent _, $Res Function(ToolContent) __);
}

/// Adds pattern-matching-related methods to [ToolContent].
extension ToolContentPatterns on ToolContent {
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
    TResult Function(ToolContentDiff value)? diff,
    TResult Function(ToolContentPatch value)? patch,
    TResult Function(ToolContentTerminal value)? terminal,
    TResult Function(ToolContentMedia value)? media,
    TResult Function(ToolContentUnknown value)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ToolContentDiff() when diff != null:
        return diff(_that);
      case ToolContentPatch() when patch != null:
        return patch(_that);
      case ToolContentTerminal() when terminal != null:
        return terminal(_that);
      case ToolContentMedia() when media != null:
        return media(_that);
      case ToolContentUnknown() when unknown != null:
        return unknown(_that);
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
    required TResult Function(ToolContentDiff value) diff,
    required TResult Function(ToolContentPatch value) patch,
    required TResult Function(ToolContentTerminal value) terminal,
    required TResult Function(ToolContentMedia value) media,
    required TResult Function(ToolContentUnknown value) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ToolContentDiff():
        return diff(_that);
      case ToolContentPatch():
        return patch(_that);
      case ToolContentTerminal():
        return terminal(_that);
      case ToolContentMedia():
        return media(_that);
      case ToolContentUnknown():
        return unknown(_that);
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
    TResult? Function(ToolContentDiff value)? diff,
    TResult? Function(ToolContentPatch value)? patch,
    TResult? Function(ToolContentTerminal value)? terminal,
    TResult? Function(ToolContentMedia value)? media,
    TResult? Function(ToolContentUnknown value)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ToolContentDiff() when diff != null:
        return diff(_that);
      case ToolContentPatch() when patch != null:
        return patch(_that);
      case ToolContentTerminal() when terminal != null:
        return terminal(_that);
      case ToolContentMedia() when media != null:
        return media(_that);
      case ToolContentUnknown() when unknown != null:
        return unknown(_that);
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
    TResult Function(ToolDiff diff)? diff,
    TResult Function(ToolPatch patch)? patch,
    TResult Function(ToolTerminal terminal)? terminal,
    TResult Function(MediaDescriptor media)? media,
    TResult Function(Map<String, dynamic> raw)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ToolContentDiff() when diff != null:
        return diff(_that.diff);
      case ToolContentPatch() when patch != null:
        return patch(_that.patch);
      case ToolContentTerminal() when terminal != null:
        return terminal(_that.terminal);
      case ToolContentMedia() when media != null:
        return media(_that.media);
      case ToolContentUnknown() when unknown != null:
        return unknown(_that.raw);
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
    required TResult Function(ToolDiff diff) diff,
    required TResult Function(ToolPatch patch) patch,
    required TResult Function(ToolTerminal terminal) terminal,
    required TResult Function(MediaDescriptor media) media,
    required TResult Function(Map<String, dynamic> raw) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ToolContentDiff():
        return diff(_that.diff);
      case ToolContentPatch():
        return patch(_that.patch);
      case ToolContentTerminal():
        return terminal(_that.terminal);
      case ToolContentMedia():
        return media(_that.media);
      case ToolContentUnknown():
        return unknown(_that.raw);
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
    TResult? Function(ToolDiff diff)? diff,
    TResult? Function(ToolPatch patch)? patch,
    TResult? Function(ToolTerminal terminal)? terminal,
    TResult? Function(MediaDescriptor media)? media,
    TResult? Function(Map<String, dynamic> raw)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ToolContentDiff() when diff != null:
        return diff(_that.diff);
      case ToolContentPatch() when patch != null:
        return patch(_that.patch);
      case ToolContentTerminal() when terminal != null:
        return terminal(_that.terminal);
      case ToolContentMedia() when media != null:
        return media(_that.media);
      case ToolContentUnknown() when unknown != null:
        return unknown(_that.raw);
      case _:
        return null;
    }
  }
}

/// @nodoc

class ToolContentDiff extends ToolContent {
  const ToolContentDiff(this.diff) : super._();

  final ToolDiff diff;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolContentDiffCopyWith<ToolContentDiff> get copyWith =>
      _$ToolContentDiffCopyWithImpl<ToolContentDiff>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolContentDiff &&
            (identical(other.diff, diff) || other.diff == diff));
  }

  @override
  int get hashCode => Object.hash(runtimeType, diff);

  @override
  String toString() {
    return 'ToolContent.diff(diff: $diff)';
  }
}

/// @nodoc
abstract mixin class $ToolContentDiffCopyWith<$Res>
    implements $ToolContentCopyWith<$Res> {
  factory $ToolContentDiffCopyWith(
          ToolContentDiff value, $Res Function(ToolContentDiff) _then) =
      _$ToolContentDiffCopyWithImpl;
  @useResult
  $Res call({ToolDiff diff});

  $ToolDiffCopyWith<$Res> get diff;
}

/// @nodoc
class _$ToolContentDiffCopyWithImpl<$Res>
    implements $ToolContentDiffCopyWith<$Res> {
  _$ToolContentDiffCopyWithImpl(this._self, this._then);

  final ToolContentDiff _self;
  final $Res Function(ToolContentDiff) _then;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? diff = null,
  }) {
    return _then(ToolContentDiff(
      null == diff
          ? _self.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as ToolDiff,
    ));
  }

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ToolDiffCopyWith<$Res> get diff {
    return $ToolDiffCopyWith<$Res>(_self.diff, (value) {
      return _then(_self.copyWith(diff: value));
    });
  }
}

/// @nodoc

class ToolContentPatch extends ToolContent {
  const ToolContentPatch(this.patch) : super._();

  final ToolPatch patch;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolContentPatchCopyWith<ToolContentPatch> get copyWith =>
      _$ToolContentPatchCopyWithImpl<ToolContentPatch>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolContentPatch &&
            (identical(other.patch, patch) || other.patch == patch));
  }

  @override
  int get hashCode => Object.hash(runtimeType, patch);

  @override
  String toString() {
    return 'ToolContent.patch(patch: $patch)';
  }
}

/// @nodoc
abstract mixin class $ToolContentPatchCopyWith<$Res>
    implements $ToolContentCopyWith<$Res> {
  factory $ToolContentPatchCopyWith(
          ToolContentPatch value, $Res Function(ToolContentPatch) _then) =
      _$ToolContentPatchCopyWithImpl;
  @useResult
  $Res call({ToolPatch patch});

  $ToolPatchCopyWith<$Res> get patch;
}

/// @nodoc
class _$ToolContentPatchCopyWithImpl<$Res>
    implements $ToolContentPatchCopyWith<$Res> {
  _$ToolContentPatchCopyWithImpl(this._self, this._then);

  final ToolContentPatch _self;
  final $Res Function(ToolContentPatch) _then;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? patch = null,
  }) {
    return _then(ToolContentPatch(
      null == patch
          ? _self.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as ToolPatch,
    ));
  }

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ToolPatchCopyWith<$Res> get patch {
    return $ToolPatchCopyWith<$Res>(_self.patch, (value) {
      return _then(_self.copyWith(patch: value));
    });
  }
}

/// @nodoc

class ToolContentTerminal extends ToolContent {
  const ToolContentTerminal(this.terminal) : super._();

  final ToolTerminal terminal;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolContentTerminalCopyWith<ToolContentTerminal> get copyWith =>
      _$ToolContentTerminalCopyWithImpl<ToolContentTerminal>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolContentTerminal &&
            (identical(other.terminal, terminal) ||
                other.terminal == terminal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, terminal);

  @override
  String toString() {
    return 'ToolContent.terminal(terminal: $terminal)';
  }
}

/// @nodoc
abstract mixin class $ToolContentTerminalCopyWith<$Res>
    implements $ToolContentCopyWith<$Res> {
  factory $ToolContentTerminalCopyWith(
          ToolContentTerminal value, $Res Function(ToolContentTerminal) _then) =
      _$ToolContentTerminalCopyWithImpl;
  @useResult
  $Res call({ToolTerminal terminal});

  $ToolTerminalCopyWith<$Res> get terminal;
}

/// @nodoc
class _$ToolContentTerminalCopyWithImpl<$Res>
    implements $ToolContentTerminalCopyWith<$Res> {
  _$ToolContentTerminalCopyWithImpl(this._self, this._then);

  final ToolContentTerminal _self;
  final $Res Function(ToolContentTerminal) _then;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? terminal = null,
  }) {
    return _then(ToolContentTerminal(
      null == terminal
          ? _self.terminal
          : terminal // ignore: cast_nullable_to_non_nullable
              as ToolTerminal,
    ));
  }

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ToolTerminalCopyWith<$Res> get terminal {
    return $ToolTerminalCopyWith<$Res>(_self.terminal, (value) {
      return _then(_self.copyWith(terminal: value));
    });
  }
}

/// @nodoc

class ToolContentMedia extends ToolContent {
  const ToolContentMedia(this.media) : super._();

  final MediaDescriptor media;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolContentMediaCopyWith<ToolContentMedia> get copyWith =>
      _$ToolContentMediaCopyWithImpl<ToolContentMedia>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolContentMedia &&
            (identical(other.media, media) || other.media == media));
  }

  @override
  int get hashCode => Object.hash(runtimeType, media);

  @override
  String toString() {
    return 'ToolContent.media(media: $media)';
  }
}

/// @nodoc
abstract mixin class $ToolContentMediaCopyWith<$Res>
    implements $ToolContentCopyWith<$Res> {
  factory $ToolContentMediaCopyWith(
          ToolContentMedia value, $Res Function(ToolContentMedia) _then) =
      _$ToolContentMediaCopyWithImpl;
  @useResult
  $Res call({MediaDescriptor media});

  $MediaDescriptorCopyWith<$Res> get media;
}

/// @nodoc
class _$ToolContentMediaCopyWithImpl<$Res>
    implements $ToolContentMediaCopyWith<$Res> {
  _$ToolContentMediaCopyWithImpl(this._self, this._then);

  final ToolContentMedia _self;
  final $Res Function(ToolContentMedia) _then;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? media = null,
  }) {
    return _then(ToolContentMedia(
      null == media
          ? _self.media
          : media // ignore: cast_nullable_to_non_nullable
              as MediaDescriptor,
    ));
  }

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MediaDescriptorCopyWith<$Res> get media {
    return $MediaDescriptorCopyWith<$Res>(_self.media, (value) {
      return _then(_self.copyWith(media: value));
    });
  }
}

/// @nodoc

class ToolContentUnknown extends ToolContent {
  const ToolContentUnknown(final Map<String, dynamic> raw)
      : _raw = raw,
        super._();

  final Map<String, dynamic> _raw;
  Map<String, dynamic> get raw {
    if (_raw is EqualUnmodifiableMapView) return _raw;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_raw);
  }

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ToolContentUnknownCopyWith<ToolContentUnknown> get copyWith =>
      _$ToolContentUnknownCopyWithImpl<ToolContentUnknown>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ToolContentUnknown &&
            const DeepCollectionEquality().equals(other._raw, _raw));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_raw));

  @override
  String toString() {
    return 'ToolContent.unknown(raw: $raw)';
  }
}

/// @nodoc
abstract mixin class $ToolContentUnknownCopyWith<$Res>
    implements $ToolContentCopyWith<$Res> {
  factory $ToolContentUnknownCopyWith(
          ToolContentUnknown value, $Res Function(ToolContentUnknown) _then) =
      _$ToolContentUnknownCopyWithImpl;
  @useResult
  $Res call({Map<String, dynamic> raw});
}

/// @nodoc
class _$ToolContentUnknownCopyWithImpl<$Res>
    implements $ToolContentUnknownCopyWith<$Res> {
  _$ToolContentUnknownCopyWithImpl(this._self, this._then);

  final ToolContentUnknown _self;
  final $Res Function(ToolContentUnknown) _then;

  /// Create a copy of ToolContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? raw = null,
  }) {
    return _then(ToolContentUnknown(
      null == raw
          ? _self._raw
          : raw // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

// dart format on
