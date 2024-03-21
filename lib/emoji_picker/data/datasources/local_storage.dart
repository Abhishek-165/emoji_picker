import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../entity/emoji_model.dart';

@Injectable()
class LocalStorageImpl {
  Future<List<EmojiCategoryMap>> getEmoji() async {
    try {
      String jsonString = await rootBundle.loadString('assets/all-emoji.json');
      List<EmojiCategoryMap> categories =
          await compute((res) => parseEmojis(jsonString), jsonString);
      return categories;
    } catch (e) {
      throw Exception(e);
    }
  }
}

/*

Parent Category->[]
Sub Category ->[]
data ->[]

*/

List<EmojiCategoryMap> parseEmojis(String jsonString) {
  final jsonData = jsonDecode(jsonString) as List<dynamic>;
  List<EmojiCategoryMap> categories = <EmojiCategoryMap>[];
  List<Emoji> emojis = [];
  String parentCategory = "";
  String subCategory = "";
  List<Map<String, List<Emoji>>> subCategoryList = [];

  int i = 0;
  while (i < jsonData.length) {
    if (jsonData[i].length == 1 && jsonData[i + 1].length == 1) {
      subCategoryList.add({subCategory: emojis});
      if (emojis.isNotEmpty) {
        categories.add(EmojiCategoryMap(
          parentCategory: parentCategory,
          subCategories: subCategoryList,
        ));
      }
      parentCategory = "";
      subCategory = "";
      emojis = [];
      subCategoryList = [];
      parentCategory = jsonData[i][0] as String;
      subCategory = jsonData[i + 1][0] as String;
      i += 2;
    } else if (jsonData[i].length == 1) {
      subCategoryList.add({subCategory: emojis});
      emojis = [];
      subCategory = jsonData[i][0] as String;
      i++;
    } else {
      emojis.add(Emoji.fromJson(jsonData[i]));
      i++;
    }
  }
  subCategoryList.add({subCategory: emojis});
  if (emojis.isNotEmpty) {
    categories.add(EmojiCategoryMap(
      parentCategory: parentCategory,
      subCategories: subCategoryList,
    ));
  }
  parentCategory = "";
  subCategory = "";
  emojis = [];
  subCategoryList = [];
  return categories;
}
