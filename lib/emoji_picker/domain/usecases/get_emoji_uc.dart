import 'package:injectable/injectable.dart';

import '../../../core/shared_preferences.dart';
import '../../data/entity/emoji_model.dart';
import '../repositories/repository.dart';

abstract class GetEmojiUc {
  Future<List<EmojiCategoryMap>> execute();
}

@Injectable(as: GetEmojiUc)
class GetEmojiUcImpl implements GetEmojiUc {
  GetEmojiUcImpl({required this.repository});
  final Repository repository;

  @override
  Future<List<EmojiCategoryMap>> execute() async {
    try {
      List<Emoji> emojis = await SharedPreferencesEmoji.instance.getEmoji();
      List<EmojiCategoryMap> emojiModel = await repository.getEmoji();
      return [
        EmojiCategoryMap(parentCategory: 'Frequently Used', subCategories: [
          {'Recent Used': emojis.reversed.toList().sublist(0, 10)}
        ]),
        ...emojiModel
      ];
    } catch (e) {
      throw Exception();
    }
  }
}
