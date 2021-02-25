import 'dart:math';

import 'package:flutter/material.dart';
import 'package:prime_chuck_arch/widgets/color_picker_button.dart';
import 'package:prime_chuck_arch/widgets/color_select.dart';
import 'package:prime_chuck_arch/widgets/die.dart';
import 'package:prime_chuck_arch/widgets/shuffle_button.dart';

class NumbersScreen extends StatefulWidget {
  final Function setPrimarySwatch;

  NumbersScreen({Key key, this.setPrimarySwatch}) : super(key: key);

  @override
  _NumbersScreenState createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen>
    with TickerProviderStateMixin {
  Map<int, bool> _disabled = {};
  List<int> _numbers = List.generate(100, (index) => index + 1);
  bool _isColorPickerOpen = false;
  AnimationController
      _caretAnimationController; // controls the caret in the appbar
  AnimationController _shakeAnimationController;
  Color _primeColor = Colors.blue;
  Color _evenColor = Colors.red;
  Color _oddColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _caretAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450),
    );
    _shakeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // ============== Scaffold body =========================================
      body: Column(
        children: [
          // Color picker animated container
          ColorSelector(
            primeColor: _primeColor,
            evenColor: _evenColor,
            oddColor: _oddColor,
            setColor: _setColor,
            isColorPickerOpen: _isColorPickerOpen,
          ),
          _buildGridView(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: ShuffleButton(
        onTap: _shuffleNumbers,
      ),
      centerTitle: true,
      title: ColorPickerButton(
        animationController: _caretAnimationController,
        onTap: _showColorPicker,
      ),
      actions: [
        IconButton(
            icon: Icon(
              Icons.refresh,
              size: 30,
            ),
            onPressed: _reset),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _buildGridView() {
    double spacing = 10;
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.only(top: spacing, right: spacing, left: spacing),
        crossAxisCount: 4,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        children: _numbers.map(
          (num) {
            bool isEven = num % 2 == 0;
            bool isPrime = checkPrime(num);
            return Hero(
              tag: num,
              child: Die(
                animationController: _shakeAnimationController,
                oddColor: _oddColor,
                primeColor: _primeColor,
                evenColor: _evenColor,
                num: num,
                isDisabled: _disabled[num] ?? false,
                disable: _disable,
                isEven: isEven,
                isPrime: isPrime,
              ),
            );
          },
        ).toList(),
      ),
    );
  }

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

  void _setColor(
      {MaterialColor setPrime, MaterialColor setEven, MaterialColor setOdd}) {
    // pass down to color picker to allow the user to set the three colors used on the die
    setState(() {
      if (setPrime != null) {
        _primeColor = setPrime[500];
      }
      if (setEven != null) {
        _evenColor = setEven[500];
      }
      if (setOdd != null) {
        _oddColor = setOdd[500];
        widget.setPrimarySwatch(setOdd);
      }
    });
  }

  void _showColorPicker() {
    // allow the user to pick from the standard material color swatch
    setState(() {
      _isColorPickerOpen = !_isColorPickerOpen;
    });
    // animate the down caret to show how to close and open the color picker
    if (_isColorPickerOpen) {
      _caretAnimationController.forward();
    } else {
      _caretAnimationController.reverse();
    }
  }

  void _disable(int num) {
    // add the number to a map to make it quickly accessible when redrawing
    setState(() {
      _disabled[num] = true;
    });
  }

  void _reset() {
    // sort the dice numbers from 1-100 and reset all disabled dice
    var newList = _numbers;
    newList.sort();
    setState(() {
      _disabled = {};
      _primeColor = Colors.blue;
      _evenColor = Colors.red;
      _oddColor = Colors.green;
    });
    widget.setPrimarySwatch(Colors.green);
  }

  void _shuffleNumbers() {
    var newList = _numbers;
    newList.shuffle();

    // make the animation repeat while the time out is happening
    TickerFuture tickerFuture = _shakeAnimationController.repeat(reverse: true);
    tickerFuture.timeout(Duration(seconds: 1), onTimeout: () {
      _shakeAnimationController.forward(from: 0);
      _shakeAnimationController.stop(canceled: true);
    });
    setState(() {
      _numbers = newList;
    });
  }

  @override
  void dispose() {
    _caretAnimationController.dispose();
    super.dispose();
  }
}
