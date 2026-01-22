class Flashset {
  final String id;
  final String name;
  final String detail;
  Flashset({required this.id, required this.name, required this.detail});

  factory Flashset.fromJson(Map<String, dynamic> json) {
    return Flashset(
      id: json['_id'] as String,
      name: json['name'] as String,
      detail: json['detail'] as String,
    );
  }
}
