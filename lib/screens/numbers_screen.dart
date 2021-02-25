import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prime_chuck_arch/widgets/color_picker_button.dart';
import 'package:prime_chuck_arch/widgets/color_select.dart';
import 'package:prime_chuck_arch/widgets/die.dart';
import 'package:prime_chuck_arch/widgets/shuffle_button.dart';

class NumbersScreen extends StatefulWidget {
  NumbersScreen({Key key}) : super(key: key);

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
        lowerBound: 0,
        upperBound: 1);
    _shakeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 10;
    return Scaffold(
      appBar: AppBar(
        leading: ShuffleButton(
          onTap: _shuffle,
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
              onPressed: reset),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      // ============== Scaffold body ============================================
      body: Column(
        children: [
          // Color picker animated container
          AnimatedContainer(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )),
            duration: Duration(milliseconds: 300),
            height: _isColorPickerOpen ? 100 : 0,
            width: double.infinity,
            child: SingleChildScrollView(
              child: ColorSelector(
                setColor: setColor,
                primeColor: _primeColor,
                evenColor: _evenColor,
                oddColor: _oddColor,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              padding:
                  EdgeInsets.only(top: spacing, right: spacing, left: spacing),
              crossAxisCount: 4,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              children: _numbers
                  .map(
                    (num) => Hero(
                      tag: num,
                      child: Die(
                        animationController: _shakeAnimationController,
                        oddColor: _oddColor,
                        primeColor: _primeColor,
                        evenColor: _evenColor,
                        num: num,
                        isDisabled: _disabled[num] ?? false,
                        disable: _disable,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void setColor({Color setPrime, Color setEven, Color setOdd}) {
    // pass down to color picker to allow the user to set the three colors used on the die
    setState(() {
      if (setPrime != null) {
        _primeColor = setPrime;
      }
      if (setEven != null) {
        _evenColor = setEven;
      }
      if (setOdd != null) {
        _oddColor = setOdd;
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

  void reset() {
    // sort the dice numbers from 1-100 and reset all disabled dice
    var newList = _numbers;
    newList.sort();
    setState(() {
      _disabled = {};
      _primeColor = Colors.blue;
      _evenColor = Colors.red;
      _oddColor = Colors.green;
    });
  }

  void _shuffle() {
    var newList = _numbers;
    newList.shuffle();
    // _shakeAnimationController
    //     .forward()
    //     .then((value) => _shakeAnimationController.reverse());
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
