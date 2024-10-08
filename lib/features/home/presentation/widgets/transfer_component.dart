import 'package:flutter/material.dart';

Widget transferComponent({required String key, required String value}) {
  return Row(
    children: [
      Text(key, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),),
      Text(value, style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.w700),),
    ],
  );
}