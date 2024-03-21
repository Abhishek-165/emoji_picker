import 'package:emoji_picker/emoji_picker/data/entity/emoji_model.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/repository.dart';
import '../datasources/local_storage.dart';

@Injectable(as: Repository)
class RepositoryImpl implements Repository {
  const RepositoryImpl({required this.localStorage});
  final LocalStorageImpl localStorage;

  @override
  Future<List<EmojiCategoryMap>> getEmoji() async {
    return await localStorage.getEmoji();
  }
}
