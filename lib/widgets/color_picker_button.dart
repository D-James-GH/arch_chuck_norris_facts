import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ColorPickerButton extends StatelessWidget {
  final Function onTap;
  final AnimationController animationController;

  const ColorPickerButton({Key key, this.onTap, this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Select Colors',
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(width: 10),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 0.5).animate(animationController),
            child: FaIcon(FontAwesomeIcons.caretDown,
                size: 35, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
