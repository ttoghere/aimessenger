import 'package:aimessenger/widgets/text_widget.dart';
import 'package:aimessenger/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Services {
  static Future<void> showModalBottomSheetWidget(BuildContext context) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: scaffoldBackgroundColor,
      context: context,
      builder: (context) => Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Flexible(
                  child: TextWidget(
                    label: "Chosen Model:",
                    fontSize: 16,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ModelsDropDownWidget(),
                ),
              ])),
    );
  }
}
