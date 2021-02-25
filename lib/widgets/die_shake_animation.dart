import 'dart:math';

import 'package:flutter/material.dart';

class DieShakeAnimation extends StatelessWidget {
  final AnimationController animationController;
  final Widget child;

  const DieShakeAnimation(
      {Key key, @required this.animationController, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 0.05).animate(
        CurvedAnimation(
          parent: animationController,
          curve: ShakeCurve(),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: Offset(0.1, 0.1),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.bounceInOut,
          ),
        ),
        child: child,
      ),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2.5);
}
