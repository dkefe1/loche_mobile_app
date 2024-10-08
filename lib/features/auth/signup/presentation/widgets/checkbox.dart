import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {

  bool isChecked;
  VoidCallback onPressed;
  CheckboxWidget({required this.isChecked, required this.onPressed});

  @override
  State<CheckboxWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return primaryColor;
      }
      return primaryColor;
    }

    return Checkbox(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkColor: onPrimaryColor,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.isChecked,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5)
      ),
      onChanged: (bool? value) {
        setState(() {
          widget.isChecked = value!;
          widget.onPressed();
        });
      },
    );
  }
}