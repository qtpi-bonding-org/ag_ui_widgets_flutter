// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnostics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Diagnostic {
  DiagnosticKind get kind;
  String get name;
  Object? get payload;

  /// Monotonic over the reducer's whole life — a replay reset does not
  /// restart it — so diagnostics stay ordered.
  int get index;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DiagnosticCopyWith<Diagnostic> get copyWith =>
      _$DiagnosticCopyWithImpl<Diagnostic>(this as Diagnostic, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Diagnostic &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.payload, payload) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, kind, name,
      const DeepCollectionEquality().hash(payload), index);

  @override
  String toString() {
    return 'Diagnostic(kind: $kind, name: $name, payload: $payload, index: $index)';
  }
}

/// @nodoc
abstract mixin class $DiagnosticCopyWith<$Res> {
  factory $DiagnosticCopyWith(
          Diagnostic value, $Res Function(Diagnostic) _then) =
      _$DiagnosticCopyWithImpl;
  @useResult
  $Res call({DiagnosticKind kind, String name, Object? payload, int index});
}

/// @nodoc
class _$DiagnosticCopyWithImpl<$Res> implements $DiagnosticCopyWith<$Res> {
  _$DiagnosticCopyWithImpl(this._self, this._then);

  final Diagnostic _self;
  final $Res Function(Diagnostic) _then;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? name = null,
    Object? payload = freezed,
    Object? index = null,
  }) {
    return _then(_self.copyWith(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as DiagnosticKind,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload ? _self.payload : payload,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [Diagnostic].
extension DiagnosticPatterns on Diagnostic {
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
    TResult Function(_Diagnostic value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Diagnostic() when $default != null:
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
    TResult Function(_Diagnostic value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Diagnostic():
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
    TResult? Function(_Diagnostic value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Diagnostic() when $default != null:
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
            DiagnosticKind kind, String name, Object? payload, int index)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Diagnostic() when $default != null:
        return $default(_that.kind, _that.name, _that.payload, _that.index);
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
            DiagnosticKind kind, String name, Object? payload, int index)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Diagnostic():
        return $default(_that.kind, _that.name, _that.payload, _that.index);
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
            DiagnosticKind kind, String name, Object? payload, int index)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Diagnostic() when $default != null:
        return $default(_that.kind, _that.name, _that.payload, _that.index);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Diagnostic implements Diagnostic {
  const _Diagnostic(
      {required this.kind,
      required this.name,
      this.payload,
      required this.index});

  @override
  final DiagnosticKind kind;
  @override
  final String name;
  @override
  final Object? payload;

  /// Monotonic over the reducer's whole life — a replay reset does not
  /// restart it — so diagnostics stay ordered.
  @override
  final int index;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DiagnosticCopyWith<_Diagnostic> get copyWith =>
      __$DiagnosticCopyWithImpl<_Diagnostic>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Diagnostic &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.payload, payload) &&
            (identical(other.index, index) || other.index == index));
  }

  @override
  int get hashCode => Object.hash(runtimeType, kind, name,
      const DeepCollectionEquality().hash(payload), index);

  @override
  String toString() {
    return 'Diagnostic(kind: $kind, name: $name, payload: $payload, index: $index)';
  }
}

/// @nodoc
abstract mixin class _$DiagnosticCopyWith<$Res>
    implements $DiagnosticCopyWith<$Res> {
  factory _$DiagnosticCopyWith(
          _Diagnostic value, $Res Function(_Diagnostic) _then) =
      __$DiagnosticCopyWithImpl;
  @override
  @useResult
  $Res call({DiagnosticKind kind, String name, Object? payload, int index});
}

/// @nodoc
class __$DiagnosticCopyWithImpl<$Res> implements _$DiagnosticCopyWith<$Res> {
  __$DiagnosticCopyWithImpl(this._self, this._then);

  final _Diagnostic _self;
  final $Res Function(_Diagnostic) _then;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kind = null,
    Object? name = null,
    Object? payload = freezed,
    Object? index = null,
  }) {
    return _then(_Diagnostic(
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as DiagnosticKind,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      payload: freezed == payload ? _self.payload : payload,
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
