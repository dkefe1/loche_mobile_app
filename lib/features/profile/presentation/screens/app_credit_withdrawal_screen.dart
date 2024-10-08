import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/index.dart';
import 'package:fantasy/features/profile/data/models/withdraw.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/withdraw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppCreditWithdrawalScreen extends StatefulWidget {

  final String amount, toBankOrCredit, fromPrizeOrCommission;
  AppCreditWithdrawalScreen({super.key, required this.amount, required this.toBankOrCredit, required this.fromPrizeOrCommission});

  @override
  State<AppCreditWithdrawalScreen> createState() => _AppCreditWithdrawalScreenState();
}

class _AppCreditWithdrawalScreenState extends State<AppCreditWithdrawalScreen> {

  TextEditingController amountController = TextEditingController();

  bool isAmountEmpty = false;
  bool isLoading = false;

  @override
  void initState() {
    amountController.text = widget.amount;
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            AppHeader(title: "", desc: AppLocalizations.of(context)!.withdraw_g),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: BlocConsumer<WithdrawBloc, WithdrawState>(
                      builder: (_, state) {
                        return buildInitialInput();
                      }, listener: (_, state) {
                    isLoading = false;
                    if (state is PostWithdrawLoadingState) {
                      isLoading = true;
                    } else if (state is PostWithdrawSuccessfulState) {
                      amountController.clear();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 2)), (route) => false);
                    } else if (state is PostWithdrawFailedState) {
                      errorFlashBar(context: context, message: state.error);
                    }
                  }),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalizations.of(context)!.withdraw_g,
            style:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
          ),
          SizedBox(
            height: 10,
          ),
          withdrawTextFormField(
              controller: amountController,
              hintText: AppLocalizations.of(context)!.amount_girum,
              icon: AntDesign.dollar,
              autoFocus: false, onInteraction: (){
            setState(() {
              isAmountEmpty = false;
            });
          }, isNumber: true),
          isAmountEmpty
              ? Text(
            AppLocalizations.of(context)!.value_can_not_be_empty,
            style: TextStyle(
                color: dangerColor, fontSize: textFontSize),
          )
              : SizedBox(),
          SizedBox(
            height: 70,
          ),
          isLoading
              ? loadingButton()
              : SizedBox(
              width: double.infinity,
              child: submitButton(
                  onPressed: () {
                    if(amountController.text.isEmpty){
                      return setState(() {
                        isAmountEmpty = true;
                      });
                    }
                    final withdraw = BlocProvider.of<WithdrawBloc>(context);
                    withdraw.add(PostWithdrawEvent(Withdraw(amount: num.parse(amountController.text), toBankOrCredit: widget.toBankOrCredit, fromPrizeOrCommission: widget.fromPrizeOrCommission)));
                  },
                  text: AppLocalizations.of(context)!.withdraw_wallet,
                  disabled: false)),
        ],
      ),
    );
  }

}
