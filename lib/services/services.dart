import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:prime_chuck_arch/models/dad_joke_model.dart';
import '../models/chuck_fact_model.dart';

class Services {
  Future<List<ChuckFactModel>> getChuckFact() async {
    String fromJson = await rootBundle.loadString('assets/facts.json');
    List data = await json.decode(fromJson);
    // convert json to dart class to gain code completion and prevent errors
    return data.map((d) => ChuckFactModel.fromMap(d)).toList();
  }

  Future<DadJokeModel> fetchDadJoke() async {
    http.Response response = await http.get('https://icanhazdadjoke.com/',
        headers: {'Accept': 'application/json'});
    Map<String, dynamic> resJson = json.decode(response.body ?? '');
    return DadJokeModel.fromMap(resJson);
  }
}
