import 'package:cached_network_image/cached_network_image.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:flutter/material.dart';

Widget coachWidget({required String imagePath, required String name}) {
  return Container(
    padding: EdgeInsets.only(left: 10),
    color: Color(0xFF1E727E).withOpacity(0.04),
    child: Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              imageUrl: imagePath,
              placeholder: (context, url) => BlinkContainer(width: 50, height: 50, borderRadius: 50),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )),
        SizedBox(width: 10,),
        Text(name, style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),),
      ],
    ),
  );
}