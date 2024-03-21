import 'package:emoji_picker/emoji_picker/data/entity/emoji_model.dart';
import 'package:emoji_picker/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/di.dart';
import '../../../core/shared_preferences.dart';
import '../bloc/emoji_picker_bloc.dart';
import '../bloc/emoji_picker_event.dart';
import '../bloc/emoji_picker_state.dart';

class ShowBottomSheet extends StatelessWidget {
  const ShowBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: TextButton(
          onPressed: () {
            showModalBottomSheet(
                context: context, builder: (context) => const EmojiPicker());
          },
          child: const Text('Show Emoji')),
    ));
  }
}

class EmojiPicker extends StatefulWidget {
  const EmojiPicker({super.key});

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  late PageController _pageController;

  late EmojiPickerBloc _emojiPickerBloc;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _emojiPickerBloc = getIt<EmojiPickerBloc>();
    _emojiPickerBloc.add(GetEmojis());
  }

  ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<EmojiPickerBloc, EmojiPickerState>(
      bloc: _emojiPickerBloc,
      listener: (BuildContext context, state) {},
      builder: (context, state) {
        if (state is EmojiPickerLoadedState) {
          List<EmojiCategoryMap> emojiModel = state.emojis;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 45,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const ScrollPhysics(),
                    itemCount: emojiModel.length,
                    shrinkWrap: true,
                    itemBuilder: (context, parentCategoryIndex) {
                      return GestureDetector(
                        onTap: () {
                          pageIndex.value = parentCategoryIndex;
                          _pageController.animateToPage(parentCategoryIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 8.0, top: 4),
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                emojiModel[parentCategoryIndex]
                                    .subCategories
                                    .first
                                    .values
                                    .first
                                    .first
                                    .character,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              ValueListenableBuilder(
                                  valueListenable: pageIndex,
                                  builder: (conext, newPageIndex, _) {
                                    return newPageIndex == parentCategoryIndex
                                        ? Container(
                                            width: 20,
                                            height: 2,
                                            decoration: const BoxDecoration(
                                                color: Colors.black),
                                          )
                                        : const SizedBox(
                                            height: 2,
                                          );
                                  })
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              const Divider(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    pageIndex.value = index;
                  },
                  children: List.generate(
                      emojiModel.length,
                      (parentCategoryIndex) => ListView.builder(
                          itemCount: emojiModel[parentCategoryIndex]
                              .subCategories
                              .length,
                          itemBuilder: (context, index) {
                            if (emojiModel[parentCategoryIndex]
                                .subCategories
                                .isNotEmpty) {
                              return ShowEmoji(
                                emojiCategory: emojiModel[parentCategoryIndex]
                                    .subCategories[index],
                              );
                            }
                            return const SizedBox.shrink();
                          })),
                ),
              ),
            ],
          );
        } else if (state is EmojiPickerFailedState) {
          return Center(
            child: TextButton(
                onPressed: () {
                  _emojiPickerBloc.add(GetEmojis());
                },
                child: const Text('Retry')),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}

class ShowEmoji extends StatelessWidget {
  const ShowEmoji({
    super.key,
    required this.emojiCategory,
  });

  final Map<String, List<Emoji>> emojiCategory;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emojiCategory.keys.first.refactorWithCapitalization(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Wrap(
            children: List.generate(
                emojiCategory.values.first.length,
                (index) => GestureDetector(
                      onTap: () async {
                        try {
                          // get the previous stored emoji
                          List<Emoji> emojis =
                              await SharedPreferencesEmoji.instance.getEmoji();
                          // avoid duplicates
                          if (emojis
                              .contains(emojiCategory.values.first[index])) {
                            emojis.remove(emojiCategory.values.first[index]);
                          }
                          //and add the current emoji

                          SharedPreferencesEmoji.instance.saveEmoji(
                              emojis + [emojiCategory.values.first[index]]);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          emojiCategory.values.first[index].character,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    )),
          )
        ],
      ),
    );
  }
}
