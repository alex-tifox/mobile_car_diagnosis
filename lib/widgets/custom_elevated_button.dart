import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function(BuildContext context) _onPressed;
  final String _buttonText;

  CustomElevatedButton({
    @required Function(BuildContext context) onPressed,
    @required String buttonText,
  })  : _onPressed = onPressed,
        _buttonText = buttonText;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
          ),
        ),
        onPressed: () => _onPressed(context),
        child: Text(
          _buttonText,
          style: Theme.of(context).primaryTextTheme.button,
        ),
      );
}
