/// ## 🏓 Bouncing Ball Demo
library ball_demo;

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:ball/ball.dart';

/// Mouse-over [BouncyBall.mold] or `ctrl`+`click`
/// in most editors to goto the definition.
final packagedBouncyBalls = BouncyBall.mold(
    rubber: Paint()..maskFilter = const MaskFilter.blur(BlurStyle.inner, 600)
    // rubber: Paint()..maskFilter = MaskFilter.blur(BlurStyle.solid, 100)
    // .. // Uncomment this line  -  [Ctrl] + [/]
    // Then move to right after '..' and try autocomplete  -  [Ctrl] + [Space]
    );

/// Mouse-over for tooltips!
List<InteractiveInkFeatureFactory> factories = [
  BouncyBall.splashFactory,
  BouncyBall.splashFactory2,
  BouncyBall.splashFactory3,
  BouncyBall.splashFactory4,
  BouncyBall.marbleFactory,
  packagedBouncyBalls,
];
List<MaterialColor> _colors = List.from(Colors.primaries)..shuffle();

void main() => runApp(const BallDemo());

/// {@macro demo}
class BallDemo extends StatelessWidget {
  /// {@template demo}
  /// `MaterialApp` frame where the [InteractiveInkFeatureFactory] is supplied.
  /// {@endtemplate}
  const BallDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🏓 Bouncy Ball Demo',
      theme: ThemeData(
        splashFactory: BouncyBall.splashFactory,
        // splashFactory: BouncyBall.splashFactory2,
        // splashFactory: BouncyBall.splashFactory3,
        // splashFactory: BouncyBall.splashFactory4,
        // splashFactory: BouncyBall.marbleFactory,
        // splashFactory: packagedBouncyBalls,
      ),
      home: const BallPit(),
    );
  }
}

/// {@macro ballpit}
class BallPit extends StatefulWidget {
  /// {@template ballpit}
  /// A full-screen [InkResponse] with an `onTap` to provide ink splashes.
  ///
  /// Override the `splashFactory` with a rnadom entry from a list of them.
  /// {@endtemplate}
  const BallPit({Key? key}) : super(key: key);

  @override
  _BallPitState createState() => _BallPitState();
}

class _BallPitState extends State<BallPit> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          splashFactory: factories.first,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: SafeArea(
          child: Scaffold(
            body: InkResponse(
              // No ink splashes will render without an `onTap` anyway
              onTap: () => setState(() {
                factories.shuffle();
                _colors.shuffle();
              }),
              splashColor: _colors.first[100 * (4 + Random().nextInt(3))],
              // Let us only observe the 🏓 Bouncy Balls.
              highlightColor: Colors.transparent,
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  iconSize: 75,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),
      );
}
