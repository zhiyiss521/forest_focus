class Tag {
  final int? id;
  final String name;
  final int color;
  final String icon;

  const Tag({
    this.id,
    required this.name,
    required this.color,
    required this.icon,
  });

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: map['color'] as int,
      icon: map['icon'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'icon': icon,
    };
  }

  Tag copyWith({
    int? id,
    String? name,
    int? color,
    String? icon,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Tag && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Tag(id: $id, name: $name)';
  }
}