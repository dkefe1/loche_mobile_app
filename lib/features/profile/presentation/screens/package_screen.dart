import 'package:carousel_slider/carousel_slider.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/phone_textformfield.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/profile/data/models/package.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/package_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PackageScreen extends StatefulWidget {

  final bool autoJoin, isAppCredit;
  String phoneNumber;
  PackageScreen({Key? key, required this.autoJoin, required this.isAppCredit, required this.phoneNumber}) : super(key: key);

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {

  final prefs = PrefService();

  TextEditingController phoneController = TextEditingController();

  bool isPhoneNumberEmpty = false;
  bool isPhoneNumberInValid = false;

  @override
  void initState() {
    final packages =
    BlocProvider.of<PackagesBloc>(context);
    packages.add(GetPackagesEvent());
    phoneController.text = widget.phoneNumber;
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appHeader2(
                title: AppLocalizations.of(context)!.package,
                desc: AppLocalizations.of(context)!.make_a_payment_and_dive),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(defaultBorderRadius))),
                child: BlocConsumer<PackagesBloc, PackagesState>(
                    listener: (_, state) async {
                      if(state is GetPackagesFailedState){
                        if(state.error == jwtExpired || state.error == doesNotExist){
                          await prefs.signout();
                          await prefs.removeToken();
                          await prefs.removeCreatedTeam();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                                  (route) => false);
                        }
                      } else if(state is GetPackagesSuccessfulState) {
                      }
                    },
                    builder: (_, state) {
                      if (state is GetPackagesSuccessfulState) {
                        return buildInitialInput(packages: state.packages);
                      } else if (state is GetPackagesLoadingState) {
                        return packagesLoading();
                      } else if (state is GetPackagesFailedState) {
                        if(state.error == pinChangedMessage){
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 60.0),
                            child: pinChangedErrorView(
                                iconPath: state.error == socketErrorMessage
                                    ? "images/connection.png"
                                    : "images/error.png",
                                title: "Ooops!",
                                text: state.error,
                                onPressed: () async {
                                  await prefs.signout();
                                  await prefs.removeToken();
                                  await prefs.removeCreatedTeam();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignInScreen()),
                                          (route) => false);
                                }),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 60.0),
                          child: errorView(
                              iconPath: state.error == socketErrorMessage
                                  ? "images/connection.png"
                                  : "images/error.png",
                              title: "Ooops!",
                              text: state.error,
                              onPressed: () {
                                final packages =
                                BlocProvider.of<PackagesBloc>(context);
                                packages.add(GetPackagesEvent());
                              }),
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput({required List<PackageModel> packages}){
    return packages.isEmpty ? Center(child: noDataWidget(icon: Ph.package, message: "Package not available", iconSize: 120, iconColor: textColor)) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 35,
        ),
        Text(
          AppLocalizations.of(context)!.we_offer_different_packages,
          style:
          TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.choose_your_preferred_package,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: textColor),
        ),
        SizedBox(height: 30,),
        widget.isAppCredit ? SizedBox() : phoneTextFormField(
            isEnabled: true,
            controller: phoneController,
            hintText: AppLocalizations.of(context)!.phone_number,
            icon: Ph.phone_light, autoFocus: false, onInteraction: (){
          setState(() {
            isPhoneNumberEmpty = false;
          });
        }),
        widget.isAppCredit ? SizedBox() : isPhoneNumberEmpty
            ? Text(
          AppLocalizations.of(context)!.value_can_not_be_empty,
          style: TextStyle(
              color: dangerColor, fontSize: textFontSize),
        )
            : SizedBox(),
        widget.isAppCredit ? SizedBox() : isPhoneNumberInValid
            ? Text(
          AppLocalizations.of(context)!.please_enter_a_valid_phone_number,
          style: TextStyle(
              color: dangerColor, fontSize: textFontSize),
        )
            : SizedBox(),
        widget.isAppCredit ? SizedBox() : SizedBox(
          height: 20,
        ),
        CarouselSlider.builder(
            itemCount: packages.length,
            itemBuilder: (context, index, realIndex) {
              return packageWidget(package: packages[index], context: context, autoJoin: widget.autoJoin, isAppCredit: widget.isAppCredit, phoneNumber: phoneController.text, onPressed: () async {
                if(!widget.isAppCredit){
                  if(phoneController.text.isEmpty){
                    setState(() {
                      isPhoneNumberEmpty = true;
                    });
                    return false;
                  }
                  if(phoneController.text.length != 9){
                    setState(() {
                      isPhoneNumberInValid = true;
                    });
                    return false;
                  } else {
                    setState(() {
                      isPhoneNumberInValid = false;
                    });
                  }
                }
              });
            },
            options: CarouselOptions(
              height: 330,
                reverse: true,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height
            ))
      ],
    );
  }

  Widget packagesLoading(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 35,
        ),
        BlinkContainer(width: 200, height: 25, borderRadius: 0),
        SizedBox(height: 10,),
        BlinkContainer(width: double.infinity, height: 25, borderRadius: 0),
        SizedBox(height: 5,),
        BlinkContainer(width: 200, height: 25, borderRadius: 0),
        SizedBox(height: 30,),
        CarouselSlider.builder(
            itemCount: 3,
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: BlinkContainer(width: double.infinity, height: 300, borderRadius: 20),
              );
            },
            options: CarouselOptions(
              height: 350,
                reverse: true,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height
            ))
      ],
    );
  }

}
