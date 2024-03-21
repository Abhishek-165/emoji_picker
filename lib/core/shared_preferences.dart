import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../emoji_picker/data/entity/emoji_model.dart';

class SharedPreferencesEmoji {
  late SharedPreferences sharedPreferences;

  static final _instance = SharedPreferencesEmoji._internal();

  static SharedPreferencesEmoji get instance => _instance;

  SharedPreferencesEmoji._internal();

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> saveEmoji(List<Emoji> emoji) async {
    return await sharedPreferences.setStringList(
        'emoji', emoji.map((e) => jsonEncode(e.toJson())).toList());
  }

  Future<List<Emoji>> getEmoji() async {
    final emoji = sharedPreferences.getStringList('emoji');
    if (emoji != null) {
      return emoji.map((e) {
        final json = jsonDecode(e) as Map<String, dynamic>;
        return Emoji.fromJson([
          json['id'],
          json['unicode'],
          json['character'],
          json['description'],
        ]);
      }).toList();
    } else {
      return [];
    }
  }
}
