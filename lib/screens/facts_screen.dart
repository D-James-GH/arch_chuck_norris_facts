import 'dart:math';
import 'package:flutter/material.dart';
import 'package:prime_chuck_arch/models/dad_joke_model.dart';
import 'package:prime_chuck_arch/services/services.dart';
import 'package:prime_chuck_arch/widgets/path_container.dart';
import 'package:prime_chuck_arch/widgets/speech_bubble.dart';

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
        // use a builder so that the scaffold context is available in the body
        return Hero(
          tag: widget.num,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              // same gradient as the die on the home page
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.color,
                  Colors.blue,
                ],
              ),
            ),
            // main area wrapped in SingleChildScroll view to prevent render overflow on
            // hero animation
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
                          SpeechBubble(quote: _quote),
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
    var allFacts = await services.getChuckFact();
    setState(() {
      _quote = allFacts[Random().nextInt(allFacts.length)].fact;
    });
  }
}
