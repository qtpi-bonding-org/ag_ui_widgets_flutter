// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stacked_chat_style.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StackedChatStyle {
  Color get sentBackground;
  Color get receivedBackground;
  TextStyle get textStyle;
  Widget Function(BuildContext)? get aiLeadingIconBuilder;
  EdgeInsets get padding;
  Color? get cardBorderColor;
  BorderRadius get cardRadius;
  Color get diffAddedColor;
  Color get diffRemovedColor;
  MarkdownStyleSheet Function(BuildContext)? get markdownStyleSheetBuilder;
  TextStyle? get reasoningTextStyle;

  /// Create a copy of StackedChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StackedChatStyleCopyWith<StackedChatStyle> get copyWith =>
      _$StackedChatStyleCopyWithImpl<StackedChatStyle>(
          this as StackedChatStyle, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is StackedChatStyle &&
            (identical(other.sentBackground, sentBackground) ||
                other.sentBackground == sentBackground) &&
            (identical(other.receivedBackground, receivedBackground) ||
                other.receivedBackground == receivedBackground) &&
            (identical(other.textStyle, textStyle) ||
                other.textStyle == textStyle) &&
            (identical(other.aiLeadingIconBuilder, aiLeadingIconBuilder) ||
                other.aiLeadingIconBuilder == aiLeadingIconBuilder) &&
            (identical(other.padding, padding) || other.padding == padding) &&
            (identical(other.cardBorderColor, cardBorderColor) ||
                other.cardBorderColor == cardBorderColor) &&
            (identical(other.cardRadius, cardRadius) ||
                other.cardRadius == cardRadius) &&
            (identical(other.diffAddedColor, diffAddedColor) ||
                other.diffAddedColor == diffAddedColor) &&
            (identical(other.diffRemovedColor, diffRemovedColor) ||
                other.diffRemovedColor == diffRemovedColor) &&
            (identical(other.markdownStyleSheetBuilder,
                    markdownStyleSheetBuilder) ||
                other.markdownStyleSheetBuilder == markdownStyleSheetBuilder) &&
            (identical(other.reasoningTextStyle, reasoningTextStyle) ||
                other.reasoningTextStyle == reasoningTextStyle));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sentBackground,
      receivedBackground,
      textStyle,
      aiLeadingIconBuilder,
      padding,
      cardBorderColor,
      cardRadius,
      diffAddedColor,
      diffRemovedColor,
      markdownStyleSheetBuilder,
      reasoningTextStyle);

  @override
  String toString() {
    return 'StackedChatStyle(sentBackground: $sentBackground, receivedBackground: $receivedBackground, textStyle: $textStyle, aiLeadingIconBuilder: $aiLeadingIconBuilder, padding: $padding, cardBorderColor: $cardBorderColor, cardRadius: $cardRadius, diffAddedColor: $diffAddedColor, diffRemovedColor: $diffRemovedColor, markdownStyleSheetBuilder: $markdownStyleSheetBuilder, reasoningTextStyle: $reasoningTextStyle)';
  }
}

/// @nodoc
abstract mixin class $StackedChatStyleCopyWith<$Res> {
  factory $StackedChatStyleCopyWith(
          StackedChatStyle value, $Res Function(StackedChatStyle) _then) =
      _$StackedChatStyleCopyWithImpl;
  @useResult
  $Res call(
      {Color sentBackground,
      Color receivedBackground,
      TextStyle textStyle,
      Widget Function(BuildContext)? aiLeadingIconBuilder,
      EdgeInsets padding,
      Color? cardBorderColor,
      BorderRadius cardRadius,
      Color diffAddedColor,
      Color diffRemovedColor,
      MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder,
      TextStyle? reasoningTextStyle});
}

/// @nodoc
class _$StackedChatStyleCopyWithImpl<$Res>
    implements $StackedChatStyleCopyWith<$Res> {
  _$StackedChatStyleCopyWithImpl(this._self, this._then);

  final StackedChatStyle _self;
  final $Res Function(StackedChatStyle) _then;

  /// Create a copy of StackedChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentBackground = null,
    Object? receivedBackground = null,
    Object? textStyle = null,
    Object? aiLeadingIconBuilder = freezed,
    Object? padding = null,
    Object? cardBorderColor = freezed,
    Object? cardRadius = null,
    Object? diffAddedColor = null,
    Object? diffRemovedColor = null,
    Object? markdownStyleSheetBuilder = freezed,
    Object? reasoningTextStyle = freezed,
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
      textStyle: null == textStyle
          ? _self.textStyle
          : textStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      aiLeadingIconBuilder: freezed == aiLeadingIconBuilder
          ? _self.aiLeadingIconBuilder
          : aiLeadingIconBuilder // ignore: cast_nullable_to_non_nullable
              as Widget Function(BuildContext)?,
      padding: null == padding
          ? _self.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      cardBorderColor: freezed == cardBorderColor
          ? _self.cardBorderColor
          : cardBorderColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      cardRadius: null == cardRadius
          ? _self.cardRadius
          : cardRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
      diffAddedColor: null == diffAddedColor
          ? _self.diffAddedColor
          : diffAddedColor // ignore: cast_nullable_to_non_nullable
              as Color,
      diffRemovedColor: null == diffRemovedColor
          ? _self.diffRemovedColor
          : diffRemovedColor // ignore: cast_nullable_to_non_nullable
              as Color,
      markdownStyleSheetBuilder: freezed == markdownStyleSheetBuilder
          ? _self.markdownStyleSheetBuilder
          : markdownStyleSheetBuilder // ignore: cast_nullable_to_non_nullable
              as MarkdownStyleSheet Function(BuildContext)?,
      reasoningTextStyle: freezed == reasoningTextStyle
          ? _self.reasoningTextStyle
          : reasoningTextStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
    ));
  }
}

/// Adds pattern-matching-related methods to [StackedChatStyle].
extension StackedChatStylePatterns on StackedChatStyle {
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
    TResult Function(_StackedChatStyle value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StackedChatStyle() when $default != null:
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
    TResult Function(_StackedChatStyle value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StackedChatStyle():
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
    TResult? Function(_StackedChatStyle value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StackedChatStyle() when $default != null:
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
            TextStyle textStyle,
            Widget Function(BuildContext)? aiLeadingIconBuilder,
            EdgeInsets padding,
            Color? cardBorderColor,
            BorderRadius cardRadius,
            Color diffAddedColor,
            Color diffRemovedColor,
            MarkdownStyleSheet Function(BuildContext)?
                markdownStyleSheetBuilder,
            TextStyle? reasoningTextStyle)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _StackedChatStyle() when $default != null:
        return $default(
            _that.sentBackground,
            _that.receivedBackground,
            _that.textStyle,
            _that.aiLeadingIconBuilder,
            _that.padding,
            _that.cardBorderColor,
            _that.cardRadius,
            _that.diffAddedColor,
            _that.diffRemovedColor,
            _that.markdownStyleSheetBuilder,
            _that.reasoningTextStyle);
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
            TextStyle textStyle,
            Widget Function(BuildContext)? aiLeadingIconBuilder,
            EdgeInsets padding,
            Color? cardBorderColor,
            BorderRadius cardRadius,
            Color diffAddedColor,
            Color diffRemovedColor,
            MarkdownStyleSheet Function(BuildContext)?
                markdownStyleSheetBuilder,
            TextStyle? reasoningTextStyle)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StackedChatStyle():
        return $default(
            _that.sentBackground,
            _that.receivedBackground,
            _that.textStyle,
            _that.aiLeadingIconBuilder,
            _that.padding,
            _that.cardBorderColor,
            _that.cardRadius,
            _that.diffAddedColor,
            _that.diffRemovedColor,
            _that.markdownStyleSheetBuilder,
            _that.reasoningTextStyle);
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
            TextStyle textStyle,
            Widget Function(BuildContext)? aiLeadingIconBuilder,
            EdgeInsets padding,
            Color? cardBorderColor,
            BorderRadius cardRadius,
            Color diffAddedColor,
            Color diffRemovedColor,
            MarkdownStyleSheet Function(BuildContext)?
                markdownStyleSheetBuilder,
            TextStyle? reasoningTextStyle)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _StackedChatStyle() when $default != null:
        return $default(
            _that.sentBackground,
            _that.receivedBackground,
            _that.textStyle,
            _that.aiLeadingIconBuilder,
            _that.padding,
            _that.cardBorderColor,
            _that.cardRadius,
            _that.diffAddedColor,
            _that.diffRemovedColor,
            _that.markdownStyleSheetBuilder,
            _that.reasoningTextStyle);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _StackedChatStyle implements StackedChatStyle {
  const _StackedChatStyle(
      {required this.sentBackground,
      required this.receivedBackground,
      required this.textStyle,
      this.aiLeadingIconBuilder,
      this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      this.cardBorderColor,
      this.cardRadius = const BorderRadius.all(Radius.circular(8)),
      this.diffAddedColor = const Color(0xFF2E7D32),
      this.diffRemovedColor = const Color(0xFFC62828),
      this.markdownStyleSheetBuilder,
      this.reasoningTextStyle});

  @override
  final Color sentBackground;
  @override
  final Color receivedBackground;
  @override
  final TextStyle textStyle;
  @override
  final Widget Function(BuildContext)? aiLeadingIconBuilder;
  @override
  @JsonKey()
  final EdgeInsets padding;
  @override
  final Color? cardBorderColor;
  @override
  @JsonKey()
  final BorderRadius cardRadius;
  @override
  @JsonKey()
  final Color diffAddedColor;
  @override
  @JsonKey()
  final Color diffRemovedColor;
  @override
  final MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder;
  @override
  final TextStyle? reasoningTextStyle;

  /// Create a copy of StackedChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StackedChatStyleCopyWith<_StackedChatStyle> get copyWith =>
      __$StackedChatStyleCopyWithImpl<_StackedChatStyle>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _StackedChatStyle &&
            (identical(other.sentBackground, sentBackground) ||
                other.sentBackground == sentBackground) &&
            (identical(other.receivedBackground, receivedBackground) ||
                other.receivedBackground == receivedBackground) &&
            (identical(other.textStyle, textStyle) ||
                other.textStyle == textStyle) &&
            (identical(other.aiLeadingIconBuilder, aiLeadingIconBuilder) ||
                other.aiLeadingIconBuilder == aiLeadingIconBuilder) &&
            (identical(other.padding, padding) || other.padding == padding) &&
            (identical(other.cardBorderColor, cardBorderColor) ||
                other.cardBorderColor == cardBorderColor) &&
            (identical(other.cardRadius, cardRadius) ||
                other.cardRadius == cardRadius) &&
            (identical(other.diffAddedColor, diffAddedColor) ||
                other.diffAddedColor == diffAddedColor) &&
            (identical(other.diffRemovedColor, diffRemovedColor) ||
                other.diffRemovedColor == diffRemovedColor) &&
            (identical(other.markdownStyleSheetBuilder,
                    markdownStyleSheetBuilder) ||
                other.markdownStyleSheetBuilder == markdownStyleSheetBuilder) &&
            (identical(other.reasoningTextStyle, reasoningTextStyle) ||
                other.reasoningTextStyle == reasoningTextStyle));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      sentBackground,
      receivedBackground,
      textStyle,
      aiLeadingIconBuilder,
      padding,
      cardBorderColor,
      cardRadius,
      diffAddedColor,
      diffRemovedColor,
      markdownStyleSheetBuilder,
      reasoningTextStyle);

  @override
  String toString() {
    return 'StackedChatStyle(sentBackground: $sentBackground, receivedBackground: $receivedBackground, textStyle: $textStyle, aiLeadingIconBuilder: $aiLeadingIconBuilder, padding: $padding, cardBorderColor: $cardBorderColor, cardRadius: $cardRadius, diffAddedColor: $diffAddedColor, diffRemovedColor: $diffRemovedColor, markdownStyleSheetBuilder: $markdownStyleSheetBuilder, reasoningTextStyle: $reasoningTextStyle)';
  }
}

/// @nodoc
abstract mixin class _$StackedChatStyleCopyWith<$Res>
    implements $StackedChatStyleCopyWith<$Res> {
  factory _$StackedChatStyleCopyWith(
          _StackedChatStyle value, $Res Function(_StackedChatStyle) _then) =
      __$StackedChatStyleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Color sentBackground,
      Color receivedBackground,
      TextStyle textStyle,
      Widget Function(BuildContext)? aiLeadingIconBuilder,
      EdgeInsets padding,
      Color? cardBorderColor,
      BorderRadius cardRadius,
      Color diffAddedColor,
      Color diffRemovedColor,
      MarkdownStyleSheet Function(BuildContext)? markdownStyleSheetBuilder,
      TextStyle? reasoningTextStyle});
}

/// @nodoc
class __$StackedChatStyleCopyWithImpl<$Res>
    implements _$StackedChatStyleCopyWith<$Res> {
  __$StackedChatStyleCopyWithImpl(this._self, this._then);

  final _StackedChatStyle _self;
  final $Res Function(_StackedChatStyle) _then;

  /// Create a copy of StackedChatStyle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sentBackground = null,
    Object? receivedBackground = null,
    Object? textStyle = null,
    Object? aiLeadingIconBuilder = freezed,
    Object? padding = null,
    Object? cardBorderColor = freezed,
    Object? cardRadius = null,
    Object? diffAddedColor = null,
    Object? diffRemovedColor = null,
    Object? markdownStyleSheetBuilder = freezed,
    Object? reasoningTextStyle = freezed,
  }) {
    return _then(_StackedChatStyle(
      sentBackground: null == sentBackground
          ? _self.sentBackground
          : sentBackground // ignore: cast_nullable_to_non_nullable
              as Color,
      receivedBackground: null == receivedBackground
          ? _self.receivedBackground
          : receivedBackground // ignore: cast_nullable_to_non_nullable
              as Color,
      textStyle: null == textStyle
          ? _self.textStyle
          : textStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle,
      aiLeadingIconBuilder: freezed == aiLeadingIconBuilder
          ? _self.aiLeadingIconBuilder
          : aiLeadingIconBuilder // ignore: cast_nullable_to_non_nullable
              as Widget Function(BuildContext)?,
      padding: null == padding
          ? _self.padding
          : padding // ignore: cast_nullable_to_non_nullable
              as EdgeInsets,
      cardBorderColor: freezed == cardBorderColor
          ? _self.cardBorderColor
          : cardBorderColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      cardRadius: null == cardRadius
          ? _self.cardRadius
          : cardRadius // ignore: cast_nullable_to_non_nullable
              as BorderRadius,
      diffAddedColor: null == diffAddedColor
          ? _self.diffAddedColor
          : diffAddedColor // ignore: cast_nullable_to_non_nullable
              as Color,
      diffRemovedColor: null == diffRemovedColor
          ? _self.diffRemovedColor
          : diffRemovedColor // ignore: cast_nullable_to_non_nullable
              as Color,
      markdownStyleSheetBuilder: freezed == markdownStyleSheetBuilder
          ? _self.markdownStyleSheetBuilder
          : markdownStyleSheetBuilder // ignore: cast_nullable_to_non_nullable
              as MarkdownStyleSheet Function(BuildContext)?,
      reasoningTextStyle: freezed == reasoningTextStyle
          ? _self.reasoningTextStyle
          : reasoningTextStyle // ignore: cast_nullable_to_non_nullable
              as TextStyle?,
    ));
  }
}

// dart format on
