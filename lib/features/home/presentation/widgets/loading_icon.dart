import 'package:flutter/material.dart';

class LoadingIcon extends StatefulWidget {
  @override
  _LoadingIconState createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(); // The repeat method ensures continuous rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: RotationTransition(
          turns: _controller,
          child: Image.asset(
            "images/loading.png",
            fit: BoxFit.fill,
            width: 70,
            height: 70,
          ),
        ),
    );
  }
}