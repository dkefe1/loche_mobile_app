import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/phone_textformfield.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/screens/transfer_successful_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/number_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget transferDialog({required TextEditingController transferController, required TextEditingController toPhoneNumberController, required BuildContext context, required num credit}) {

  bool isLoading = false;

  return BlocConsumer<TransferCreditBloc, TransferCreditState>(builder: (_, state){
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
                    transferController.clear();
                    toPhoneNumberController.clear();
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close)),
            ),
            SizedBox(height: 10,),
            Text(
              AppLocalizations.of(context)!.transfer_g.toUpperCase(),
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            Text(
              AppLocalizations.of(context)!.transfer_your_credit_to_other_account,
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
            SizedBox(height: 10,),
            phoneTextFormField(
                isEnabled: true,
                controller: toPhoneNumberController,
                hintText: AppLocalizations.of(context)!.phone_number_g,
                icon: Ph.phone_light, autoFocus: false, onInteraction: (){

            }),
            SizedBox(height: 10,),
            numberTextFormField(controller: transferController, hintText: AppLocalizations.of(context)!.amount_g, icon: AntDesign.dollar, iconPath: "images/no_trans.png", autoFocus: false, onInteraction: (){}),
            SizedBox(height: 30,),
            isLoading ? loadingButton() : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: (){
                      if(toPhoneNumberController.text.isEmpty){
                        errorFlashBar(context: context, message: AppLocalizations.of(context)!.value_can_not_be_empty);
                        return;
                      }
                      if(toPhoneNumberController.text.length != 9 ){
                        errorFlashBar(context: context, message: AppLocalizations.of(context)!.please_enter_a_valid_phone_number);
                        return;
                      }
                      if(transferController.text.isEmpty){
                        errorFlashBar(context: context, message: AppLocalizations.of(context)!.value_can_not_be_empty);
                        return;
                      }
                      if(num.parse(transferController.text) < 1){
                        errorFlashBar(context: context, message: "Amount can not be less than 1");
                        return;
                      }
                      if(num.parse(transferController.text) > credit){
                        errorFlashBar(context: context, message: AppLocalizations.of(context)!.insufficient_balance);
                        return;
                      }
                      final transferCredit = BlocProvider.of<TransferCreditBloc>(context);
                      transferCredit.add(PostTransferCreditEvent(num.parse(transferController.text), "+251${toPhoneNumberController.text}"));
                    },
                    child: Text(AppLocalizations.of(context)!.transfer_button, style: TextStyle(color: Colors.white),))),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }, listener: (_, state) async {
    isLoading = false;
    if(state is PostTransferCreditLoadingState){
      isLoading = true;
    } else if(state is PostTransferCreditSuccessfulState){
      Navigator.pop(context);
      transferController.clear();
      toPhoneNumberController.clear();
      Navigator.push(context, MaterialPageRoute(builder: (context) => TransferSuccessfulScreen()));
    } else if(state is PostTransferCreditFailedState){
      errorFlashBar(context: context, message: state.error);
      return;
    }
  });
}