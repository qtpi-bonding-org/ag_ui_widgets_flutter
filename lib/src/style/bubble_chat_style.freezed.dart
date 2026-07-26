// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bubble_chat_style.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BubbleChatStyle {
  Color get sentBackground;
  Color get receivedBackground;
  Color? get sentBorder;
  Color? get receivedBorder;
  TextStyle get textStyle;
  double get maxWidth;
  BorderRadius get sentRadius;
  BorderRadius get receivedRadius;
  EdgeInsets get padding;
  MarkdownStyleSheet Function(BuildContext)? get markdownStyleSheetBuilder;

  /// Create a copy of BubbleChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BubbleChatStyleCopyWith<BubbleChatStyle> get copyWith =>
      _$BubbleChatStyleCopyWithImpl<BubbleChatStyle>(
          this as BubbleChatStyle, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BubbleChatStyle &&
            (identical(other.sentBackground, sentBackground) ||
                other.sentBackground == sentBackground) &&
            (identical(other.receivedBackground, receivedBackground) ||
                other.receivedBackground == receivedBackground) &&
            (identical(other.sentBorder, sentBorder) ||
                other.sentBorder == sentBorder) &&
            (identical(other.receivedBorder, receivedBorder) ||
                other.receivedBorder == receivedBorder) &&
            (identical(other.textStyle, textStyle) ||
                other.textStyle == textStyle) &&
            (identical(other.maxWidth, maxWidth) ||
                other.maxWidth == maxWidth) &&
            (identical(other.sentRadius, sentRadius) ||
                other.sentRadius == sentRadius) &&
            (identical(other.receivedRadius, receivedRadius) ||
                other.receivedRadius == receivedRadius) &&
            (identical(other.padding, padding) || other.padding == padding) &&
            (identical(other.markdownStyleSheetBuilder,
                    markdownStyleSheetBuilder) ||
                other.markdownStyleSheetBuilder == markdownStyleSheetBuilder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sentBackground,
      receivedBackground,
      sentBorder,
      receivedBorder,
      textStyle,
      maxWidth,
      sentRadius,
      receivedRadius,
      padding,
      markdownStyleSheetBuilder);

  @override
  String toString() {
    return 'BubbleChatStyle(sentBackground: $sentBackground, receivedBackground: $receivedBackground, sentBorder: $sentBorder, receivedBorder: $receivedBorder, textStyle: $textStyle, maxWidth: $maxWidth, sentRadius: $sentRadius, receivedRadius: $receivedRadius, padding: $padding, markdownStyleSheetBuilder: $markdownStyleSheetBuilder)';
  }
}

/// @nodoc
abstract mixin class $BubbleChatStyleCopyWith<$Res> {
  factory $BubbleChatStyleCopyWith(
          BubbleChatStyle value, $Res Function(BubbleChatStyle) _then) =
      _$BubbleChatStyleCopyWithImpl;
  @useResult
  $Res call(
      {Color sentBackground,
      Color receivedBackground,
      Color? sentBorder,
      Color? receivedBorder,
      TextStyle textStyle,
      double maxWidth,
      BorderRadius sentRadius,
      BorderRadius receivedRadius,
      EdgeInsets padding,
      MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder});
}

/// @nodoc
class _$BubbleChatStyleCopyWithImpl<$Res>
    implements $BubbleChatStyleCopyWith<$Res> {
  _$BubbleChatStyleCopyWithImpl(this._self, this._then);

  final BubbleChatStyle _self;
  final $Res Function(BubbleChatStyle) _then;

  /// Create a copy of BubbleChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentBackground = null,
    Object? receivedBackground = null,
    Object? sentBorder = freezed,
    Object? receivedBorder = freezed,
    Object? textStyle = null,
    Object? maxWidth = null,
    Object? sentRadius = null,
    Object? receivedRadius = null,
    Object? padding = null,
    Object? markdownStyleSheetBuilder = freezed,
  }) {
    return _then(_self.copyWith(
      sentBackground: null == sentBackground
          ? _self.sentBackground
          : sentBackground // ignore: cast_nullable_to_non_nullable
              as Color,
      receivedBackground: null == receivedBackground
          ? _self.receivedBackground
          : receivedBackground // ignore: cast_nullable_to_non_nullable
              as Color,
      sentBorder: freezed == sentBorder
          ? _self.sentBorder
          : sentBorder // ignore: cast_nullable_to_non_nullable
              as Color?,
      receivedBorder: freezed == receivedBorder
          ? _self.receivedBorder
          : receivedBorder // ignore: cast_nullable_to_non_nullable
              as Color?,
      textStyle: null == textStyle
          ? _self.textStyle
          : textStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      maxWidth: null == maxWidth
          ? _self.maxWidth
          : maxWidth // ignore: cast_nullable_to_non_nullable
              as double,
      sentRadius: null == sentRadius
          ? _self.sentRadius
          : sentRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
      receivedRadius: null == receivedRadius
          ? _self.receivedRadius
          : receivedRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
      padding: null == padding
          ? _self.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      markdownStyleSheetBuilder: freezed == markdownStyleSheetBuilder
          ? _self.markdownStyleSheetBuilder
          : markdownStyleSheetBuilder // ignore: cast_nullable_to_non_nullable
              as MarkdownStyleSheet Function(BuildContext)?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BubbleChatStyle].
extension BubbleChatStylePatterns on BubbleChatStyle {
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
    TResult Function(_BubbleChatStyle value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BubbleChatStyle() when $default != null:
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
    TResult Function(_BubbleChatStyle value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BubbleChatStyle():
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
    TResult? Function(_BubbleChatStyle value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BubbleChatStyle() when $default != null:
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
            Color sentBackground,
            Color receivedBackground,
            Color? sentBorder,
            Color? receivedBorder,
            TextStyle textStyle,
            double maxWidth,
            BorderRadius sentRadius,
            BorderRadius receivedRadius,
            EdgeInsets padding,
            MarkdownStyleSheet Function(BuildContext)?
                markdownStyleSheetBuilder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BubbleChatStyle() when $default != null:
        return $default(
            _that.sentBackground,
            _that.receivedBackground,
            _that.sentBorder,
            _that.receivedBorder,
            _that.textStyle,
            _that.maxWidth,
            _that.sentRadius,
            _that.receivedRadius,
            _that.padding,
            _that.markdownStyleSheetBuilder);
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
            Color sentBackground,
            Color receivedBackground,
            Color? sentBorder,
            Color? receivedBorder,
            TextStyle textStyle,
            double maxWidth,
            BorderRadius sentRadius,
            BorderRadius receivedRadius,
            EdgeInsets padding,
            MarkdownStyleSheet Function(BuildContext)?
                markdownStyleSheetBuilder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BubbleChatStyle():
        return $default(
            _that.sentBackground,
            _that.receivedBackground,
            _that.sentBorder,
            _that.receivedBorder,
            _that.textStyle,
            _that.maxWidth,
            _that.sentRadius,
            _that.receivedRadius,
            _that.padding,
            _that.markdownStyleSheetBuilder);
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
            Color sentBackground,
            Color receivedBackground,
            Color? sentBorder,
            Color? receivedBorder,
            TextStyle textStyle,
            double maxWidth,
            BorderRadius sentRadius,
            BorderRadius receivedRadius,
            EdgeInsets padding,
            MarkdownStyleSheet Function(BuildContext)?
                markdownStyleSheetBuilder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BubbleChatStyle() when $default != null:
        return $default(
            _that.sentBackground,
            _that.receivedBackground,
            _that.sentBorder,
            _that.receivedBorder,
            _that.textStyle,
            _that.maxWidth,
            _that.sentRadius,
            _that.receivedRadius,
            _that.padding,
            _that.markdownStyleSheetBuilder);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BubbleChatStyle implements BubbleChatStyle {
  const _BubbleChatStyle(
      {required this.sentBackground,
      required this.receivedBackground,
      this.sentBorder,
      this.receivedBorder,
      required this.textStyle,
      required this.maxWidth,
      this.sentRadius = const BorderRadius.all(Radius.circular(12)),
      this.receivedRadius = const BorderRadius.all(Radius.circular(12)),
      this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      this.markdownStyleSheetBuilder});

  @override
  final Color sentBackground;
  @override
  final Color receivedBackground;
  @override
  final Color? sentBorder;
  @override
  final Color? receivedBorder;
  @override
  final TextStyle textStyle;
  @override
  final double maxWidth;
  @override
  @JsonKey()
  final BorderRadius sentRadius;
  @override
  @JsonKey()
  final BorderRadius receivedRadius;
  @override
  @JsonKey()
  final EdgeInsets padding;
  @override
  final MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder;

  /// Create a copy of BubbleChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BubbleChatStyleCopyWith<_BubbleChatStyle> get copyWith =>
      __$BubbleChatStyleCopyWithImpl<_BubbleChatStyle>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BubbleChatStyle &&
            (identical(other.sentBackground, sentBackground) ||
                other.sentBackground == sentBackground) &&
            (identical(other.receivedBackground, receivedBackground) ||
                other.receivedBackground == receivedBackground) &&
            (identical(other.sentBorder, sentBorder) ||
                other.sentBorder == sentBorder) &&
            (identical(other.receivedBorder, receivedBorder) ||
                other.receivedBorder == receivedBorder) &&
            (identical(other.textStyle, textStyle) ||
                other.textStyle == textStyle) &&
            (identical(other.maxWidth, maxWidth) ||
                other.maxWidth == maxWidth) &&
            (identical(other.sentRadius, sentRadius) ||
                other.sentRadius == sentRadius) &&
            (identical(other.receivedRadius, receivedRadius) ||
                other.receivedRadius == receivedRadius) &&
            (identical(other.padding, padding) || other.padding == padding) &&
            (identical(other.markdownStyleSheetBuilder,
                    markdownStyleSheetBuilder) ||
                other.markdownStyleSheetBuilder == markdownStyleSheetBuilder));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sentBackground,
      receivedBackground,
      sentBorder,
      receivedBorder,
      textStyle,
      maxWidth,
      sentRadius,
      receivedRadius,
      padding,
      markdownStyleSheetBuilder);

  @override
  String toString() {
    return 'BubbleChatStyle(sentBackground: $sentBackground, receivedBackground: $receivedBackground, sentBorder: $sentBorder, receivedBorder: $receivedBorder, textStyle: $textStyle, maxWidth: $maxWidth, sentRadius: $sentRadius, receivedRadius: $receivedRadius, padding: $padding, markdownStyleSheetBuilder: $markdownStyleSheetBuilder)';
  }
}

/// @nodoc
abstract mixin class _$BubbleChatStyleCopyWith<$Res>
    implements $BubbleChatStyleCopyWith<$Res> {
  factory _$BubbleChatStyleCopyWith(
          _BubbleChatStyle value, $Res Function(_BubbleChatStyle) _then) =
      __$BubbleChatStyleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Color sentBackground,
      Color receivedBackground,
      Color? sentBorder,
      Color? receivedBorder,
      TextStyle textStyle,
      double maxWidth,
      BorderRadius sentRadius,
      BorderRadius receivedRadius,
      EdgeInsets padding,
      MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder});
}

/// @nodoc
class __$BubbleChatStyleCopyWithImpl<$Res>
    implements _$BubbleChatStyleCopyWith<$Res> {
  __$BubbleChatStyleCopyWithImpl(this._self, this._then);

  final _BubbleChatStyle _self;
  final $Res Function(_BubbleChatStyle) _then;

  /// Create a copy of BubbleChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sentBackground = null,
    Object? receivedBackground = null,
    Object? sentBorder = freezed,
    Object? receivedBorder = freezed,
    Object? textStyle = null,
    Object? maxWidth = null,
    Object? sentRadius = null,
    Object? receivedRadius = null,
    Object? padding = null,
    Object? markdownStyleSheetBuilder = freezed,
  }) {
    return _then(_BubbleChatStyle(
      sentBackground: null == sentBackground
          ? _self.sentBackground
          : sentBackground // ignore: cast_nullable_to_non_nullable
              as Color,
      receivedBackground: null == receivedBackground
          ? _self.receivedBackground
          : receivedBackground // ignore: cast_nullable_to_non_nullable
              as Color,
      sentBorder: freezed == sentBorder
          ? _self.sentBorder
          : sentBorder // ignore: cast_nullable_to_non_nullable
              as Color?,
      receivedBorder: freezed == receivedBorder
          ? _self.receivedBorder
          : receivedBorder // ignore: cast_nullable_to_non_nullable
              as Color?,
      textStyle: null == textStyle
          ? _self.textStyle
          : textStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      maxWidth: null == maxWidth
          ? _self.maxWidth
          : maxWidth // ignore: cast_nullable_to_non_nullable
              as double,
      sentRadius: null == sentRadius
          ? _self.sentRadius
          : sentRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
      receivedRadius: null == receivedRadius
          ? _self.receivedRadius
          : receivedRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
      padding: null == padding
          ? _self.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      markdownStyleSheetBuilder: freezed == markdownStyleSheetBuilder
          ? _self.markdownStyleSheetBuilder
          : markdownStyleSheetBuilder // ignore: cast_nullable_to_non_nullable
              as MarkdownStyleSheet Function(BuildContext)?,
    ));
  }
}

// dart format on
