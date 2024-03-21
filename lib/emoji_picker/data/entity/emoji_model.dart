import 'package:equatable/equatable.dart';

class EmojiCategoryMap {
  final String parentCategory;
  final List<Map<String, List<Emoji>>> subCategories;

  const EmojiCategoryMap({
    required this.parentCategory,
    required this.subCategories,
  });

  factory EmojiCategoryMap.fromJson(Map<String, dynamic> json) =>
      EmojiCategoryMap(
        parentCategory: json['parent_category'] as String,
        subCategories: json['sub_category'] as List<Map<String, List<Emoji>>>,
      );
}

class Emoji extends Equatable {
  final String id;
  final String unicode;
  final String character;
  final String description;

  const Emoji({
    required this.id,
    required this.unicode,
    required this.character,
    required this.description,
  });

  factory Emoji.fromJson(List<dynamic> json) {
    if (json.length != 4) {
      throw const FormatException("Invalid emoji data format");
    }
    return Emoji(
      id: json[0] as String,
      unicode: json[1] as String,
      character: json[2] as String,
      description: json[3] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'unicode': unicode,
        'character': character,
        'description': description
      };

  @override
  List<Object> get props => [id, unicode, character, description];
}
