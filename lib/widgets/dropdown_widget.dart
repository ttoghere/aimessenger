import 'package:aimessenger/providers/models_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../constants.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({Key? key}) : super(key: key);

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  String? currentModels;
  @override
  Widget build(BuildContext context) {
    currentModels = context.read<ModelsProvider>().getCurrentModel;
    return DropdownButton(
      dropdownColor: scaffoldBackgroundColor,
      iconEnabledColor: Colors.white,
      items: getModelsItem,
      value: currentModels,
      onChanged: (value) {
        setState(() {
          currentModels = value.toString();
        });
      },
    );
  }
}