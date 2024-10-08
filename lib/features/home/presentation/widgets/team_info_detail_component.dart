import 'package:cached_network_image/cached_network_image.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:flutter/material.dart';

Widget teamInfoDetailComponent(
    {required String key, required String value, required String iconImage, required bool isNetwork}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
    decoration: BoxDecoration(
        color: Color(0xFF1E727E).withOpacity(0.04),
        borderRadius: BorderRadius.circular(5)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Text(
              key,
              style: TextStyle(
                  fontWeight: FontWeight.w400, fontSize: 12, color: textColor),
            )),
        Expanded(
          child: Row(
            children: [
              // isNetwork ? CachedNetworkImage(
              //   width: 25,
              //   height: 25,
              //   fit: BoxFit.fill,
              //   imageUrl: iconImage,
              //   placeholder: (context, url) => BlinkContainer(width: 25, height: 25, borderRadius: 10),
              //   errorWidget: (context, url, error) => Icon(Icons.error),
              // ) : Image.asset(
              //   iconImage,
              //   fit: BoxFit.fill,
              //   width: 25,
              //   height: 25,
              // ),
              // SizedBox(
              //   width: 10,
              // ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: textBlackColor),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
