/// ## 🏓 Bouncing Ball Demo
library ball_demo;

import 'package:flutter/material.dart';

import 'package:ball/ball.dart';

/// Mouse-over [BouncyBall.mold] or [ctrl]+[click]
/// in most editors to goto the definition.
final packagedBouncyBalls = BouncyBall.mold(
    rubber: Paint()..maskFilter = MaskFilter.blur(BlurStyle.solid, 100)
    // rubber: Paint()..maskFilter = MaskFilter.blur(BlurStyle.inner, 500)
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
List<MaterialColor> colors = List.from(Colors.primaries)..shuffle();

void main() => runApp(BallDemo());

class BallDemo extends StatelessWidget {
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
      home: BallPit(),
    );
  }
}

class BallPit extends StatefulWidget {
  const BallPit({Key? key}) : super(key: key);
  _BallPitState createState() => _BallPitState();
}

class _BallPitState extends State<BallPit> {
  Widget build(BuildContext context) {
    return MaterialApp(
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
              colors.shuffle();
            }),
            splashColor: colors.first[100 * (4 + Random().nextInt(3))],
            // Let us only observe the 🏓 Bouncy Balls.
            highlightColor: Colors.transparent,
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
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
}
