// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ElicitationScope {
  String? get kind;
  String? get requestId;
  String? get sessionId;
  String? get toolCallId;
  Map<String, dynamic> get extras;

  /// Create a copy of ElicitationScope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ElicitationScopeCopyWith<ElicitationScope> get copyWith =>
      _$ElicitationScopeCopyWithImpl<ElicitationScope>(
          this as ElicitationScope, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ElicitationScope &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, kind, requestId, sessionId,
      toolCallId, const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ElicitationScope(kind: $kind, requestId: $requestId, sessionId: $sessionId, toolCallId: $toolCallId, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ElicitationScopeCopyWith<$Res> {
  factory $ElicitationScopeCopyWith(
          ElicitationScope value, $Res Function(ElicitationScope) _then) =
      _$ElicitationScopeCopyWithImpl;
  @useResult
  $Res call(
      {String? kind,
      String? requestId,
      String? sessionId,
      String? toolCallId,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$ElicitationScopeCopyWithImpl<$Res>
    implements $ElicitationScopeCopyWith<$Res> {
  _$ElicitationScopeCopyWithImpl(this._self, this._then);

  final ElicitationScope _self;
  final $Res Function(ElicitationScope) _then;

  /// Create a copy of ElicitationScope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = freezed,
    Object? requestId = freezed,
    Object? sessionId = freezed,
    Object? toolCallId = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      kind: freezed == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String?,
      requestId: freezed == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [ElicitationScope].
extension ElicitationScopePatterns on ElicitationScope {
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
    TResult Function(_ElicitationScope value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ElicitationScope() when $default != null:
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
    TResult Function(_ElicitationScope value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ElicitationScope():
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
    TResult? Function(_ElicitationScope value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ElicitationScope() when $default != null:
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
    TResult Function(String? kind, String? requestId, String? sessionId,
            String? toolCallId, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ElicitationScope() when $default != null:
        return $default(_that.kind, _that.requestId, _that.sessionId,
            _that.toolCallId, _that.extras);
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
    TResult Function(String? kind, String? requestId, String? sessionId,
            String? toolCallId, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ElicitationScope():
        return $default(_that.kind, _that.requestId, _that.sessionId,
            _that.toolCallId, _that.extras);
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
    TResult? Function(String? kind, String? requestId, String? sessionId,
            String? toolCallId, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ElicitationScope() when $default != null:
        return $default(_that.kind, _that.requestId, _that.sessionId,
            _that.toolCallId, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ElicitationScope extends ElicitationScope {
  const _ElicitationScope(
      {this.kind,
      this.requestId,
      this.sessionId,
      this.toolCallId,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String? kind;
  @override
  final String? requestId;
  @override
  final String? sessionId;
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

  /// Create a copy of ElicitationScope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ElicitationScopeCopyWith<_ElicitationScope> get copyWith =>
      __$ElicitationScopeCopyWithImpl<_ElicitationScope>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ElicitationScope &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.toolCallId, toolCallId) ||
                other.toolCallId == toolCallId) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, kind, requestId, sessionId,
      toolCallId, const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ElicitationScope(kind: $kind, requestId: $requestId, sessionId: $sessionId, toolCallId: $toolCallId, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ElicitationScopeCopyWith<$Res>
    implements $ElicitationScopeCopyWith<$Res> {
  factory _$ElicitationScopeCopyWith(
          _ElicitationScope value, $Res Function(_ElicitationScope) _then) =
      __$ElicitationScopeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? kind,
      String? requestId,
      String? sessionId,
      String? toolCallId,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$ElicitationScopeCopyWithImpl<$Res>
    implements _$ElicitationScopeCopyWith<$Res> {
  __$ElicitationScopeCopyWithImpl(this._self, this._then);

  final _ElicitationScope _self;
  final $Res Function(_ElicitationScope) _then;

  /// Create a copy of ElicitationScope
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? kind = freezed,
    Object? requestId = freezed,
    Object? sessionId = freezed,
    Object? toolCallId = freezed,
    Object? extras = null,
  }) {
    return _then(_ElicitationScope(
      kind: freezed == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as String?,
      requestId: freezed == requestId
          ? _self.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
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
mixin _$AuthMethod {
  String? get id;
  String? get name;
  String? get description;
  Map<String, dynamic> get extras;

  /// Create a copy of AuthMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthMethodCopyWith<AuthMethod> get copyWith =>
      _$AuthMethodCopyWithImpl<AuthMethod>(this as AuthMethod, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthMethod &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'AuthMethod(id: $id, name: $name, description: $description, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $AuthMethodCopyWith<$Res> {
  factory $AuthMethodCopyWith(
          AuthMethod value, $Res Function(AuthMethod) _then) =
      _$AuthMethodCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$AuthMethodCopyWithImpl<$Res> implements $AuthMethodCopyWith<$Res> {
  _$AuthMethodCopyWithImpl(this._self, this._then);

  final AuthMethod _self;
  final $Res Function(AuthMethod) _then;

  /// Create a copy of AuthMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthMethod].
extension AuthMethodPatterns on AuthMethod {
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
    TResult Function(_AuthMethod value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthMethod() when $default != null:
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
    TResult Function(_AuthMethod value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMethod():
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
    TResult? Function(_AuthMethod value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMethod() when $default != null:
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
    TResult Function(String? id, String? name, String? description,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthMethod() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.extras);
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
    TResult Function(String? id, String? name, String? description,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMethod():
        return $default(_that.id, _that.name, _that.description, _that.extras);
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
    TResult? Function(String? id, String? name, String? description,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthMethod() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AuthMethod extends AuthMethod {
  const _AuthMethod(
      {this.id,
      this.name,
      this.description,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of AuthMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthMethodCopyWith<_AuthMethod> get copyWith =>
      __$AuthMethodCopyWithImpl<_AuthMethod>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthMethod &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'AuthMethod(id: $id, name: $name, description: $description, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$AuthMethodCopyWith<$Res>
    implements $AuthMethodCopyWith<$Res> {
  factory _$AuthMethodCopyWith(
          _AuthMethod value, $Res Function(_AuthMethod) _then) =
      __$AuthMethodCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$AuthMethodCopyWithImpl<$Res> implements _$AuthMethodCopyWith<$Res> {
  __$AuthMethodCopyWithImpl(this._self, this._then);

  final _AuthMethod _self;
  final $Res Function(_AuthMethod) _then;

  /// Create a copy of AuthMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? extras = null,
  }) {
    return _then(_AuthMethod(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$ModeState {
  String? get currentModeId;
  List<SessionMode> get availableModes;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of ModeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModeStateCopyWith<ModeState> get copyWith =>
      _$ModeStateCopyWithImpl<ModeState>(this as ModeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModeState &&
            (identical(other.currentModeId, currentModeId) ||
                other.currentModeId == currentModeId) &&
            const DeepCollectionEquality()
                .equals(other.availableModes, availableModes) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentModeId,
      const DeepCollectionEquality().hash(availableModes),
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ModeState(currentModeId: $currentModeId, availableModes: $availableModes, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ModeStateCopyWith<$Res> {
  factory $ModeStateCopyWith(ModeState value, $Res Function(ModeState) _then) =
      _$ModeStateCopyWithImpl;
  @useResult
  $Res call(
      {String? currentModeId,
      List<SessionMode> availableModes,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$ModeStateCopyWithImpl<$Res> implements $ModeStateCopyWith<$Res> {
  _$ModeStateCopyWithImpl(this._self, this._then);

  final ModeState _self;
  final $Res Function(ModeState) _then;

  /// Create a copy of ModeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentModeId = freezed,
    Object? availableModes = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      currentModeId: freezed == currentModeId
          ? _self.currentModeId
          : currentModeId // ignore: cast_nullable_to_non_nullable
              as String?,
      availableModes: null == availableModes
          ? _self.availableModes
          : availableModes // ignore: cast_nullable_to_non_nullable
              as List<SessionMode>,
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

/// Adds pattern-matching-related methods to [ModeState].
extension ModeStatePatterns on ModeState {
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
    TResult Function(_ModeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ModeState() when $default != null:
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
    TResult Function(_ModeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModeState():
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
    TResult? Function(_ModeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModeState() when $default != null:
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
    TResult Function(String? currentModeId, List<SessionMode> availableModes,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ModeState() when $default != null:
        return $default(_that.currentModeId, _that.availableModes, _that.meta,
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
    TResult Function(String? currentModeId, List<SessionMode> availableModes,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModeState():
        return $default(_that.currentModeId, _that.availableModes, _that.meta,
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
    TResult? Function(String? currentModeId, List<SessionMode> availableModes,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ModeState() when $default != null:
        return $default(_that.currentModeId, _that.availableModes, _that.meta,
            _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ModeState extends ModeState {
  const _ModeState(
      {this.currentModeId,
      final List<SessionMode> availableModes = const <SessionMode>[],
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _availableModes = availableModes,
        _meta = meta,
        _extras = extras,
        super._();

  @override
  final String? currentModeId;
  final List<SessionMode> _availableModes;
  @override
  @JsonKey()
  List<SessionMode> get availableModes {
    if (_availableModes is EqualUnmodifiableListView) return _availableModes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableModes);
  }

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

  /// Create a copy of ModeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ModeStateCopyWith<_ModeState> get copyWith =>
      __$ModeStateCopyWithImpl<_ModeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ModeState &&
            (identical(other.currentModeId, currentModeId) ||
                other.currentModeId == currentModeId) &&
            const DeepCollectionEquality()
                .equals(other._availableModes, _availableModes) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentModeId,
      const DeepCollectionEquality().hash(_availableModes),
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ModeState(currentModeId: $currentModeId, availableModes: $availableModes, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ModeStateCopyWith<$Res>
    implements $ModeStateCopyWith<$Res> {
  factory _$ModeStateCopyWith(
          _ModeState value, $Res Function(_ModeState) _then) =
      __$ModeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? currentModeId,
      List<SessionMode> availableModes,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$ModeStateCopyWithImpl<$Res> implements _$ModeStateCopyWith<$Res> {
  __$ModeStateCopyWithImpl(this._self, this._then);

  final _ModeState _self;
  final $Res Function(_ModeState) _then;

  /// Create a copy of ModeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentModeId = freezed,
    Object? availableModes = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_ModeState(
      currentModeId: freezed == currentModeId
          ? _self.currentModeId
          : currentModeId // ignore: cast_nullable_to_non_nullable
              as String?,
      availableModes: null == availableModes
          ? _self._availableModes
          : availableModes // ignore: cast_nullable_to_non_nullable
              as List<SessionMode>,
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
mixin _$SessionMode {
  String? get id;
  String? get name;
  String? get description;
  Map<String, dynamic> get extras;

  /// Create a copy of SessionMode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionModeCopyWith<SessionMode> get copyWith =>
      _$SessionModeCopyWithImpl<SessionMode>(this as SessionMode, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionMode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'SessionMode(id: $id, name: $name, description: $description, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $SessionModeCopyWith<$Res> {
  factory $SessionModeCopyWith(
          SessionMode value, $Res Function(SessionMode) _then) =
      _$SessionModeCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$SessionModeCopyWithImpl<$Res> implements $SessionModeCopyWith<$Res> {
  _$SessionModeCopyWithImpl(this._self, this._then);

  final SessionMode _self;
  final $Res Function(SessionMode) _then;

  /// Create a copy of SessionMode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionMode].
extension SessionModePatterns on SessionMode {
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
    TResult Function(_SessionMode value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionMode() when $default != null:
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
    TResult Function(_SessionMode value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMode():
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
    TResult? Function(_SessionMode value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMode() when $default != null:
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
    TResult Function(String? id, String? name, String? description,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionMode() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.extras);
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
    TResult Function(String? id, String? name, String? description,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMode():
        return $default(_that.id, _that.name, _that.description, _that.extras);
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
    TResult? Function(String? id, String? name, String? description,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionMode() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SessionMode extends SessionMode {
  const _SessionMode(
      {this.id,
      this.name,
      this.description,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of SessionMode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionModeCopyWith<_SessionMode> get copyWith =>
      __$SessionModeCopyWithImpl<_SessionMode>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionMode &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'SessionMode(id: $id, name: $name, description: $description, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$SessionModeCopyWith<$Res>
    implements $SessionModeCopyWith<$Res> {
  factory _$SessionModeCopyWith(
          _SessionMode value, $Res Function(_SessionMode) _then) =
      __$SessionModeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$SessionModeCopyWithImpl<$Res> implements _$SessionModeCopyWith<$Res> {
  __$SessionModeCopyWithImpl(this._self, this._then);

  final _SessionMode _self;
  final $Res Function(_SessionMode) _then;

  /// Create a copy of SessionMode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? extras = null,
  }) {
    return _then(_SessionMode(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$AgentInfo {
  String? get name;
  String? get title;
  String? get version;
  Map<String, dynamic> get extras;

  /// Create a copy of AgentInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgentInfoCopyWith<AgentInfo> get copyWith =>
      _$AgentInfoCopyWithImpl<AgentInfo>(this as AgentInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgentInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, title, version,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'AgentInfo(name: $name, title: $title, version: $version, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $AgentInfoCopyWith<$Res> {
  factory $AgentInfoCopyWith(AgentInfo value, $Res Function(AgentInfo) _then) =
      _$AgentInfoCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? title,
      String? version,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$AgentInfoCopyWithImpl<$Res> implements $AgentInfoCopyWith<$Res> {
  _$AgentInfoCopyWithImpl(this._self, this._then);

  final AgentInfo _self;
  final $Res Function(AgentInfo) _then;

  /// Create a copy of AgentInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? title = freezed,
    Object? version = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AgentInfo].
extension AgentInfoPatterns on AgentInfo {
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
    TResult Function(_AgentInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentInfo() when $default != null:
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
    TResult Function(_AgentInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentInfo():
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
    TResult? Function(_AgentInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentInfo() when $default != null:
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
    TResult Function(String? name, String? title, String? version,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentInfo() when $default != null:
        return $default(_that.name, _that.title, _that.version, _that.extras);
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
    TResult Function(String? name, String? title, String? version,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentInfo():
        return $default(_that.name, _that.title, _that.version, _that.extras);
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
    TResult? Function(String? name, String? title, String? version,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentInfo() when $default != null:
        return $default(_that.name, _that.title, _that.version, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AgentInfo extends AgentInfo {
  const _AgentInfo(
      {this.name,
      this.title,
      this.version,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String? name;
  @override
  final String? title;
  @override
  final String? version;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of AgentInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgentInfoCopyWith<_AgentInfo> get copyWith =>
      __$AgentInfoCopyWithImpl<_AgentInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgentInfo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, title, version,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'AgentInfo(name: $name, title: $title, version: $version, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$AgentInfoCopyWith<$Res>
    implements $AgentInfoCopyWith<$Res> {
  factory _$AgentInfoCopyWith(
          _AgentInfo value, $Res Function(_AgentInfo) _then) =
      __$AgentInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? title,
      String? version,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$AgentInfoCopyWithImpl<$Res> implements _$AgentInfoCopyWith<$Res> {
  __$AgentInfoCopyWithImpl(this._self, this._then);

  final _AgentInfo _self;
  final $Res Function(_AgentInfo) _then;

  /// Create a copy of AgentInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? title = freezed,
    Object? version = freezed,
    Object? extras = null,
  }) {
    return _then(_AgentInfo(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$AgentState {
  int? get protocolVersion;
  AgentInfo? get agentInfo;
  Map<String, dynamic>? get agentCapabilities;
  List<AuthMethod> get authMethods;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgentStateCopyWith<AgentState> get copyWith =>
      _$AgentStateCopyWithImpl<AgentState>(this as AgentState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgentState &&
            (identical(other.protocolVersion, protocolVersion) ||
                other.protocolVersion == protocolVersion) &&
            (identical(other.agentInfo, agentInfo) ||
                other.agentInfo == agentInfo) &&
            const DeepCollectionEquality()
                .equals(other.agentCapabilities, agentCapabilities) &&
            const DeepCollectionEquality()
                .equals(other.authMethods, authMethods) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      protocolVersion,
      agentInfo,
      const DeepCollectionEquality().hash(agentCapabilities),
      const DeepCollectionEquality().hash(authMethods),
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'AgentState(protocolVersion: $protocolVersion, agentInfo: $agentInfo, agentCapabilities: $agentCapabilities, authMethods: $authMethods, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $AgentStateCopyWith<$Res> {
  factory $AgentStateCopyWith(
          AgentState value, $Res Function(AgentState) _then) =
      _$AgentStateCopyWithImpl;
  @useResult
  $Res call(
      {int? protocolVersion,
      AgentInfo? agentInfo,
      Map<String, dynamic>? agentCapabilities,
      List<AuthMethod> authMethods,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});

  $AgentInfoCopyWith<$Res>? get agentInfo;
}

/// @nodoc
class _$AgentStateCopyWithImpl<$Res> implements $AgentStateCopyWith<$Res> {
  _$AgentStateCopyWithImpl(this._self, this._then);

  final AgentState _self;
  final $Res Function(AgentState) _then;

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protocolVersion = freezed,
    Object? agentInfo = freezed,
    Object? agentCapabilities = freezed,
    Object? authMethods = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      protocolVersion: freezed == protocolVersion
          ? _self.protocolVersion
          : protocolVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      agentInfo: freezed == agentInfo
          ? _self.agentInfo
          : agentInfo // ignore: cast_nullable_to_non_nullable
              as AgentInfo?,
      agentCapabilities: freezed == agentCapabilities
          ? _self.agentCapabilities
          : agentCapabilities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      authMethods: null == authMethods
          ? _self.authMethods
          : authMethods // ignore: cast_nullable_to_non_nullable
              as List<AuthMethod>,
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

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgentInfoCopyWith<$Res>? get agentInfo {
    if (_self.agentInfo == null) {
      return null;
    }

    return $AgentInfoCopyWith<$Res>(_self.agentInfo!, (value) {
      return _then(_self.copyWith(agentInfo: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AgentState].
extension AgentStatePatterns on AgentState {
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
    TResult Function(_AgentState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentState() when $default != null:
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
    TResult Function(_AgentState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentState():
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
    TResult? Function(_AgentState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentState() when $default != null:
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
            int? protocolVersion,
            AgentInfo? agentInfo,
            Map<String, dynamic>? agentCapabilities,
            List<AuthMethod> authMethods,
            Map<String, dynamic>? meta,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgentState() when $default != null:
        return $default(
            _that.protocolVersion,
            _that.agentInfo,
            _that.agentCapabilities,
            _that.authMethods,
            _that.meta,
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
            int? protocolVersion,
            AgentInfo? agentInfo,
            Map<String, dynamic>? agentCapabilities,
            List<AuthMethod> authMethods,
            Map<String, dynamic>? meta,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentState():
        return $default(
            _that.protocolVersion,
            _that.agentInfo,
            _that.agentCapabilities,
            _that.authMethods,
            _that.meta,
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
            int? protocolVersion,
            AgentInfo? agentInfo,
            Map<String, dynamic>? agentCapabilities,
            List<AuthMethod> authMethods,
            Map<String, dynamic>? meta,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgentState() when $default != null:
        return $default(
            _that.protocolVersion,
            _that.agentInfo,
            _that.agentCapabilities,
            _that.authMethods,
            _that.meta,
            _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AgentState extends AgentState {
  const _AgentState(
      {this.protocolVersion,
      this.agentInfo,
      final Map<String, dynamic>? agentCapabilities,
      final List<AuthMethod> authMethods = const <AuthMethod>[],
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _agentCapabilities = agentCapabilities,
        _authMethods = authMethods,
        _meta = meta,
        _extras = extras,
        super._();

  @override
  final int? protocolVersion;
  @override
  final AgentInfo? agentInfo;
  final Map<String, dynamic>? _agentCapabilities;
  @override
  Map<String, dynamic>? get agentCapabilities {
    final value = _agentCapabilities;
    if (value == null) return null;
    if (_agentCapabilities is EqualUnmodifiableMapView)
      return _agentCapabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<AuthMethod> _authMethods;
  @override
  @JsonKey()
  List<AuthMethod> get authMethods {
    if (_authMethods is EqualUnmodifiableListView) return _authMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_authMethods);
  }

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

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgentStateCopyWith<_AgentState> get copyWith =>
      __$AgentStateCopyWithImpl<_AgentState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgentState &&
            (identical(other.protocolVersion, protocolVersion) ||
                other.protocolVersion == protocolVersion) &&
            (identical(other.agentInfo, agentInfo) ||
                other.agentInfo == agentInfo) &&
            const DeepCollectionEquality()
                .equals(other._agentCapabilities, _agentCapabilities) &&
            const DeepCollectionEquality()
                .equals(other._authMethods, _authMethods) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      protocolVersion,
      agentInfo,
      const DeepCollectionEquality().hash(_agentCapabilities),
      const DeepCollectionEquality().hash(_authMethods),
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'AgentState(protocolVersion: $protocolVersion, agentInfo: $agentInfo, agentCapabilities: $agentCapabilities, authMethods: $authMethods, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$AgentStateCopyWith<$Res>
    implements $AgentStateCopyWith<$Res> {
  factory _$AgentStateCopyWith(
          _AgentState value, $Res Function(_AgentState) _then) =
      __$AgentStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? protocolVersion,
      AgentInfo? agentInfo,
      Map<String, dynamic>? agentCapabilities,
      List<AuthMethod> authMethods,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});

  @override
  $AgentInfoCopyWith<$Res>? get agentInfo;
}

/// @nodoc
class __$AgentStateCopyWithImpl<$Res> implements _$AgentStateCopyWith<$Res> {
  __$AgentStateCopyWithImpl(this._self, this._then);

  final _AgentState _self;
  final $Res Function(_AgentState) _then;

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? protocolVersion = freezed,
    Object? agentInfo = freezed,
    Object? agentCapabilities = freezed,
    Object? authMethods = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_AgentState(
      protocolVersion: freezed == protocolVersion
          ? _self.protocolVersion
          : protocolVersion // ignore: cast_nullable_to_non_nullable
              as int?,
      agentInfo: freezed == agentInfo
          ? _self.agentInfo
          : agentInfo // ignore: cast_nullable_to_non_nullable
              as AgentInfo?,
      agentCapabilities: freezed == agentCapabilities
          ? _self._agentCapabilities
          : agentCapabilities // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      authMethods: null == authMethods
          ? _self._authMethods
          : authMethods // ignore: cast_nullable_to_non_nullable
              as List<AuthMethod>,
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

  /// Create a copy of AgentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AgentInfoCopyWith<$Res>? get agentInfo {
    if (_self.agentInfo == null) {
      return null;
    }

    return $AgentInfoCopyWith<$Res>(_self.agentInfo!, (value) {
      return _then(_self.copyWith(agentInfo: value));
    });
  }
}

/// @nodoc
mixin _$AvailableCommand {
  String? get name;
  String? get description;
  Map<String, dynamic>? get input;
  Map<String, dynamic> get extras;

  /// Create a copy of AvailableCommand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AvailableCommandCopyWith<AvailableCommand> get copyWith =>
      _$AvailableCommandCopyWithImpl<AvailableCommand>(
          this as AvailableCommand, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AvailableCommand &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other.input, input) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      const DeepCollectionEquality().hash(input),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'AvailableCommand(name: $name, description: $description, input: $input, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $AvailableCommandCopyWith<$Res> {
  factory $AvailableCommandCopyWith(
          AvailableCommand value, $Res Function(AvailableCommand) _then) =
      _$AvailableCommandCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? description,
      Map<String, dynamic>? input,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$AvailableCommandCopyWithImpl<$Res>
    implements $AvailableCommandCopyWith<$Res> {
  _$AvailableCommandCopyWithImpl(this._self, this._then);

  final AvailableCommand _self;
  final $Res Function(AvailableCommand) _then;

  /// Create a copy of AvailableCommand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? input = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      input: freezed == input
          ? _self.input
          : input // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AvailableCommand].
extension AvailableCommandPatterns on AvailableCommand {
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
    TResult Function(_AvailableCommand value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AvailableCommand() when $default != null:
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
    TResult Function(_AvailableCommand value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AvailableCommand():
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
    TResult? Function(_AvailableCommand value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AvailableCommand() when $default != null:
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
    TResult Function(String? name, String? description,
            Map<String, dynamic>? input, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AvailableCommand() when $default != null:
        return $default(
            _that.name, _that.description, _that.input, _that.extras);
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
    TResult Function(String? name, String? description,
            Map<String, dynamic>? input, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AvailableCommand():
        return $default(
            _that.name, _that.description, _that.input, _that.extras);
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
    TResult? Function(String? name, String? description,
            Map<String, dynamic>? input, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AvailableCommand() when $default != null:
        return $default(
            _that.name, _that.description, _that.input, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AvailableCommand extends AvailableCommand {
  const _AvailableCommand(
      {this.name,
      this.description,
      final Map<String, dynamic>? input,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _input = input,
        _extras = extras,
        super._();

  @override
  final String? name;
  @override
  final String? description;
  final Map<String, dynamic>? _input;
  @override
  Map<String, dynamic>? get input {
    final value = _input;
    if (value == null) return null;
    if (_input is EqualUnmodifiableMapView) return _input;
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

  /// Create a copy of AvailableCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AvailableCommandCopyWith<_AvailableCommand> get copyWith =>
      __$AvailableCommandCopyWithImpl<_AvailableCommand>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AvailableCommand &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._input, _input) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      description,
      const DeepCollectionEquality().hash(_input),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'AvailableCommand(name: $name, description: $description, input: $input, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$AvailableCommandCopyWith<$Res>
    implements $AvailableCommandCopyWith<$Res> {
  factory _$AvailableCommandCopyWith(
          _AvailableCommand value, $Res Function(_AvailableCommand) _then) =
      __$AvailableCommandCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? description,
      Map<String, dynamic>? input,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$AvailableCommandCopyWithImpl<$Res>
    implements _$AvailableCommandCopyWith<$Res> {
  __$AvailableCommandCopyWithImpl(this._self, this._then);

  final _AvailableCommand _self;
  final $Res Function(_AvailableCommand) _then;

  /// Create a copy of AvailableCommand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? description = freezed,
    Object? input = freezed,
    Object? extras = null,
  }) {
    return _then(_AvailableCommand(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      input: freezed == input
          ? _self._input
          : input // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$CommandsState {
  List<AvailableCommand> get commands;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of CommandsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommandsStateCopyWith<CommandsState> get copyWith =>
      _$CommandsStateCopyWithImpl<CommandsState>(
          this as CommandsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommandsState &&
            const DeepCollectionEquality().equals(other.commands, commands) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(commands),
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'CommandsState(commands: $commands, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $CommandsStateCopyWith<$Res> {
  factory $CommandsStateCopyWith(
          CommandsState value, $Res Function(CommandsState) _then) =
      _$CommandsStateCopyWithImpl;
  @useResult
  $Res call(
      {List<AvailableCommand> commands,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$CommandsStateCopyWithImpl<$Res>
    implements $CommandsStateCopyWith<$Res> {
  _$CommandsStateCopyWithImpl(this._self, this._then);

  final CommandsState _self;
  final $Res Function(CommandsState) _then;

  /// Create a copy of CommandsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? commands = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      commands: null == commands
          ? _self.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<AvailableCommand>,
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

/// Adds pattern-matching-related methods to [CommandsState].
extension CommandsStatePatterns on CommandsState {
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
    TResult Function(_CommandsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommandsState() when $default != null:
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
    TResult Function(_CommandsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommandsState():
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
    TResult? Function(_CommandsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommandsState() when $default != null:
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
    TResult Function(List<AvailableCommand> commands,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommandsState() when $default != null:
        return $default(_that.commands, _that.meta, _that.extras);
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
    TResult Function(List<AvailableCommand> commands,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommandsState():
        return $default(_that.commands, _that.meta, _that.extras);
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
    TResult? Function(List<AvailableCommand> commands,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommandsState() when $default != null:
        return $default(_that.commands, _that.meta, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CommandsState extends CommandsState {
  const _CommandsState(
      {final List<AvailableCommand> commands = const <AvailableCommand>[],
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _commands = commands,
        _meta = meta,
        _extras = extras,
        super._();

  final List<AvailableCommand> _commands;
  @override
  @JsonKey()
  List<AvailableCommand> get commands {
    if (_commands is EqualUnmodifiableListView) return _commands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commands);
  }

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

  /// Create a copy of CommandsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CommandsStateCopyWith<_CommandsState> get copyWith =>
      __$CommandsStateCopyWithImpl<_CommandsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CommandsState &&
            const DeepCollectionEquality().equals(other._commands, _commands) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_commands),
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'CommandsState(commands: $commands, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$CommandsStateCopyWith<$Res>
    implements $CommandsStateCopyWith<$Res> {
  factory _$CommandsStateCopyWith(
          _CommandsState value, $Res Function(_CommandsState) _then) =
      __$CommandsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<AvailableCommand> commands,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$CommandsStateCopyWithImpl<$Res>
    implements _$CommandsStateCopyWith<$Res> {
  __$CommandsStateCopyWithImpl(this._self, this._then);

  final _CommandsState _self;
  final $Res Function(_CommandsState) _then;

  /// Create a copy of CommandsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? commands = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_CommandsState(
      commands: null == commands
          ? _self._commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<AvailableCommand>,
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
mixin _$ConfigOption {
  String? get id;
  String? get name;
  String? get description;
  String? get category;
  String? get type;
  Object? get currentValue;
  List<Map<String, dynamic>> get choices;
  Map<String, dynamic> get extras;

  /// Create a copy of ConfigOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfigOptionCopyWith<ConfigOption> get copyWith =>
      _$ConfigOptionCopyWithImpl<ConfigOption>(
          this as ConfigOption, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfigOption &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.currentValue, currentValue) &&
            const DeepCollectionEquality().equals(other.choices, choices) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      type,
      const DeepCollectionEquality().hash(currentValue),
      const DeepCollectionEquality().hash(choices),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ConfigOption(id: $id, name: $name, description: $description, category: $category, type: $type, currentValue: $currentValue, choices: $choices, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ConfigOptionCopyWith<$Res> {
  factory $ConfigOptionCopyWith(
          ConfigOption value, $Res Function(ConfigOption) _then) =
      _$ConfigOptionCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      String? category,
      String? type,
      Object? currentValue,
      List<Map<String, dynamic>> choices,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$ConfigOptionCopyWithImpl<$Res> implements $ConfigOptionCopyWith<$Res> {
  _$ConfigOptionCopyWithImpl(this._self, this._then);

  final ConfigOption _self;
  final $Res Function(ConfigOption) _then;

  /// Create a copy of ConfigOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? type = freezed,
    Object? currentValue = freezed,
    Object? choices = null,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      currentValue: freezed == currentValue ? _self.currentValue : currentValue,
      choices: null == choices
          ? _self.choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ConfigOption].
extension ConfigOptionPatterns on ConfigOption {
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
    TResult Function(_ConfigOption value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfigOption() when $default != null:
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
    TResult Function(_ConfigOption value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigOption():
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
    TResult? Function(_ConfigOption value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigOption() when $default != null:
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
            String? id,
            String? name,
            String? description,
            String? category,
            String? type,
            Object? currentValue,
            List<Map<String, dynamic>> choices,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfigOption() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.category,
            _that.type, _that.currentValue, _that.choices, _that.extras);
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
            String? id,
            String? name,
            String? description,
            String? category,
            String? type,
            Object? currentValue,
            List<Map<String, dynamic>> choices,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigOption():
        return $default(_that.id, _that.name, _that.description, _that.category,
            _that.type, _that.currentValue, _that.choices, _that.extras);
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
            String? id,
            String? name,
            String? description,
            String? category,
            String? type,
            Object? currentValue,
            List<Map<String, dynamic>> choices,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigOption() when $default != null:
        return $default(_that.id, _that.name, _that.description, _that.category,
            _that.type, _that.currentValue, _that.choices, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConfigOption extends ConfigOption {
  const _ConfigOption(
      {this.id,
      this.name,
      this.description,
      this.category,
      this.type,
      this.currentValue,
      final List<Map<String, dynamic>> choices = const <Map<String, dynamic>>[],
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _choices = choices,
        _extras = extras,
        super._();

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? category;
  @override
  final String? type;
  @override
  final Object? currentValue;
  final List<Map<String, dynamic>> _choices;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get choices {
    if (_choices is EqualUnmodifiableListView) return _choices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_choices);
  }

  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of ConfigOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfigOptionCopyWith<_ConfigOption> get copyWith =>
      __$ConfigOptionCopyWithImpl<_ConfigOption>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConfigOption &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.currentValue, currentValue) &&
            const DeepCollectionEquality().equals(other._choices, _choices) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      type,
      const DeepCollectionEquality().hash(currentValue),
      const DeepCollectionEquality().hash(_choices),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ConfigOption(id: $id, name: $name, description: $description, category: $category, type: $type, currentValue: $currentValue, choices: $choices, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ConfigOptionCopyWith<$Res>
    implements $ConfigOptionCopyWith<$Res> {
  factory _$ConfigOptionCopyWith(
          _ConfigOption value, $Res Function(_ConfigOption) _then) =
      __$ConfigOptionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      String? category,
      String? type,
      Object? currentValue,
      List<Map<String, dynamic>> choices,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$ConfigOptionCopyWithImpl<$Res>
    implements _$ConfigOptionCopyWith<$Res> {
  __$ConfigOptionCopyWithImpl(this._self, this._then);

  final _ConfigOption _self;
  final $Res Function(_ConfigOption) _then;

  /// Create a copy of ConfigOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? category = freezed,
    Object? type = freezed,
    Object? currentValue = freezed,
    Object? choices = null,
    Object? extras = null,
  }) {
    return _then(_ConfigOption(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      currentValue: freezed == currentValue ? _self.currentValue : currentValue,
      choices: null == choices
          ? _self._choices
          : choices // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$ConfigState {
  List<ConfigOption> get options;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConfigStateCopyWith<ConfigState> get copyWith =>
      _$ConfigStateCopyWithImpl<ConfigState>(this as ConfigState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConfigState &&
            const DeepCollectionEquality().equals(other.options, options) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(options),
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'ConfigState(options: $options, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $ConfigStateCopyWith<$Res> {
  factory $ConfigStateCopyWith(
          ConfigState value, $Res Function(ConfigState) _then) =
      _$ConfigStateCopyWithImpl;
  @useResult
  $Res call(
      {List<ConfigOption> options,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$ConfigStateCopyWithImpl<$Res> implements $ConfigStateCopyWith<$Res> {
  _$ConfigStateCopyWithImpl(this._self, this._then);

  final ConfigState _self;
  final $Res Function(ConfigState) _then;

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      options: null == options
          ? _self.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<ConfigOption>,
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

/// Adds pattern-matching-related methods to [ConfigState].
extension ConfigStatePatterns on ConfigState {
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
    TResult Function(_ConfigState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfigState() when $default != null:
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
    TResult Function(_ConfigState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigState():
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
    TResult? Function(_ConfigState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigState() when $default != null:
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
    TResult Function(List<ConfigOption> options, Map<String, dynamic>? meta,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ConfigState() when $default != null:
        return $default(_that.options, _that.meta, _that.extras);
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
    TResult Function(List<ConfigOption> options, Map<String, dynamic>? meta,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigState():
        return $default(_that.options, _that.meta, _that.extras);
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
    TResult? Function(List<ConfigOption> options, Map<String, dynamic>? meta,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ConfigState() when $default != null:
        return $default(_that.options, _that.meta, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ConfigState extends ConfigState {
  const _ConfigState(
      {final List<ConfigOption> options = const <ConfigOption>[],
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _options = options,
        _meta = meta,
        _extras = extras,
        super._();

  final List<ConfigOption> _options;
  @override
  @JsonKey()
  List<ConfigOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

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

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ConfigStateCopyWith<_ConfigState> get copyWith =>
      __$ConfigStateCopyWithImpl<_ConfigState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ConfigState &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'ConfigState(options: $options, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$ConfigStateCopyWith<$Res>
    implements $ConfigStateCopyWith<$Res> {
  factory _$ConfigStateCopyWith(
          _ConfigState value, $Res Function(_ConfigState) _then) =
      __$ConfigStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<ConfigOption> options,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$ConfigStateCopyWithImpl<$Res> implements _$ConfigStateCopyWith<$Res> {
  __$ConfigStateCopyWithImpl(this._self, this._then);

  final _ConfigState _self;
  final $Res Function(_ConfigState) _then;

  /// Create a copy of ConfigState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? options = null,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_ConfigState(
      options: null == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<ConfigOption>,
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
mixin _$UsageCost {
  num? get amount;
  String? get currency;
  Map<String, dynamic> get extras;

  /// Create a copy of UsageCost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsageCostCopyWith<UsageCost> get copyWith =>
      _$UsageCostCopyWithImpl<UsageCost>(this as UsageCost, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsageCost &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, currency,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'UsageCost(amount: $amount, currency: $currency, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $UsageCostCopyWith<$Res> {
  factory $UsageCostCopyWith(UsageCost value, $Res Function(UsageCost) _then) =
      _$UsageCostCopyWithImpl;
  @useResult
  $Res call({num? amount, String? currency, Map<String, dynamic> extras});
}

/// @nodoc
class _$UsageCostCopyWithImpl<$Res> implements $UsageCostCopyWith<$Res> {
  _$UsageCostCopyWithImpl(this._self, this._then);

  final UsageCost _self;
  final $Res Function(UsageCost) _then;

  /// Create a copy of UsageCost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? currency = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [UsageCost].
extension UsageCostPatterns on UsageCost {
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
    TResult Function(_UsageCost value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsageCost() when $default != null:
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
    TResult Function(_UsageCost value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageCost():
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
    TResult? Function(_UsageCost value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageCost() when $default != null:
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
            num? amount, String? currency, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsageCost() when $default != null:
        return $default(_that.amount, _that.currency, _that.extras);
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
    TResult Function(num? amount, String? currency, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageCost():
        return $default(_that.amount, _that.currency, _that.extras);
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
            num? amount, String? currency, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageCost() when $default != null:
        return $default(_that.amount, _that.currency, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UsageCost extends UsageCost {
  const _UsageCost(
      {this.amount,
      this.currency,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final num? amount;
  @override
  final String? currency;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of UsageCost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsageCostCopyWith<_UsageCost> get copyWith =>
      __$UsageCostCopyWithImpl<_UsageCost>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsageCost &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, currency,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'UsageCost(amount: $amount, currency: $currency, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$UsageCostCopyWith<$Res>
    implements $UsageCostCopyWith<$Res> {
  factory _$UsageCostCopyWith(
          _UsageCost value, $Res Function(_UsageCost) _then) =
      __$UsageCostCopyWithImpl;
  @override
  @useResult
  $Res call({num? amount, String? currency, Map<String, dynamic> extras});
}

/// @nodoc
class __$UsageCostCopyWithImpl<$Res> implements _$UsageCostCopyWith<$Res> {
  __$UsageCostCopyWithImpl(this._self, this._then);

  final _UsageCost _self;
  final $Res Function(_UsageCost) _then;

  /// Create a copy of UsageCost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amount = freezed,
    Object? currency = freezed,
    Object? extras = null,
  }) {
    return _then(_UsageCost(
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as num?,
      currency: freezed == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$UsageState {
  int? get used;
  int? get size;
  UsageCost? get cost;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of UsageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UsageStateCopyWith<UsageState> get copyWith =>
      _$UsageStateCopyWithImpl<UsageState>(this as UsageState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UsageState &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      used,
      size,
      cost,
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'UsageState(used: $used, size: $size, cost: $cost, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $UsageStateCopyWith<$Res> {
  factory $UsageStateCopyWith(
          UsageState value, $Res Function(UsageState) _then) =
      _$UsageStateCopyWithImpl;
  @useResult
  $Res call(
      {int? used,
      int? size,
      UsageCost? cost,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});

  $UsageCostCopyWith<$Res>? get cost;
}

/// @nodoc
class _$UsageStateCopyWithImpl<$Res> implements $UsageStateCopyWith<$Res> {
  _$UsageStateCopyWithImpl(this._self, this._then);

  final UsageState _self;
  final $Res Function(UsageState) _then;

  /// Create a copy of UsageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? used = freezed,
    Object? size = freezed,
    Object? cost = freezed,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      used: freezed == used
          ? _self.used
          : used // ignore: cast_nullable_to_non_nullable
              as int?,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      cost: freezed == cost
          ? _self.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as UsageCost?,
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

  /// Create a copy of UsageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageCostCopyWith<$Res>? get cost {
    if (_self.cost == null) {
      return null;
    }

    return $UsageCostCopyWith<$Res>(_self.cost!, (value) {
      return _then(_self.copyWith(cost: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UsageState].
extension UsageStatePatterns on UsageState {
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
    TResult Function(_UsageState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsageState() when $default != null:
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
    TResult Function(_UsageState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageState():
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
    TResult? Function(_UsageState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageState() when $default != null:
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
    TResult Function(int? used, int? size, UsageCost? cost,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UsageState() when $default != null:
        return $default(
            _that.used, _that.size, _that.cost, _that.meta, _that.extras);
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
    TResult Function(int? used, int? size, UsageCost? cost,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageState():
        return $default(
            _that.used, _that.size, _that.cost, _that.meta, _that.extras);
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
    TResult? Function(int? used, int? size, UsageCost? cost,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UsageState() when $default != null:
        return $default(
            _that.used, _that.size, _that.cost, _that.meta, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UsageState extends UsageState {
  const _UsageState(
      {this.used,
      this.size,
      this.cost,
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _meta = meta,
        _extras = extras,
        super._();

  @override
  final int? used;
  @override
  final int? size;
  @override
  final UsageCost? cost;
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

  /// Create a copy of UsageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UsageStateCopyWith<_UsageState> get copyWith =>
      __$UsageStateCopyWithImpl<_UsageState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UsageState &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      used,
      size,
      cost,
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'UsageState(used: $used, size: $size, cost: $cost, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$UsageStateCopyWith<$Res>
    implements $UsageStateCopyWith<$Res> {
  factory _$UsageStateCopyWith(
          _UsageState value, $Res Function(_UsageState) _then) =
      __$UsageStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? used,
      int? size,
      UsageCost? cost,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});

  @override
  $UsageCostCopyWith<$Res>? get cost;
}

/// @nodoc
class __$UsageStateCopyWithImpl<$Res> implements _$UsageStateCopyWith<$Res> {
  __$UsageStateCopyWithImpl(this._self, this._then);

  final _UsageState _self;
  final $Res Function(_UsageState) _then;

  /// Create a copy of UsageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? used = freezed,
    Object? size = freezed,
    Object? cost = freezed,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_UsageState(
      used: freezed == used
          ? _self.used
          : used // ignore: cast_nullable_to_non_nullable
              as int?,
      size: freezed == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int?,
      cost: freezed == cost
          ? _self.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as UsageCost?,
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

  /// Create a copy of UsageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UsageCostCopyWith<$Res>? get cost {
    if (_self.cost == null) {
      return null;
    }

    return $UsageCostCopyWith<$Res>(_self.cost!, (value) {
      return _then(_self.copyWith(cost: value));
    });
  }
}

/// @nodoc
mixin _$SessionInfo {
  String? get title;
  String? get updatedAt;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of SessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionInfoCopyWith<SessionInfo> get copyWith =>
      _$SessionInfoCopyWithImpl<SessionInfo>(this as SessionInfo, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionInfo &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      updatedAt,
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'SessionInfo(title: $title, updatedAt: $updatedAt, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $SessionInfoCopyWith<$Res> {
  factory $SessionInfoCopyWith(
          SessionInfo value, $Res Function(SessionInfo) _then) =
      _$SessionInfoCopyWithImpl;
  @useResult
  $Res call(
      {String? title,
      String? updatedAt,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$SessionInfoCopyWithImpl<$Res> implements $SessionInfoCopyWith<$Res> {
  _$SessionInfoCopyWithImpl(this._self, this._then);

  final SessionInfo _self;
  final $Res Function(SessionInfo) _then;

  /// Create a copy of SessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? updatedAt = freezed,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// Adds pattern-matching-related methods to [SessionInfo].
extension SessionInfoPatterns on SessionInfo {
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
    TResult Function(_SessionInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionInfo() when $default != null:
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
    TResult Function(_SessionInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionInfo():
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
    TResult? Function(_SessionInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionInfo() when $default != null:
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
    TResult Function(String? title, String? updatedAt,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionInfo() when $default != null:
        return $default(_that.title, _that.updatedAt, _that.meta, _that.extras);
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
    TResult Function(String? title, String? updatedAt,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionInfo():
        return $default(_that.title, _that.updatedAt, _that.meta, _that.extras);
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
    TResult? Function(String? title, String? updatedAt,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionInfo() when $default != null:
        return $default(_that.title, _that.updatedAt, _that.meta, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SessionInfo extends SessionInfo {
  const _SessionInfo(
      {this.title,
      this.updatedAt,
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _meta = meta,
        _extras = extras,
        super._();

  @override
  final String? title;
  @override
  final String? updatedAt;
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

  /// Create a copy of SessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionInfoCopyWith<_SessionInfo> get copyWith =>
      __$SessionInfoCopyWithImpl<_SessionInfo>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionInfo &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      updatedAt,
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'SessionInfo(title: $title, updatedAt: $updatedAt, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$SessionInfoCopyWith<$Res>
    implements $SessionInfoCopyWith<$Res> {
  factory _$SessionInfoCopyWith(
          _SessionInfo value, $Res Function(_SessionInfo) _then) =
      __$SessionInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? title,
      String? updatedAt,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$SessionInfoCopyWithImpl<$Res> implements _$SessionInfoCopyWith<$Res> {
  __$SessionInfoCopyWithImpl(this._self, this._then);

  final _SessionInfo _self;
  final $Res Function(_SessionInfo) _then;

  /// Create a copy of SessionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = freezed,
    Object? updatedAt = freezed,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_SessionInfo(
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
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
mixin _$PlanEntry {
  String? get content;
  String? get priority;
  String? get status;
  Map<String, dynamic> get extras;

  /// Create a copy of PlanEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlanEntryCopyWith<PlanEntry> get copyWith =>
      _$PlanEntryCopyWithImpl<PlanEntry>(this as PlanEntry, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlanEntry &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, content, priority, status,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'PlanEntry(content: $content, priority: $priority, status: $status, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $PlanEntryCopyWith<$Res> {
  factory $PlanEntryCopyWith(PlanEntry value, $Res Function(PlanEntry) _then) =
      _$PlanEntryCopyWithImpl;
  @useResult
  $Res call(
      {String? content,
      String? priority,
      String? status,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$PlanEntryCopyWithImpl<$Res> implements $PlanEntryCopyWith<$Res> {
  _$PlanEntryCopyWithImpl(this._self, this._then);

  final PlanEntry _self;
  final $Res Function(PlanEntry) _then;

  /// Create a copy of PlanEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = freezed,
    Object? priority = freezed,
    Object? status = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [PlanEntry].
extension PlanEntryPatterns on PlanEntry {
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
    TResult Function(_PlanEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlanEntry() when $default != null:
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
    TResult Function(_PlanEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanEntry():
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
    TResult? Function(_PlanEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanEntry() when $default != null:
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
    TResult Function(String? content, String? priority, String? status,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlanEntry() when $default != null:
        return $default(
            _that.content, _that.priority, _that.status, _that.extras);
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
    TResult Function(String? content, String? priority, String? status,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanEntry():
        return $default(
            _that.content, _that.priority, _that.status, _that.extras);
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
    TResult? Function(String? content, String? priority, String? status,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanEntry() when $default != null:
        return $default(
            _that.content, _that.priority, _that.status, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PlanEntry extends PlanEntry {
  const _PlanEntry(
      {this.content,
      this.priority,
      this.status,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _extras = extras,
        super._();

  @override
  final String? content;
  @override
  final String? priority;
  @override
  final String? status;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of PlanEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlanEntryCopyWith<_PlanEntry> get copyWith =>
      __$PlanEntryCopyWithImpl<_PlanEntry>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlanEntry &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(runtimeType, content, priority, status,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'PlanEntry(content: $content, priority: $priority, status: $status, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$PlanEntryCopyWith<$Res>
    implements $PlanEntryCopyWith<$Res> {
  factory _$PlanEntryCopyWith(
          _PlanEntry value, $Res Function(_PlanEntry) _then) =
      __$PlanEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? content,
      String? priority,
      String? status,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$PlanEntryCopyWithImpl<$Res> implements _$PlanEntryCopyWith<$Res> {
  __$PlanEntryCopyWithImpl(this._self, this._then);

  final _PlanEntry _self;
  final $Res Function(_PlanEntry) _then;

  /// Create a copy of PlanEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? content = freezed,
    Object? priority = freezed,
    Object? status = freezed,
    Object? extras = null,
  }) {
    return _then(_PlanEntry(
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: freezed == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
mixin _$PlanState {
  List<PlanEntry>? get entries;
  String? get uri;
  String? get markdown;
  Map<String, dynamic>? get meta;
  Map<String, dynamic> get extras;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlanStateCopyWith<PlanState> get copyWith =>
      _$PlanStateCopyWithImpl<PlanState>(this as PlanState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlanState &&
            const DeepCollectionEquality().equals(other.entries, entries) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.markdown, markdown) ||
                other.markdown == markdown) &&
            const DeepCollectionEquality().equals(other.meta, meta) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(entries),
      uri,
      markdown,
      const DeepCollectionEquality().hash(meta),
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'PlanState(entries: $entries, uri: $uri, markdown: $markdown, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $PlanStateCopyWith<$Res> {
  factory $PlanStateCopyWith(PlanState value, $Res Function(PlanState) _then) =
      _$PlanStateCopyWithImpl;
  @useResult
  $Res call(
      {List<PlanEntry>? entries,
      String? uri,
      String? markdown,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class _$PlanStateCopyWithImpl<$Res> implements $PlanStateCopyWith<$Res> {
  _$PlanStateCopyWithImpl(this._self, this._then);

  final PlanState _self;
  final $Res Function(PlanState) _then;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = freezed,
    Object? uri = freezed,
    Object? markdown = freezed,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      entries: freezed == entries
          ? _self.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<PlanEntry>?,
      uri: freezed == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String?,
      markdown: freezed == markdown
          ? _self.markdown
          : markdown // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// Adds pattern-matching-related methods to [PlanState].
extension PlanStatePatterns on PlanState {
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
    TResult Function(_PlanState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlanState() when $default != null:
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
    TResult Function(_PlanState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanState():
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
    TResult? Function(_PlanState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanState() when $default != null:
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
    TResult Function(List<PlanEntry>? entries, String? uri, String? markdown,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlanState() when $default != null:
        return $default(
            _that.entries, _that.uri, _that.markdown, _that.meta, _that.extras);
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
    TResult Function(List<PlanEntry>? entries, String? uri, String? markdown,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanState():
        return $default(
            _that.entries, _that.uri, _that.markdown, _that.meta, _that.extras);
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
    TResult? Function(List<PlanEntry>? entries, String? uri, String? markdown,
            Map<String, dynamic>? meta, Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlanState() when $default != null:
        return $default(
            _that.entries, _that.uri, _that.markdown, _that.meta, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PlanState extends PlanState {
  const _PlanState(
      {final List<PlanEntry>? entries,
      this.uri,
      this.markdown,
      final Map<String, dynamic>? meta,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _entries = entries,
        _meta = meta,
        _extras = extras,
        super._();

  final List<PlanEntry>? _entries;
  @override
  List<PlanEntry>? get entries {
    final value = _entries;
    if (value == null) return null;
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? uri;
  @override
  final String? markdown;
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

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlanStateCopyWith<_PlanState> get copyWith =>
      __$PlanStateCopyWithImpl<_PlanState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlanState &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.markdown, markdown) ||
                other.markdown == markdown) &&
            const DeepCollectionEquality().equals(other._meta, _meta) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      uri,
      markdown,
      const DeepCollectionEquality().hash(_meta),
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'PlanState(entries: $entries, uri: $uri, markdown: $markdown, meta: $meta, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$PlanStateCopyWith<$Res>
    implements $PlanStateCopyWith<$Res> {
  factory _$PlanStateCopyWith(
          _PlanState value, $Res Function(_PlanState) _then) =
      __$PlanStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<PlanEntry>? entries,
      String? uri,
      String? markdown,
      Map<String, dynamic>? meta,
      Map<String, dynamic> extras});
}

/// @nodoc
class __$PlanStateCopyWithImpl<$Res> implements _$PlanStateCopyWith<$Res> {
  __$PlanStateCopyWithImpl(this._self, this._then);

  final _PlanState _self;
  final $Res Function(_PlanState) _then;

  /// Create a copy of PlanState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? entries = freezed,
    Object? uri = freezed,
    Object? markdown = freezed,
    Object? meta = freezed,
    Object? extras = null,
  }) {
    return _then(_PlanState(
      entries: freezed == entries
          ? _self._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<PlanEntry>?,
      uri: freezed == uri
          ? _self.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String?,
      markdown: freezed == markdown
          ? _self.markdown
          : markdown // ignore: cast_nullable_to_non_nullable
              as String?,
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
mixin _$PlansState {
  Map<String, PlanState> get byId;
  PlanState? get legacy;
  Map<String, dynamic> get extras;

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlansStateCopyWith<PlansState> get copyWith =>
      _$PlansStateCopyWithImpl<PlansState>(this as PlansState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlansState &&
            const DeepCollectionEquality().equals(other.byId, byId) &&
            (identical(other.legacy, legacy) || other.legacy == legacy) &&
            const DeepCollectionEquality().equals(other.extras, extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(byId),
      legacy,
      const DeepCollectionEquality().hash(extras));

  @override
  String toString() {
    return 'PlansState(byId: $byId, legacy: $legacy, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class $PlansStateCopyWith<$Res> {
  factory $PlansStateCopyWith(
          PlansState value, $Res Function(PlansState) _then) =
      _$PlansStateCopyWithImpl;
  @useResult
  $Res call(
      {Map<String, PlanState> byId,
      PlanState? legacy,
      Map<String, dynamic> extras});

  $PlanStateCopyWith<$Res>? get legacy;
}

/// @nodoc
class _$PlansStateCopyWithImpl<$Res> implements $PlansStateCopyWith<$Res> {
  _$PlansStateCopyWithImpl(this._self, this._then);

  final PlansState _self;
  final $Res Function(PlansState) _then;

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? byId = null,
    Object? legacy = freezed,
    Object? extras = null,
  }) {
    return _then(_self.copyWith(
      byId: null == byId
          ? _self.byId
          : byId // ignore: cast_nullable_to_non_nullable
              as Map<String, PlanState>,
      legacy: freezed == legacy
          ? _self.legacy
          : legacy // ignore: cast_nullable_to_non_nullable
              as PlanState?,
      extras: null == extras
          ? _self.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlanStateCopyWith<$Res>? get legacy {
    if (_self.legacy == null) {
      return null;
    }

    return $PlanStateCopyWith<$Res>(_self.legacy!, (value) {
      return _then(_self.copyWith(legacy: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PlansState].
extension PlansStatePatterns on PlansState {
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
    TResult Function(_PlansState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlansState() when $default != null:
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
    TResult Function(_PlansState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlansState():
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
    TResult? Function(_PlansState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlansState() when $default != null:
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
    TResult Function(Map<String, PlanState> byId, PlanState? legacy,
            Map<String, dynamic> extras)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PlansState() when $default != null:
        return $default(_that.byId, _that.legacy, _that.extras);
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
    TResult Function(Map<String, PlanState> byId, PlanState? legacy,
            Map<String, dynamic> extras)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlansState():
        return $default(_that.byId, _that.legacy, _that.extras);
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
    TResult? Function(Map<String, PlanState> byId, PlanState? legacy,
            Map<String, dynamic> extras)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PlansState() when $default != null:
        return $default(_that.byId, _that.legacy, _that.extras);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PlansState extends PlansState {
  const _PlansState(
      {final Map<String, PlanState> byId = const <String, PlanState>{},
      this.legacy,
      final Map<String, dynamic> extras = const <String, dynamic>{}})
      : _byId = byId,
        _extras = extras,
        super._();

  final Map<String, PlanState> _byId;
  @override
  @JsonKey()
  Map<String, PlanState> get byId {
    if (_byId is EqualUnmodifiableMapView) return _byId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_byId);
  }

  @override
  final PlanState? legacy;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PlansStateCopyWith<_PlansState> get copyWith =>
      __$PlansStateCopyWithImpl<_PlansState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PlansState &&
            const DeepCollectionEquality().equals(other._byId, _byId) &&
            (identical(other.legacy, legacy) || other.legacy == legacy) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_byId),
      legacy,
      const DeepCollectionEquality().hash(_extras));

  @override
  String toString() {
    return 'PlansState(byId: $byId, legacy: $legacy, extras: $extras)';
  }
}

/// @nodoc
abstract mixin class _$PlansStateCopyWith<$Res>
    implements $PlansStateCopyWith<$Res> {
  factory _$PlansStateCopyWith(
          _PlansState value, $Res Function(_PlansState) _then) =
      __$PlansStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Map<String, PlanState> byId,
      PlanState? legacy,
      Map<String, dynamic> extras});

  @override
  $PlanStateCopyWith<$Res>? get legacy;
}

/// @nodoc
class __$PlansStateCopyWithImpl<$Res> implements _$PlansStateCopyWith<$Res> {
  __$PlansStateCopyWithImpl(this._self, this._then);

  final _PlansState _self;
  final $Res Function(_PlansState) _then;

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? byId = null,
    Object? legacy = freezed,
    Object? extras = null,
  }) {
    return _then(_PlansState(
      byId: null == byId
          ? _self._byId
          : byId // ignore: cast_nullable_to_non_nullable
              as Map<String, PlanState>,
      legacy: freezed == legacy
          ? _self.legacy
          : legacy // ignore: cast_nullable_to_non_nullable
              as PlanState?,
      extras: null == extras
          ? _self._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }

  /// Create a copy of PlansState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlanStateCopyWith<$Res>? get legacy {
    if (_self.legacy == null) {
      return null;
    }

    return $PlanStateCopyWith<$Res>(_self.legacy!, (value) {
      return _then(_self.copyWith(legacy: value));
    });
  }
}

// dart format on
