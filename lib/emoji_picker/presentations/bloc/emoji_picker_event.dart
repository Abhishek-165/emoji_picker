import 'package:equatable/equatable.dart';

abstract class EmojiPickerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetEmojis extends EmojiPickerEvent {
  GetEmojis();

  @override
  List<Object> get props => [];
}
