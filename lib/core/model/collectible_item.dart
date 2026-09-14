enum CollectibleType {
  flower(
    code: 'flower',
    displayName: "flower",
  ),
  shrub(
    code: 'shrub',
    displayName: 'shrub',
  ),
  grass(
    code: 'grass',
    displayName: 'grass',
  ),
  mushroom(
    code: 'mushroom',
    displayName: 'mushroom',
  ),
  tree(
    code: 'tree',
    displayName: 'tree',
  ),
  house(
    code: 'house',
    displayName: 'house',
  );

  final String code;
  final String displayName;

  const CollectibleType({
    required this.code,
    required this.displayName,
  });

  static CollectibleType fromCode(String code) {
    return CollectibleType.values.firstWhere(
          (e) => e.code == code,
      orElse: () => CollectibleType.flower,
    );
  }
}

class CollectibleItem {
  final int id;
  final String name;
  final String icon;
  final String desc;
  final CollectibleType type;

  const CollectibleItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.desc,
    required this.type,
  });

  factory CollectibleItem.fromMap(Map<String, dynamic> map) {
    return CollectibleItem(
      id: map['id'] as int,
      name: map['name'] as String,
      icon: map['icon'] as String,
      desc: map['desc'] as String,
      type: CollectibleType.fromCode(map['type'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'desc': desc,
      'type': type.code,
    };
  }

  String get assetPath => 'assets/images/${type.code}/$icon';
}