/// ## 🏓 Bouncy Ball
/// Provides `BouncyBall` with user-facing `splashFactory`s.
///
/// Modified to `bouncy_ball.dart` by Adam Skelton (Zabadam) 2021.
///
/// ### Original `ink_ripple.dart`:
/// Copyright 2014 The Flutter Authors. All rights reserved.
/// Use of that source code is governed by a BSD-style license that can be
/// found in the Flutter LICENSE file.
library ball;

import 'dart:math' show max;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

const Duration _kUnconfirmedDuration = Duration(milliseconds: 1000);
const Duration _kFadeInDuration = Duration(milliseconds: 25);
const Duration _kCancelDuration = Duration(milliseconds: 400);
const Duration _kConfirmDuration = Duration(milliseconds: 1000);
const Duration _kFadeOutDuration = Duration(milliseconds: 600);

/// Classic.
// ignore: constant_identifier_names
const Curve _CUSTOM_INK = Curves.elasticOut;

/// A good bounce.
// ignore: constant_identifier_names
const Curve _BOUNCY_BALL = Curves.bounceOut;

/// "Bounce toward the finger"
// ignore: constant_identifier_names
const Curve _TOWARD_FINGER = Curves.bounceIn;

/// Warp, or BouncyBall to your face
// ignore: constant_identifier_names
const Curve _TOWARD_FACE = Curves.slowMiddle;

final Animatable<double> _radiusCurveTween =
    CurveTween(curve: Curves.easeInQuint);

final Animatable<double> _fadeOutIntervalTween =
    CurveTween(curve: const Interval(7 / 10, 1));

RectCallback? _getClipCallback(
  RenderBox referenceBox,
  bool containedInkWell,
  RectCallback? rectCallback,
) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}

double _getTargetRadius(
  RenderBox referenceBox,
  bool containedInkWell,
  RectCallback? rectCallback,
  Offset position,
) {
  final size = rectCallback != null ? rectCallback().size : referenceBox.size;
  final br = size.bottomRight(Offset.zero).distance;
  return max(
          br,
          (size.topRight(Offset.zero) - size.bottomLeft(Offset.zero))
              .distance) /
      2;
}

/// # 🏓 `BouncyBall`
/// | [![random splashFactory and color on every tap--bouncy balls!](https://raw.githubusercontent.com/Zabadam/ball/master/doc/variety_tiny.gif)](https://pub.dev/packages/ball/example 'random splashFactory and color on every tap--bouncy balls!') | A delightfully bouncy and position-mirroring reaction to user input on a piece of [Material]. |
/// |:-:|:-:|
///
/// ### [splashFactory]
/// | [![BouncyBall.splashFactory - bounce: "Bouncy Ball"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory.gif 'BouncyBall.splashFactory - bounce: "Bouncy Ball"') | An [InteractiveInkFeatureFactory] that produces 🏓 `BouncyBall`s as the ink splashes. |
/// |:-:|:--|
///
/// ### [marbleFactory]
/// | [![BouncyBall.marbleFactory - bounce: "Toward Finger"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/marbleFactory_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/marbleFactory.gif 'BouncyBall.marbleFactory - bounce: "Toward Finger"') | An [InteractiveInkFeatureFactory] that produces 🔮 Glass `BouncyBall`s (marbles) as the ink splashes. |
/// |:-:|:--|
///
/// ### [splashFactory2], [splashFactory3], & [splashFactory4]
/// [InteractiveInkFeatureFactory]s that produce 🏓 `BouncyBall`s \
/// as their ink splashes with varying bounce patterns.
///
/// |   |   |   |
/// |:--|:--|:-:|
/// | [![BouncyBall.splashFactory2 - bounce: "Custom Ink" (Classic)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory2_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory2.gif 'BouncyBall.splashFactory2 - bounce: "Custom Ink" (Classic)') | [![BouncyBall.splashFactory3 - bounce: "Toward Finger"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory3_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory3.gif 'BouncyBall.splashFactory3 - bounce: "Toward Finger"') | [![BouncyBall.splashFactory4 - bounce: "Toward Face"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory4_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory4.gif 'BouncyBall.splashFactory4 - bounce: "Toward Face"') |
///
/// ### [BouncyBall.mold]
/// An [InteractiveInkFeatureFactory] factory whose `splashFactory` \
/// 🪀 [mold]s 🏓 `BouncyBall`s from custom `rubber` [Paint].
/// ___
///
/// A circular ink feature whose origin immediately moves from input touch point
/// to an X- and Y-mirrored point opposite the touch point, growing to
/// twice the size of its [referenceBox].
///
/// This object is rarely created directly. \
/// Instead of creating a 🏓 `BouncyBall`, consider using an
/// [InkResponse] or [InkWell] widget, which uses gestures
/// (such as tap and long-press) to trigger ink splashes.
///
/// When the [Theme]'s [ThemeData.splashFactory]
/// is [BouncyBall.splashFactory], ink splashes will be 🏓 `BouncyBall`s.
/// ___
///
/// See also:
///
///  * [InkRipple], which is a built-in ink splash feature that expands less
///  aggressively than 🏓 [BouncyBall].
///  * [InkWell], which uses gestures to trigger ink highlights and ink
///  splashes in the parent [Material].
///  * [Material], which is the widget on which the ink splash is painted.
///  * [InkHighlight], which is an ink feature that emphasizes a part of a
///  [Material]
class BouncyBall extends InteractiveInkFeature {
  /// Begin a ripple, centered at [position] relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If [containedInkWell] is true, then the ripple will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by [rectCallback], if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If [containedInkWell] is false, then [rectCallback] should be null.
  /// The ink ripple is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the ripple is removed, [onRemoved] will be called.
  BouncyBall({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    required Paint rubber,
    Curve bounce = _BOUNCY_BALL,
    VoidCallback? onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder,
        _textDirection = textDirection,
        _targetRadius = radius ??
            _getTargetRadius(
                referenceBox, containedInkWell, rectCallback, position),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _rubber = rubber,
        _bounce = bounce,
        super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved) {
    /// Immediately begin fading-in the initial splash.
    _fadeInController =
        AnimationController(duration: _kFadeInDuration, vsync: controller.vsync)
          ..addListener(controller.markNeedsPaint)
          ..forward();
    _fadeIn = _fadeInController.drive(IntTween(
      begin: 0,
      end: color.alpha, // End at the opacity of provided [color]
    ));

    /// Controls the splash radius and its center. Starts upon `confirm`.
    _radiusController = AnimationController(
        duration: _kUnconfirmedDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();

    /// Initial splash diameter is 0% of the target diameter,
    /// final diameter is twice as large as the target diameter.
    _radius = _radiusController.drive(Tween<double>(
      // begin: _targetRadius * 0.05,
      begin: 0,
      end: _targetRadius * 2,
    ).chain(_radiusCurveTween));

    /// Controls the splash radius and its center.
    _fadeOutController = AnimationController(
        duration: _kFadeOutDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _fadeOut = _fadeOutController.drive(
      IntTween(
        begin: color.alpha, // Start at the opacity of provided [color]
        end: 0,
      ).chain(_fadeOutIntervalTween),
    );

    controller.addInkFeature(this); // 🏓
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final ShapeBorder? _customBorder;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final TextDirection _textDirection;
  final Paint _rubber;
  final Curve _bounce;

  late Animation<double> _radius;
  late AnimationController _radiusController;

  late Animation<int> _fadeIn;
  late AnimationController _fadeInController;

  late Animation<int> _fadeOut;
  late AnimationController _fadeOutController;

  /// #### Bounce: "Bouncy Ball"
  ///
  /// | [![BouncyBall.splashFactory - bounce: "Bouncy Ball"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory.gif 'BouncyBall.splashFactory - bounce: "Bouncy Ball"') | Use this [InteractiveInkFeatureFactory] to produce 🏓 [BouncyBall]s as the ink splashes for an [InkWell], [InkResponse] or material [Theme]. |
  /// |:-:|:--|
  static const InteractiveInkFeatureFactory splashFactory =
      _BouncyBallFactory();

  /// #### Bounce: "Custom Ink" (Classic)
  ///
  /// | [![BouncyBall.splashFactory2 - bounce: "Custom Ink" (Classic)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory2_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory2.gif 'BouncyBall.splashFactory2 - bounce: "Custom Ink" (Classic)') | Use this [InteractiveInkFeatureFactory] to produce 🏓 [BouncyBall]s as the ink splashes for an [InkWell], [InkResponse] or material [Theme]. |
  /// |:-:|:--|
  static const InteractiveInkFeatureFactory splashFactory2 =
      _BouncyBallFactory(bounce: _CUSTOM_INK);

  /// #### Bounce: "Toward Finger"
  ///
  /// | [![BouncyBall.splashFactory3 - bounce: "Toward Finger"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory3_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory3.gif 'BouncyBall.splashFactory3 - bounce: "Toward Finger"') | Use this [InteractiveInkFeatureFactory] to produce 🏓 [BouncyBall]s as the ink splashes for an [InkWell], [InkResponse] or material [Theme]. |
  /// |:-:|:--|
  static const InteractiveInkFeatureFactory splashFactory3 =
      _BouncyBallFactory(bounce: _TOWARD_FINGER);

  /// #### Bounce: "Toward Face"
  ///
  /// | [![BouncyBall.splashFactory4 - bounce: "Toward Face"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory4_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory4.gif 'BouncyBall.splashFactory4 - bounce: "Toward Face"') | Use this [InteractiveInkFeatureFactory] to produce 🏓 [BouncyBall]s as the ink splashes for an [InkWell], [InkResponse] or material [Theme]. |
  /// |:-:|:--|
  static const InteractiveInkFeatureFactory splashFactory4 =
      _BouncyBallFactory(bounce: _TOWARD_FACE);

  /// ### 🔮 [marbleFactory] | Glass 🏓 [BouncyBall]s
  /// #### Bounce: "Toward Finger"
  ///
  /// | [![BouncyBall.marbleFactory - bounce: "Toward Finger"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/marbleFactory_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/marbleFactory.gif 'BouncyBall.marbleFactory - bounce: "Toward Finger"') | Use this [InteractiveInkFeatureFactory] to produce 🔮 Glass [BouncyBall]s as the ink splashes for an [InkWell], [InkResponse] or material [Theme]. |
  /// |:-:|:--|
  static const InteractiveInkFeatureFactory marbleFactory = _MarbleFactory();

  /// ### 🪀 [mold] 🏓 [BouncyBall]s
  /// #### Bounce: "Bouncy Ball"
  /// A delightfully bouncy and position-mirroring reaction
  /// to user input on a piece of [Material].
  ///
  /// Design a `splashFactory` that produces 🏓 [BouncyBall]s
  /// 🪀 [mold]ed from [rubber] with this [Paint].
  ///
  /// ---
  /// | [![BouncyBall.splashFactory - bounce: "Bouncy Ball"](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory_small.gif)](https://raw.githubusercontent.com/Zabadam/ball/master/doc/splashFactory.gif 'BouncyBall.splashFactory - bounce: "Bouncy Ball"') | Bounce pattern follows 🏓 [splashFactory]'s "Bouncy Ball" |
  /// |:-:|:--|
  static InteractiveInkFeatureFactory mold({required Paint rubber}) =>
      _BouncyBallFactory(rubber: rubber);

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    // Mirror splash around [referenceBox.size.center] from [_position]
    final _center = referenceBox.size.center(Offset.zero);
    final _dx = -(_position.dx.toDouble() - _center.dx);
    final _dy = -(_position.dy.toDouble() - _center.dy);
    final _mirror = Offset.lerp(
      _position,
      referenceBox.size.center(Offset(_dx, _dy)),
      _bounce.transform(_radiusController.value),
    );

    // Default `Paint().color != Colors.transparent == 0x00000000`
    final _color =
        ((_rubber.color == const Color(0xff000000)) ? color : _rubber.color)
            .withAlpha(
      (_fadeInController.isAnimating ? _fadeIn.value : _fadeOut.value),
    );

    paintInkCircle(
        canvas: canvas,
        transform: transform,
        center: _mirror ?? Offset.zero,
        textDirection: _textDirection,
        radius: _radius.value,
        customBorder: _customBorder,
        borderRadius: _borderRadius,
        clipCallback: _clipCallback,
        paint: Paint()
          ..isAntiAlias = _rubber.isAntiAlias
          ..shader = _rubber.shader
          ..blendMode = _rubber.blendMode
          ..imageFilter = _rubber.imageFilter
          ..maskFilter = _rubber.maskFilter
          ..colorFilter = _rubber.colorFilter
          ..filterQuality = _rubber.filterQuality
          ..color = _color
          ..style = _rubber.style
          ..strokeWidth = _rubber.strokeWidth
          ..strokeCap = _rubber.strokeCap
          ..strokeJoin = _rubber.strokeJoin
          ..strokeMiterLimit = _rubber.strokeMiterLimit
          ..invertColors = _rubber.invertColors);
  }

  @override
  void confirm() {
    // Accelerate things a bit from [_kUnconfirmedDuration]
    _radiusController
      ..duration = _kConfirmDuration
      ..forward();

    // This confirm may have been preceded by a cancel.
    _fadeInController.forward();
    _fadeOutController.animateTo(1.0,
        // If this 🏓 [BouncyBall] is around long enough to fully expand,
        // get it off the canvas more quickly.
        duration: _radiusController.isAnimating
            ? _kFadeOutDuration
            : _kFadeOutDuration * 0.6);
  }

  @override
  void cancel() {
    _fadeInController.stop();

    // Watch out: setting _fadeOutController's value to 1.0 will
    // trigger a call to _handleAlphaStatusChanged() which will
    // dispose _fadeOutController.
    final fadeOutValue = 1.0 - _fadeInController.value;
    _fadeOutController.value = fadeOutValue;
    if (fadeOutValue < 1.0) {
      _fadeOutController.animateTo(1.0, duration: _kCancelDuration);
    }
  }

  void _handleAlphaStatusChanged(AnimationStatus status) =>
      (status == AnimationStatus.completed) ? dispose() : null;

  @override
  void dispose() {
    _radiusController.dispose();
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }
}

class _BouncyBallFactory extends InteractiveInkFeatureFactory {
  const _BouncyBallFactory({
    this.rubber,
    this.bounce = _BOUNCY_BALL,
  });
  final Paint? rubber;
  final Curve bounce;

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) =>
      BouncyBall(
        rubber: rubber ?? Paint(),
        bounce: bounce,
        controller: controller,
        referenceBox: referenceBox,
        position: position,
        color: color,
        containedInkWell: containedInkWell,
        rectCallback: rectCallback,
        borderRadius: borderRadius,
        customBorder: customBorder,
        radius: radius,
        onRemoved: onRemoved,
        textDirection: textDirection,
      );
}

class _MarbleFactory extends InteractiveInkFeatureFactory {
  const _MarbleFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) =>
      BouncyBall(
        rubber: Paint()
          ..imageFilter = ImageFilter.blur(sigmaX: 10, sigmaY: 10)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 50
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 20),
        bounce: _TOWARD_FINGER,
        controller: controller,
        referenceBox: referenceBox,
        position: position,
        color: color,
        containedInkWell: containedInkWell,
        rectCallback: rectCallback,
        borderRadius: borderRadius,
        customBorder: customBorder,
        radius: radius,
        onRemoved: onRemoved,
        textDirection: textDirection,
      );
}
