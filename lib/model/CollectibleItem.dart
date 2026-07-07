enum CollectibleType {
  flower;

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