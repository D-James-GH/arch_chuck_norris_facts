import 'dart:math';
import 'package:flutter/material.dart';
import 'package:prime_chuck_arch/models/dad_joke_model.dart';
import 'package:prime_chuck_arch/services/services.dart';
import 'package:prime_chuck_arch/widgets/path_container.dart';

class FactsScreen extends StatefulWidget {
  final int num;
  final Color color;
  FactsScreen({Key key, this.num, this.color}) : super(key: key);

  @override
  _FactsScreenState createState() => _FactsScreenState();
}

class _FactsScreenState extends State<FactsScreen> {
  Services services = Services();
  String _quote;

  @override
  void initState() {
    super.initState();
    _getFact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chuck Says',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return Hero(
          tag: widget.num,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.color,
                  Colors.blue,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    Scaffold.of(context).appBarMaxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 350,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Image(
                              image:
                                  AssetImage('assets/images/chuck_norris.png'),
                              width: MediaQuery.of(context).size.width / 2,
                            ),
                          ),
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
                              constraints:
                                  BoxConstraints(maxHeight: 200, minHeight: 50),
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
                              child: SingleChildScrollView(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    _quote != null ? _quote : '',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    ClipPath(
                      clipper: PathContainer(),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.8),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: _getDadJoke,
                                child: Column(
                                  children: [
                                    Text(
                                      "Don't like Chuck Norris?",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Get a Dad Joke',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _getDadJoke() async {
    DadJokeModel joke = await services.fetchDadJoke();
    setState(() {
      _quote = joke.joke;
    });
  }

  void _getFact() async {
    var allFacts = await services.getJson();
    setState(() {
      _quote = allFacts[Random().nextInt(allFacts.length)].fact;
    });
  }
}
