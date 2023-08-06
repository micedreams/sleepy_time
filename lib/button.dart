import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    required this.lable,
    required this.onTap,
    super.key,
  });

  final String lable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            lable,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      );
}
