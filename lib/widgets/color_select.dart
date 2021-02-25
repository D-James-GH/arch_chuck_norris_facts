import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum NumTypes { prime, even, odd }

class ColorSelector extends StatelessWidget {
  final Color primeColor;
  final Color evenColor;
  final Color oddColor;
  final Function setColor;
  final List<MaterialColor> availableColors = Colors.primaries;
  ColorSelector(
      {this.primeColor, this.evenColor, this.oddColor, this.setColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildColorIcon(context, primeColor, 'Prime Color', NumTypes.prime),
            _buildColorIcon(context, oddColor, 'Odd Color', NumTypes.odd),
            _buildColorIcon(context, evenColor, 'Even Color', NumTypes.even),
          ],
        ),
      ),
    );
  }

  Widget _buildColorIcon(
      BuildContext context, Color color, String label, NumTypes numType) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
        GestureDetector(
          onTap: () => _changeColor(context, color, numType),
          child: Container(
            width: 50,
            height: 50,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 2)
            ]),
          ),
        ),
      ],
    );
  }

  void _changeColor(
      BuildContext context, Color currentColor, NumTypes numType) {
    showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: Container(
            width: 100,
            height: 350,
            child: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: EdgeInsets.all(10),
              crossAxisCount: 4,
              children: availableColors
                  .map((MaterialColor col) => GestureDetector(
                        onTap: () {
                          switch (numType) {
                            case NumTypes.even:
                              setColor(setEven: col[500]);
                              break;
                            case NumTypes.odd:
                              setColor(setOdd: col[500]);
                              break;
                            case NumTypes.prime:
                              setColor(setPrime: col[500]);
                              break;
                          }
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: col,
                            shape: BoxShape.circle,
                          ),
                          child: col == currentColor
                              ? Center(
                                  child: FaIcon(FontAwesomeIcons.check,
                                      color: Colors.white),
                                )
                              : null,
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
