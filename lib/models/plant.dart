class Plant {
  final String id;
  final String name;
  final String scientificName;
  final String family;
  final String? localName;
  final double confidence;

  Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.family,
    this.localName,
    required this.confidence,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Plante inconnue',
      scientificName: json['scientificName'] ?? '',
      family: json['family'] ?? '',
      localName: json['localName'],
      confidence: (json['confidence'] ?? 0).toDouble(),
    );
  }
}
