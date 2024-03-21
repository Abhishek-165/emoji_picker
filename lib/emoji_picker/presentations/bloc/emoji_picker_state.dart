import 'package:equatable/equatable.dart';

import '../../data/entity/emoji_model.dart';

abstract class EmojiPickerState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmojiPickerInitial extends EmojiPickerState {
  @override
  List<Object> get props => [];
}

class EmojiPickerFailedState extends EmojiPickerState {
  @override
  List<Object> get props => [];
}

class EmojiPickerLoadedState extends EmojiPickerState {
  EmojiPickerLoadedState({required this.emojis});
  final List<EmojiCategoryMap> emojis;

  @override
  List<Object> get props => [emojis];
}
