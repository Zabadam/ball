/// ## 🏓 Ball
/// Provides `BouncyBall`s, delightfully bouncy and position-mirroring
/// ink splash reactions to user input on a piece of `Material`.
///
/// ## [pub.dev Listing](https://pub.dev/packages/ball) | [API Doc](https://pub.dev/documentation/ball/latest) | [GitHub](https://github.com/Zabadam/ball)
/// #### API References: [`BouncyBall`](https://pub.dev/documentation/ball/latest/ball/BouncyBall-class.html)
///
/// | [![random splashFactory and color on every tap--bouncy balls!](https://raw.githubusercontent.com/Zabadam/ball/master/doc/variety_small.gif)](https://pub.dev/packages/ball/example 'random splashFactory and color on every tap--bouncy balls!') | <h4>Turn ink splashes for an `InkWell`, `InkResponse` or material `Theme` <br />into 🏓 `BouncyBall`s or 🔮 `Glass` `BouncyBall`s (marbles) <br />with the built-in `InteractiveInkFeatureFactory`s,  <br />or design your own with 🪀 `BouncyBall.mold`.</h4> |
/// |:-:|:--|
//
// Turn ink splashes for an `InkWell`, `InkResponse` or material `Theme` \
// into 🏓 `BouncyBall`s or 🔮 `Glass` `BouncyBall`s (marbles) with the \
// built-in `InteractiveInkFeatureFactory`s,  or design your own \
// with 🪀 `BouncyBall.mold`.
///
/// ```
/// ThemeData(
///   splashFactory: BouncyBall.splashFactory,
///   splashColor: Colors.red,
/// )
/// ```
/// ### Now try some `Material`!
/// [![random splashFactory and color on every tap--bouncy balls!](https://raw.githubusercontent.com/Zabadam/ball/master/doc/variety.gif)](https://pub.dev/packages/ball/example 'random splashFactory and color on every tap--bouncy balls!')
library ball;

export 'src/bouncy_ball.dart';
