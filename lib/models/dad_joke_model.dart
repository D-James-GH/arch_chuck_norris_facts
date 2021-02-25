class DadJokeModel {
  final String joke;
  final String id;

  DadJokeModel({this.joke, this.id});
  factory DadJokeModel.fromMap(Map<String, dynamic> data) {
    return DadJokeModel(
      joke: data['joke'] ?? '',
      id: data['id'] ?? '',
    );
  }
}
