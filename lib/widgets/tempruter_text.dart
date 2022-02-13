import 'package:flutter/material.dart';

class TempretureText extends StatefulWidget {
  const TempretureText({
    Key? key,
    required this.tempreture,
    this.style,
  }) : super(key: key);

  final int tempreture;
  final TextStyle? style;

  @override
  _TempretureTextState createState() => _TempretureTextState();
}

class _TempretureTextState extends State<TempretureText> {
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: widget.tempreture.toString(),
        children: const [TextSpan(text: "°")],
        style: widget.style,
      ),
    );
  }
}
