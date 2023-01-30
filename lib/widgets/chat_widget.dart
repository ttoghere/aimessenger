// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aimessenger/widgets/widgets.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:aimessenger/constants.dart';
import 'package:aimessenger/service/assets_manager.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({
    Key? key,
    required this.msg,
    required this.chatIndex,
  }) : super(key: key);
  final String msg;
  final int chatIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: chatIndex == 0 ? scaffoldBackgroundColor : cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                specificIMG(),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? TextWidget(label: msg)
                      : DefaultTextStyle(
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          child: AnimatedTextKit(
                            isRepeatingAnimation: false,
                            repeatForever: false,
                            displayFullTextOnTap: true,
                            totalRepeatCount: 1,
                            animatedTexts: [
                              TyperAnimatedText(
                                msg.trim(),
                              ),
                            ],
                          ),
                        ),
                ),
                chatIndex == 0 ? const SizedBox.shrink() : voteIcons(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Image specificIMG() {
    return Image.asset(
      chatIndex == 0 ? AssetsManager.userImage : AssetsManager.botImage,
      width: 30,
    );
  }

  Row voteIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.thumb_up_alt_outlined,
          color: Colors.white,
        ),
        SizedBox(
          width: 8,
        ),
        Icon(
          Icons.thumb_down_alt_outlined,
          color: Colors.white,
        ),
      ],
    );
  }
}
