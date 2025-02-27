import 'package:e_mech/style/styling.dart';
import 'package:flutter/material.dart';

class GenderSelection extends StatefulWidget {
  String? selectedGender;

 GenderSelection({required this.selectedGender,super.key});

  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Radio<String>(
              focusColor: Styling.primaryColor,
              value: 'female',
              groupValue: widget.selectedGender,
              onChanged: (value) {
                setState(() {
                  widget.selectedGender = value;
                });
              },
            ),
            const Text('Female'),
          ],
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Radio<String>(
              focusColor: Styling.primaryColor,
              value: 'male',
              groupValue: widget.selectedGender,
              onChanged: (value) {
                setState(() {
                  widget.selectedGender = value;
                });
              },
            ),
            const Text('Male'),
          ],
        ),
      ],
    );
  }
}
