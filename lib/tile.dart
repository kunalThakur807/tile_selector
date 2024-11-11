class Tile {
  final int? id;
  final String name;
  final String color;
  final String usage;
  final String imageUrl;

  Tile(
      {this.id,
      required this.name,
      required this.color,
      required this.usage,
      required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'usage': usage,
      'image_url': imageUrl,
    };
  }

  static Tile fromMap(Map<String, dynamic> map) {
    return Tile(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      usage: map['usage'],
      imageUrl: map['image_url'],
    );
  }

  // Override equality and hashCode to compare Tiles based on properties
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tile &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          color == other.color &&
          usage == other.usage &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      name.hashCode ^ color.hashCode ^ usage.hashCode ^ imageUrl.hashCode;
}
