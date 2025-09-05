import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/font_family.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color titleBgColor;
  final bool alingment;
  final Color chatColor;
  final Color textColor;
  final String adTitle;
  const ChatBubble(
      {super.key,
        required this.message,
        required this.alingment,
        required this.chatColor,
        required this.textColor, required this.adTitle, required this.titleBgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(alingment ? 0 : 12),
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomRight: Radius.circular(alingment ? 12 : 0)),
        color: chatColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          adTitle.isNotEmpty ? Container(
            decoration: BoxDecoration(
              color: titleBgColor,
              borderRadius: const BorderRadius.all(Radius.circular(8))
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You",
                  style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontFamily: FontFamily.gilroyBold),
                ),
                Text(
                  adTitle,
                  style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontFamily: FontFamily.gilroyMedium),
                ),
              ],
            ),
          ) : const SizedBox(),
          SizedBox(height: adTitle.isNotEmpty ? 5 : 0,),
          Text(
            message,
            style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontFamily: FontFamily.gilroyMedium),
          ),
        ],
      ),
    );
  }
}