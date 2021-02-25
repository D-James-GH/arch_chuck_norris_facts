import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:prime_chuck_arch/screens/facts_screen.dart';
import 'package:prime_chuck_arch/widgets/die_shake_animation.dart';

class Die extends StatelessWidget {
  final Color primeColor;
  final Color evenColor;
  final Color oddColor;
  final int num;
  final bool isEven;
  final bool isPrime;
  final bool isDisabled;
  final Function disable;
  final AnimationController animationController;

  Die({
    Key key,
    this.isPrime = false,
    this.isEven = false,
    this.isDisabled = false,
    @required this.num,
    @required this.disable,
    @required this.primeColor,
    @required this.evenColor,
    @required this.oddColor,
    @required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color dieColor = _calcColor();
    Color darkenedColor = _darken(dieColor, 0.8);
    return DieShakeAnimation(
      animationController: animationController,
      child: Material(
        child: InkWell(
          onTap: () => _onTap(context, dieColor),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: isPrime && !isDisabled
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [darkenedColor, _darken(primeColor, 0.8)],
                    )
                  : null,
              color: isPrime && !isDisabled ? null : darkenedColor,
            ),
            child: Ink(
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
            primeColor: primeColor,
          ),
        ),
      );
    }
  }

  Color _calcColor() {
    if (isDisabled) {
      return Color(0xffaaaaaa);
    }
    if (isEven) {
      return evenColor;
    }
    return oddColor;
  }

  Color _darken(Color color, double amount) {
    return Color.fromARGB(color.alpha, (color.red * amount).round(),
        (color.green * amount).round(), (color.blue * amount).round());
  }
}
