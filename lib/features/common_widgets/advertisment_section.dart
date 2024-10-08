import 'package:carousel_slider/carousel_slider.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/advert_indicator.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvertisementSection extends StatefulWidget {
  String adPackage;
  AdvertisementSection({Key? key, required this.adPackage}) : super(key: key);

  @override
  State<AdvertisementSection> createState() => _AdvertisementSectionState();
}

class _AdvertisementSectionState extends State<AdvertisementSection> {

  int activeIndex = 0;

  @override
  void initState() {
    final getAds =
    BlocProvider.of<AdvertisementBloc>(context);
    getAds.add(GetAdvertisementEvent(widget.adPackage));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementBloc, AdvertisementState>(builder: (_, state) {
      if (state is GetAdvertisementSuccessfulState) {
        return buildInitialInput(ads: state.content);
      } else if (state is GetAdvertisementLoadingState) {
        return adsLoading();
      } else if (state is GetAdvertisementFailedState) {
        return adsFailed(title: "Ooops!", text: state.error, onPressed: (){
          final getAds =
          BlocProvider.of<AdvertisementBloc>(context);
          getAds.add(GetAdvertisementEvent(widget.adPackage));
        });
      } else {
        return SizedBox();
      }
    });
  }

  Widget buildInitialInput({required List<Advertisement> ads}) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(advContainerRadius),
          child: CarouselSlider.builder(
              itemCount: ads.length,
              itemBuilder: (context, index, realIndex) {
                return GestureDetector(
                  onTap: () async {
                    if(ads[index].website_url.isEmpty) return;
                    final advertUrl = Uri.parse(ads[index].website_url);
                    if (!await launchUrl(advertUrl, mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $advertUrl');
                    }
                  },
                  child: Image.network(
                    ads[index].imagePath,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: 140,
                  ),
                );
              },
              options: CarouselOptions(
                  height: 140,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }
              )),
        ),
        SizedBox(height: 10,),
        Center(child: advIndicator(activeIndex: activeIndex, count: ads.length)),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget adsLoading() {
    return Column(
      children: [
        BlinkContainer(width: double.infinity, height: 140, borderRadius: advContainerRadius),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlinkContainer(width: 15, height: 15, borderRadius: 40),
            SizedBox(width: 5,),
            BlinkContainer(width: 15, height: 15, borderRadius: 40),
            SizedBox(width: 5,),
            BlinkContainer(width: 15, height: 15, borderRadius: 40),
          ],
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget adsFailed({required String title, required String text, required VoidCallback onPressed}) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightPrimary,
        borderRadius: BorderRadius.circular(advContainerRadius)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, textAlign: TextAlign.center, style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.w700),),
          SizedBox(height: 10,),
          Text(text, textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF000000).withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w400),),
          SizedBox(height: 10,),
          GestureDetector(
              onTap: (){
                onPressed();
              },
              child: Iconify(Mdi.reload, color: primaryColor, size: 30,))
        ],
      ),
    );
  }
}
