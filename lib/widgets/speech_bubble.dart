import 'dart:math';
import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String quote;

  const SpeechBubble({Key key, this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // rotated container to give the impression of a speech bubble,
        // easier than creating a custom path
        Positioned(
          bottom: 149,
          left: MediaQuery.of(context).size.width / 2 - 15,
          child: Transform.rotate(
            angle: pi / 4,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 130,
          child: Container(
            constraints: BoxConstraints(maxHeight: 200, minHeight: 50),
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width / 2,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(5, 0),
                    blurRadius: 5,
                    spreadRadius: 5)
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            // prevent render overflow on animation
            child: SingleChildScrollView(
              child: Material(
                color: Colors.transparent,
                child: Text(
                  quote != null ? quote : '',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
