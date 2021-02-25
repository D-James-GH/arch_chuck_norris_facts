class ChuckFactModel {
  final String id;
  final String fact;

  ChuckFactModel({this.id, this.fact});

  factory ChuckFactModel.fromMap(Map<String, dynamic> data) {
    return ChuckFactModel(
      id: data['id'] ?? '',
      fact: data['value'] ?? '',
    );
  }
}
