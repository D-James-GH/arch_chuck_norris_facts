import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:prime_chuck_arch/screens/facts_screen.dart';

// used in the initialization of the die class
bool checkPrime(int num) {
  if (num < 2) {
    // 1 and 0 are not prime
    return false;
  }
  // anything larger than the sqrt(num) will be too large
  for (int i = 2; i <= sqrt(num); i++) {
    if (num % i == 0) {
      return false;
    }
  }
  // number is prime
  return true;
}

class Die extends StatelessWidget {
  final Color primeColor;
  final Color evenColor;
  final Color oddColor;
  final int num;
  final bool isEven;
  final bool isPrime;
  final Function disable;
  final bool isDisabled;
  final AnimationController animationController;

  Die._({
    this.num,
    this.isPrime,
    this.isEven,
    this.disable,
    this.isDisabled,
    this.primeColor,
    this.evenColor,
    this.oddColor,
    this.animationController,
  });

  factory Die({
    int num,
    Function disable,
    bool isDisabled = false,
    Color primeColor,
    Color evenColor,
    Color oddColor,
    AnimationController animationController,
  }) {
    bool even = num % 2 == 0;
    bool prime = checkPrime(num);
    return Die._(
      num: num,
      isEven: even,
      isPrime: prime,
      disable: disable,
      isDisabled: isDisabled,
      evenColor: evenColor,
      primeColor: primeColor,
      oddColor: oddColor,
      animationController: animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color dieColor = calcColor();
    Color darkenedColor = darken(dieColor, 0.8);
    return GestureDetector(
      onTap: () => _onTap(context, dieColor),
      // outer darker container, to give effect of shadow on the die
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 0.05).animate(
            CurvedAnimation(parent: animationController, curve: ShakeCurve())),
        child: SlideTransition(
          position: Tween<Offset>(begin: Offset.zero, end: Offset(0.1, 0.1))
              .animate(CurvedAnimation(
                  parent: animationController, curve: Curves.bounceInOut)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: isPrime && !isDisabled
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [darkenedColor, darken(primeColor, 0.8)],
                    )
                  : null,
              color: isPrime && !isDisabled ? null : darkenedColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: isPrime && !isDisabled
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [dieColor, primeColor],
                      )
                    : null,
                color: isPrime && !isDisabled ? null : dieColor,
              ),
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    num.toString(),
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, Color color) {
    disable(num);
    if (isPrime && !isDisabled) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FactsScreen(
            num: num,
            color: color,
          ),
        ),
      );
    }
  }

  Color calcColor() {
    if (isDisabled) {
      return Color(0xffaaaaaa);
    }
    if (isEven) {
      return evenColor;
    }
    return oddColor;
  }

  Color darken(Color color, double amount) {
    return Color.fromARGB(color.alpha, (color.red * amount).round(),
        (color.green * amount).round(), (color.blue * amount).round());
  }
}

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2.5);
}
