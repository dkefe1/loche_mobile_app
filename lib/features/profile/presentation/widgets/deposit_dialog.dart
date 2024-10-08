import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/phone_textformfield.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/screens/deposit_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/number_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget depositDialog({required TextEditingController depositController, required TextEditingController phoneNumberController, required BuildContext context, required num credit, required bool autoJoin, required bool isPackage}) {

  bool isLoading = false;

  return BlocConsumer<DepositCreditBloc, DepositCreditState>(builder: (_, state){
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                  onTap: (){
                    depositController.clear();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close)),
            ),
            SizedBox(height: 10,),
            Text(
              AppLocalizations.of(context)!.deposit_girum.toUpperCase(),
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            Text(
              AppLocalizations.of(context)!.top_up_your_credit_by_depositing_now,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
            SizedBox(height: 10,),
            phoneTextFormField(
                isEnabled: true,
                controller: phoneNumberController,
                hintText: AppLocalizations.of(context)!.phone_number_g,
                icon: Ph.phone_light, autoFocus: false, onInteraction: (){

            }),
            SizedBox(height: 10,),
            numberTextFormField(controller: depositController, hintText: AppLocalizations.of(context)!.amount_girum, icon: AntDesign.dollar, autoFocus: false, onInteraction: (){}),
            SizedBox(height: 30,),
            isLoading ? loadingButton() : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: (){
                      if(phoneNumberController.text.isEmpty){
                        errorFlashBar(context: context, message: AppLocalizations.of(context)!.value_can_not_be_empty);
                        return;
                      }
                      if(phoneNumberController.text.length != 9 ){
                        errorFlashBar(context: context, message: AppLocalizations.of(context)!.please_enter_a_valid_phone_number);
                        return;
                      }
                      if(depositController.text.isEmpty){
                        errorFlashBar(context: context, message: AppLocalizations.of(context)!.value_can_not_be_empty);
                        return;
                      }
                      if((num.parse(depositController.text) + credit) < 45){
                        errorFlashBar(context: context, message: "You need at least collection of 45 coin in your app credit");
                        return;
                      }
                      final depositCredit = BlocProvider.of<DepositCreditBloc>(context);
                      depositCredit.add(PostDepositCreditEvent(num.parse(depositController.text), "0${phoneNumberController.text}", autoJoin, isPackage, null, false));
                    },
                    child: Text(AppLocalizations.of(context)!.deposit_deposit_modal_g, style: TextStyle(color: Colors.white),))),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }, listener: (_, state) async {
    isLoading = false;
    if(state is PostDepositCreditLoadingState){
      isLoading = true;
    } else if(state is PostDepositCreditSuccessfulState){
      Navigator.pop(context);
      depositController.clear();
      final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => DepositScreen(checkout_url: state.checkout_url, isPackage: false)));
      print(result);
    } else if(state is PostDepositCreditFailedState){
      errorFlashBar(context: context, message: state.error);
      return;
    }
  });
}