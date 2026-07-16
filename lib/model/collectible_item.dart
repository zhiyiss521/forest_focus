enum CollectibleType {
  flower(
    code: 'flower',
    displayName: '花',
  ),
  shrub(
    code: 'shrub',
    displayName: '灌木',
  ),
  grass(
    code: 'grass',
    displayName: '草',
  ),
  mushroom(
    code: 'mushroom',
    displayName: '蘑菇',
  ),
  tree(
    code: 'tree',
    displayName: '树',
  ),
  house(
    code: 'house',
    displayName: '房子',
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