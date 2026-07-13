enum CollectibleType {
  flower,
  shrub, // 灌木
  grass, // 草
  mushroom,// 蘑菇
  tree,
  house;

  String get displayName {
    switch (this) {
      case CollectibleType.flower:
        return "花";

      case CollectibleType.tree:
        return "树";

      case CollectibleType.shrub:
        return "灌木";

      case CollectibleType.grass:
        return "草";

      case CollectibleType.mushroom:
        return "蘑菇";
      case CollectibleType.house:
        return "房子";
    }
  }

  static CollectibleType fromString(String value) {
    return CollectibleType.values.firstWhere(
          (e) => e.name == value,
      orElse: () => CollectibleType.flower,
    );
  }
}

class CollectibleItem {
  final String id;
  final String name;
  final String icon;
  final String desc;
  final CollectibleType type;

  const CollectibleItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.desc,
  });

  factory CollectibleItem.fromJson(Map<String, dynamic> json) {
    return CollectibleItem(
      id: json["id"] as String,
      name: json["name"] as String,
      icon: json["icon"] as String,
      desc: json["desc"] as String,
      type: CollectibleType.fromString(json["type"] as String),
    );
  }

  String get assetPath =>
      "assets/images/${type.name}/$icon";
}