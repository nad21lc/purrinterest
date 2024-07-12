class Cat {
  String? id;
  String? name;
  String? origin;
  int? energyLevel;
  String? description;
  String? referenceImageId;
  int? intelligence;
  String? temperament;
  bool? isFavorite;

  Cat({
    this.id,
    this.name,
    this.origin,
    this.energyLevel,
    this.description,
    this.referenceImageId,
    this.intelligence,
    this.temperament,
    this.isFavorite,
  });

  Cat.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    name = json['name'] as String?;
    origin = json['origin'] as String?;
    energyLevel = json['energy_level'] as int?;
    description = json['description'] as String?;
    referenceImageId = json['reference_image_id'] != null
        ? 'https://cdn2.thecatapi.com/images/${json['reference_image_id'] as String}.jpg'
        : null;
    intelligence = json['intelligence'] as int?;
    temperament = json['temperament'] as String?;
    isFavorite = json['isFavorite'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['origin'] = origin;
    data['energy_level'] = energyLevel;
    data['description'] = description;
    data['reference_image_id'] = referenceImageId?.replaceFirst('https://cdn2.thecatapi.com/images/', '')?.replaceFirst('.jpg', '');
    data['temperament'] = temperament;
    data['intelligence'] = intelligence;
    data['isFavorite'] = isFavorite;
    return data;
  }

  //database
  // Method to convert Cat instance to a Map (used for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'temperament': temperament,
      'intelligence': intelligence,
      'reference_image_id': referenceImageId?.replaceFirst('https://cdn2.thecatapi.com/images/', '')?.replaceFirst('.jpg', ''),
    };
  }

  // Factory method to create a Cat instance from a Map (used for SQLite)
  Cat.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String?,
        name = map['name'] as String?,
        temperament = map['temperament'] as String?,
        intelligence = map['intelligence'] as int?,
        referenceImageId = map['reference_image_id'] != null
            ? 'https://cdn2.thecatapi.com/images/${map['reference_image_id'] as String}.jpg'
            : null;
}
