import 'package:flutter/material.dart';

typedef IntCallback = void Function(int id);

enum SingingCharacter { one, two, three }

class RadioVerticalThree extends StatefulWidget {
  final IntCallback radioValue;
  final int option;
  final List<String> description;

  const RadioVerticalThree({
    Key? key,
    required this.radioValue,
    required this.option,
    required this.description,
  }) : super(key: key);

  @override
  _GroupRadioLinearState createState() => _GroupRadioLinearState();
}

class _GroupRadioLinearState extends State<RadioVerticalThree> {
  late int id;
  @override
  void initState() {
    id = widget.option;
    super.initState();
  }

  TextStyle titleStyle = const TextStyle(
    color: Colors.black,
    fontSize: 18,
  );

  SingingCharacter _character = SingingCharacter.one;
  double tileHeight = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: tileHeight,
          child: RadioListTile<SingingCharacter>(
            title: Text(widget.description[0], style: titleStyle),
            value: SingingCharacter.one,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value!;
                widget.radioValue(1);
              });
            },
          ),
        ),
        SizedBox(
          height: tileHeight,
          child: RadioListTile<SingingCharacter>(
            title: Text(widget.description[1], style: titleStyle),
            value: SingingCharacter.two,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value!;
                widget.radioValue(2);
              });
            },
          ),
        ),
        SizedBox(
          height: tileHeight,
          child: RadioListTile<SingingCharacter>(
            title: Text(widget.description[2], style: titleStyle),
            value: SingingCharacter.three,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(
                () {
                  _character = value!;
                  widget.radioValue(3);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
