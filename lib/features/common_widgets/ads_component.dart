import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdsComponent extends StatefulWidget {

  final List<Advertisement> ads;
  final double height;
  AdsComponent({super.key, required this.ads, required this.height});

  @override
  State<AdsComponent> createState() => _AdsComponentState();
}

class _AdsComponentState extends State<AdsComponent> {

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.ads.isEmpty ? SizedBox() : Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: CarouselSlider.builder(
              itemCount: widget.ads.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () async {
                    if(widget.ads[index].website_url.isEmpty) return;
                    final advertUrl = Uri.parse(widget.ads[index].website_url);
                    if (!await launchUrl(advertUrl, mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $advertUrl');
                    }
                  },
                  child: CachedNetworkImage(
                      width: double.infinity,
                      height: widget.height,
                      fit: BoxFit.fill,
                      imageUrl: widget.ads[index].imagePath,
                      placeholder: (context, url) => BlinkContainer(width: double.infinity, height: widget.height, borderRadius: 0),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                );
              },
              options: CarouselOptions(
                  height: widget.height,
                  viewportFraction: 1,
                  autoPlay: widget.ads.length == 1 ? false : true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }
              )),
        ),
      ],
    );
  }
}