import 'package:fantasy/core/constants.dart';
import 'package:flutter/material.dart';

class BlinkShirt extends StatefulWidget {
  double width, height;
  BlinkShirt({required this.width, required this.height});

  @override
  State<BlinkShirt> createState() => _BlinkShirtState();
}

class _BlinkShirtState extends State<BlinkShirt> with TickerProviderStateMixin{

  late AnimationController _colorAnimationController;
  late Animation _containerAnimationColor;

  @override
  void initState() {
    _colorAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600)
    );

    _containerAnimationColor = ColorTween(
        begin: surfaceColor.withOpacity(0.4),
        end: surfaceColor
    ).animate(_colorAnimationController)..addListener(() {
      setState(() {

      });
    })..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _colorAnimationController.reverse();
      } else if(status == AnimationStatus.dismissed){
        _colorAnimationController.forward();
      }
    });

    _colorAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset("images/kits/jersey.png", color: _containerAnimationColor.value, width: widget.width, height: widget.height,),
        SizedBox(height: 5,),
        Container(width: 60, height: 20, decoration: BoxDecoration(
            color: _containerAnimationColor.value,
          borderRadius: BorderRadius.circular(3)
        ),)
      ],
    );
  }
}