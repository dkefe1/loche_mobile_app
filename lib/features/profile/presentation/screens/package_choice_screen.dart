import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/home/presentation/widgets/payment_box.dart';
import 'package:fantasy/features/profile/presentation/screens/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PackageChoiceScreen extends StatefulWidget {

  bool autoJoin;
  String phoneNumber;
  PackageChoiceScreen({Key? key, required this.autoJoin, required this.phoneNumber}) : super(key: key);

  @override
  State<PackageChoiceScreen> createState() => _PackageChoiceScreenState();
}

class _PackageChoiceScreenState extends State<PackageChoiceScreen> {

  bool isAppCredit = false;
  bool isBank = false;
  bool isLoading = false;

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
                title: AppLocalizations.of(context)!.payment,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      AppLocalizations.of(context)!.payment_methods,
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!.choose_your_preferred_payment,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: textColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    paymentBox(
                        title: AppLocalizations.of(context)!.purchase_a_package_with_app_credit,
                        iconHeight: 25,
                        iconWidth: 26.38,
                        icon: "images/credit.png",
                        isSelected: isAppCredit,
                        onPressed: () {
                          setState(() {
                            isAppCredit = true;
                            isBank = false;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    paymentBox(
                        title: AppLocalizations.of(context)!.purchase_a_package_with_bank,
                        iconHeight: 25,
                        iconWidth: 23.68,
                        icon: "images/package.png",
                        isSelected: isBank,
                        onPressed: () {
                          setState(() {
                            isAppCredit = false;
                            isBank = true;
                          });
                        }),
                    SizedBox(height: 40,),
                    isLoading ? loadingButton() : SizedBox(
                        width: double.infinity,
                        child:
                        submitButton(onPressed: () {
                          if(isAppCredit || isBank){
                            if(isBank){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(autoJoin: widget.autoJoin, isAppCredit: false, phoneNumber: widget.phoneNumber,)));
                            } else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(autoJoin: widget.autoJoin, isAppCredit: true, phoneNumber: widget.phoneNumber,)));
                            }
                          } else {
                            errorFlashBar(context: context, message: "Please select one of the payment options");
                            return;
                          }
                        }, text: AppLocalizations.of(context)!.next, disabled: false)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
