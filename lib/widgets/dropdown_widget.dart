import 'package:aimessenger/constants.dart';
import 'package:flutter/material.dart';

class ModelsDropdown extends StatefulWidget {
  const ModelsDropdown({Key? key}) : super(key: key);

  @override
  State<ModelsDropdown> createState() => _ModelsDropdownState();
}

class _ModelsDropdownState extends State<ModelsDropdown> {
  String currentModels = "Model1";
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: scaffoldBackgroundColor,
      value: currentModels,
      items: getModelsItem,
      onChanged: (value) {
        setState(() {
          currentModels = value.toString();
        });
      },
    );
  }
}
