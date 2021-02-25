import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShuffleButton extends StatelessWidget {
  final Function onTap;

  const ShuffleButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Center(
        child: IconButton(
          onPressed: onTap,
          icon: FaIcon(FontAwesomeIcons.dice, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}
