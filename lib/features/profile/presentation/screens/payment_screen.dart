import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/screens/payment_sucess_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/home/presentation/widgets/payment_box.dart';
import 'package:fantasy/features/profile/presentation/screens/app_credit_withdrawal_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentScreen extends StatefulWidget {

  final String withdrawalType, amount, fromPrizeOrCommission;
  PaymentScreen({Key? key, required this.withdrawalType, required this.amount, required this.fromPrizeOrCommission}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  bool isToAppCredit = false;
  bool isToBank = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<JoinGameWeekTeamBloc, JoinGameWeekTeamState>(builder: (_, state){
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              appHeader2(
                  title: AppLocalizations.of(context)!.withdraw,
                  desc:
                  AppLocalizations.of(context)!.commission_withdrawal),
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
                        AppLocalizations.of(context)!.commission_withdrawal,
                        style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.choose_your_preferred_withdrawal_method,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: textColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      paymentBox(
                          title: AppLocalizations.of(context)!.to_app_credit,
                          iconHeight: 25,
                          iconWidth: 26.38,
                          icon: "images/credit.png",
                          isSelected: isToAppCredit,
                          onPressed: () {
                            setState(() {
                              isToAppCredit = true;
                              isToBank = false;
                            });
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      paymentBox(
                          title: AppLocalizations.of(context)!.to_bank,
                          iconHeight: 18.71,
                          iconWidth: 29,
                          icon: "images/chapa.png",
                          isSelected: isToBank,
                          onPressed: () {
                            setState(() {
                              isToAppCredit = false;
                              isToBank = true;
                            });
                          }),
                      SizedBox(height: 40,),
                      isLoading ? loadingButton() : SizedBox(
                          width: double.infinity,
                          child:
                          submitButton(onPressed: () {
                            if(isToAppCredit || isToBank){
                              if(isToBank){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawScreen(amount: widget.amount, fromPrizeOrCommission: widget.fromPrizeOrCommission, toBankOrCredit: "Bank",)));
                              } else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AppCreditWithdrawalScreen(amount: widget.amount, fromPrizeOrCommission: widget.fromPrizeOrCommission, toBankOrCredit: "Credit",)));
                              }
                            } else {
                              errorFlashBar(context: context, message: "Please select one of the withdrawal options");
                              return;
                            }
                          }, text: AppLocalizations.of(context)!.next_g, disabled: false)),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }, listener: (_, state){
        isLoading = false;
        if(state is PostJoinGameWeekTeamLoadingState){
          isLoading = true;
        } else if(state is PostJoinGameWeekTeamSuccessfulState){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));
        } else if(state is PostJoinGameWeekTeamFailedState){
          errorFlashBar(context: context, message: state.error);
        }
      }),
    );
  }
}
