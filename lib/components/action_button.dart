import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function onPressed;
  final Icon icon;

  ActionButton({
    @required this.onPressed,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        NavigationToolbar.kMiddleSpacing / 2,
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: CircleBorder(),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(
              NavigationToolbar.kMiddleSpacing / 2,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
