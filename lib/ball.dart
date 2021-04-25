/// ## 🏓 Bouncy Ball
/// A delightfully bouncy and position-mirroring reaction
/// to user input on a piece of [Material].
///
///
/// Turn ink splashes for an [InkWell], [InkResponse] or material [Theme]
/// into 🏓 [BouncyBall]s or 🔮 `Glass` [BouncyBall]s
/// with the built-in [InteractiveInkFeatureFactory]s,
/// or design your own with 🪀 [BouncyBall.mold].
///
/// ```
/// ThemeData(
///   splashFactory: BouncyBall.splashFactory,
///   splashColor: Colors.red,
/// )
/// ```
/// > > > > ### Now try some [Material]!
library ball;

export 'dart:ui' show ImageFilter;
export 'dart:math' show max, Random;

export 'src/bouncy_ball.dart';
