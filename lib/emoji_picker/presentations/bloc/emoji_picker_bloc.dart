import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_emoji_uc.dart';
import 'emoji_picker_event.dart';
import 'emoji_picker_state.dart';

@Injectable()
class EmojiPickerBloc extends Bloc<EmojiPickerEvent, EmojiPickerState> {
  EmojiPickerBloc({required this.getEmojiUc}) : super(EmojiPickerInitial()) {
    on<GetEmojis>(_getEmojis);
  }

  final GetEmojiUc getEmojiUc;

  void _getEmojis(GetEmojis event, Emitter<EmojiPickerState> emit) async {
    try {
      final emojis = await getEmojiUc.execute();
      emit(EmojiPickerLoadedState(emojis: emojis));
    } catch (e) {
      emit(EmojiPickerFailedState());
    }
  }
}
