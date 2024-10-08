import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({Key? key}) : super(key: key);

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
                title: AppLocalizations.of(context)!.pin_reset_successful,
                desc:
                AppLocalizations.of(context)!.your_password_has_been_changed),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/success.png", fit: BoxFit.fill, width: 80, height: 80,),
                    SizedBox(height: 20,),
                    Text(AppLocalizations.of(context)!.pin_reset_successful, style: TextStyle(color: textBlackColor, fontWeight: FontWeight.w600, fontSize: 14),),
                    SizedBox(height: 10,),
                    Text(AppLocalizations.of(context)!.awesome_pin_reset_successful, textAlign: TextAlign.center, style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 13),),
                    SizedBox(height: 40,),
                    SizedBox(
                        width: double.infinity,
                        child:
                        submitButton(onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInScreen()), (route) => false);
                        }, text: AppLocalizations.of(context)!.go_to_login, disabled: false)),
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
