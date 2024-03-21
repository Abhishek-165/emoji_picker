import '../../data/entity/emoji_model.dart';

abstract class Repository {
  Future<List<EmojiCategoryMap>> getEmoji();
}
