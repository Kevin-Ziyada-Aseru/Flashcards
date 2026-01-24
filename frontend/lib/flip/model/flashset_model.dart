class Flashset {
  final int id;
  final String name;
  final String detail;

  Flashset({required this.id, required this.name, required this.detail});

  factory Flashset.fromJson(Map<String, dynamic> json) {
    return Flashset(id: json['id'], name: json['name'], detail: json['detail']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'detail': detail};

  Flashset copyWith({
    int? id,
    String? name,
    String? detail,
    DateTime? createdAt,
  }) {
    return Flashset(
      id: id ?? this.id,
      name: name ?? this.name,
      detail: detail ?? this.detail,
    );
  }
}
