import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/home/presentation/widgets/payment_box.dart';
import 'package:fantasy/features/profile/presentation/screens/package_choice_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/deposit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DepositChoiceScreen extends StatefulWidget {

  TextEditingController depositController, phoneNumberController;
  num credit;
  bool autoJoin;
  DepositChoiceScreen({Key? key, required this.depositController, required this.phoneNumberController, required this.credit, required this.autoJoin}) : super(key: key);

  @override
  State<DepositChoiceScreen> createState() => _DepositChoiceScreenState();
}

class _DepositChoiceScreenState extends State<DepositChoiceScreen> {

  bool isDeposit = false;
  bool isPackage = false;
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
                        title: AppLocalizations.of(context)!.deposit_choice,
                        iconHeight: 25,
                        iconWidth: 26.38,
                        icon: "images/credit.png",
                        isSelected: isDeposit,
                        onPressed: () {
                          setState(() {
                            isDeposit = true;
                            isPackage = false;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    paymentBox(
                        title: AppLocalizations.of(context)!.package,
                        iconHeight: 25,
                        iconWidth: 23.68,
                        icon: "images/package.png",
                        isSelected: isPackage,
                        onPressed: () {
                          setState(() {
                            isDeposit = false;
                            isPackage = true;
                          });
                        }),
                    SizedBox(height: 40,),
                    isLoading ? loadingButton() : SizedBox(
                        width: double.infinity,
                        child:
                        submitButton(onPressed: () {
                          if(isDeposit || isPackage){
                            if(isPackage){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PackageChoiceScreen(autoJoin: widget.autoJoin, phoneNumber: widget.phoneNumberController.text)));
                            } else{
                              showDialog(
                                  barrierDismissible: false,
                                  context: context, builder: (BuildContext context) {
                                return depositDialog(depositController: widget.depositController, phoneNumberController: widget.phoneNumberController, context: context, credit: widget.credit, autoJoin: widget.autoJoin, isPackage: false);
                              });
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
