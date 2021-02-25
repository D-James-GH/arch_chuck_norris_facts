import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prime_chuck_arch/widgets/color_select.dart';
import 'package:prime_chuck_arch/widgets/die.dart';

class NumbersScreen extends StatefulWidget {
  NumbersScreen({Key key}) : super(key: key);

  @override
  _NumbersScreenState createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen>
    with SingleTickerProviderStateMixin {
  Map<int, bool> _disabled = {};
  List<int> _numbers = List.generate(100, (index) => index + 1);
  bool _isColorPickerOpen = false;
  AnimationController _animationController;
  ScrollController _scrollController = ScrollController();
  Color _primeColor = Colors.blue;
  Color _evenColor = Colors.red;
  Color _oddColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 450),
        lowerBound: 0,
        upperBound: 1);
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 10;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Center(
            child: IconButton(
              onPressed: _shuffle,
              icon: FaIcon(
                FontAwesomeIcons.dice,
                size: 30,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: GestureDetector(
          onTap: _showColorPicker,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Colors',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(width: 10),
              RotationTransition(
                turns:
                    Tween(begin: 0.0, end: 0.5).animate(_animationController),
                child: FaIcon(FontAwesomeIcons.caretDown,
                    size: 35, color: Colors.white),
              ),
            ],
          ),
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
      body: Column(
        children: [
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
              controller: _scrollController,
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
    setState(() {
      _isColorPickerOpen = !_isColorPickerOpen;
    });
    if (_isColorPickerOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _disable(int num) {
    setState(() {
      _disabled[num] = true;
    });
  }

  void reset() {
    var newList = _numbers;
    newList.sort();
    setState(() {
      _disabled = {};
    });
  }

  void _shuffle() {
    var newList = _numbers;
    newList.shuffle();
    setState(() {
      _numbers = newList;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
