import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/index.dart';
import 'package:fantasy/features/profile/data/models/bank.dart';
import 'package:fantasy/features/profile/data/models/withdraw.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/withdraw_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WithdrawScreen extends StatefulWidget {

  final String amount, toBankOrCredit, fromPrizeOrCommission;

  WithdrawScreen({super.key, required this.amount, required this.toBankOrCredit, required this.fromPrizeOrCommission});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {

  TextEditingController accountNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();

  bool isLoading = false;
  bool isBankEmpty = false;
  bool isAccountNumberEmpty = false;
  bool isAccountNameEmpty = false;
  bool isAmountEmpty = false;

  Bank? bankValue;

  List<Bank> banks = [];

  @override
  void initState() {
    final getBanks = BlocProvider.of<BankBloc>(context);
    getBanks.add(GetBankEvent());
    amountController.text = widget.amount;
    super.initState();
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    amountController.dispose();
    accountNameController.dispose();
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
            AppHeader(title: "", desc: AppLocalizations.of(context)!.withdraw),
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
                  bankValue = null;
                  accountNumberController.clear();
                  accountNameController.clear();
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
    return BlocConsumer<BankBloc, BankState>(
        listener: (_, state){
          if(state is GetBankSuccessfulState){
            banks = state.banks;
          }
        },
        builder: (_, state) {
          if(state is GetBankSuccessfulState) {
            return withdrawBody();
          } else if(state is GetBankLoadingState) {
            return banksLoading();
          } else if(state is GetBankFailedState) {
            return errorView(
                iconPath: state.error == socketErrorMessage
                    ? "images/connection.png"
                    : "images/error.png",
                title: "Ooops!",
                text: state.error,
                onPressed: () {
                  final getBanks = BlocProvider.of<BankBloc>(context);
                  getBanks.add(GetBankEvent());
                });
          } else {
            return SizedBox();
          }
        });
  }

  Widget withdrawBody(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalizations.of(context)!.withdraw,
            style:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(5)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Bank>(
                  value: bankValue,
                  isExpanded: true,
                  hint: Text(
                    AppLocalizations.of(context)!.bank_types,
                    style: TextStyle(
                        color: textColor,
                        fontSize: textFontSize2,
                        fontWeight: FontWeight.w500),
                  ),
                  items: banks.map(buildMenuCategories).toList(),
                  icon: Iconify(
                    MaterialSymbols.arrow_drop_down_rounded,
                    color: primaryColor,
                    size: 30,
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.bankValue = value;
                      isBankEmpty = false;
                    });
                  }),
            ),
          ),
          isBankEmpty
              ? Text(
            AppLocalizations.of(context)!.value_can_not_be_empty,
            style: TextStyle(
                color: dangerColor, fontSize: textFontSize),
          )
              : SizedBox(),
          SizedBox(height: 15,),
          withdrawTextFormField(
              controller: accountNameController,
              hintText: AppLocalizations.of(context)!.account_name,
              icon: Mdi.account,
              autoFocus: false, onInteraction: (){
            setState(() {
              isAccountNameEmpty = false;
            });
          }, isNumber: false),
          isAccountNameEmpty
              ? Text(
            AppLocalizations.of(context)!.value_can_not_be_empty,
            style: TextStyle(
                color: dangerColor, fontSize: textFontSize),
          )
              : SizedBox(),
          SizedBox(
            height: 15,
          ),
          withdrawTextFormField(
              controller: accountNumberController,
              hintText: bankValue == null ? AppLocalizations.of(context)!.account_number : bankValue!.is_mobilemoney == 1 ? "Phone Number" :  "Account Number",
              icon: bankValue == null ? Ph.bank : bankValue!.is_mobilemoney == 1 ? Ic.outline_local_phone :  Ph.bank,
              autoFocus: false, onInteraction: (){
            setState(() {
              isAccountNumberEmpty = false;
            });
          }, isNumber: true),
          isAccountNumberEmpty
              ? Text(
            AppLocalizations.of(context)!.value_can_not_be_empty,
            style: TextStyle(
                color: dangerColor, fontSize: textFontSize),
          )
              : SizedBox(),
          SizedBox(
            height: 15,
          ),
          withdrawTextFormField(
              controller: amountController,
              hintText: AppLocalizations.of(context)!.amount_2,
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
                    if(bankValue == null){
                      return setState(() {
                        isBankEmpty = true;
                      });
                    }
                    if(accountNameController.text.isEmpty){
                      return setState(() {
                        isAccountNameEmpty = true;
                      });
                    }
                    if(accountNumberController.text.isEmpty){
                      return setState(() {
                        isAccountNumberEmpty = true;
                      });
                    }
                    if(amountController.text.isEmpty){
                      return setState(() {
                        isAmountEmpty = true;
                      });
                    }
                    final withdraw = BlocProvider.of<WithdrawBloc>(context);
                    withdraw.add(PostWithdrawEvent(Withdraw(amount: num.parse(amountController.text), account_number: accountNumberController.text, bank_code: bankValue!.id, account_name: accountNameController.text, toBankOrCredit: widget.toBankOrCredit, fromPrizeOrCommission: widget.fromPrizeOrCommission)));
                  },
                  text: AppLocalizations.of(context)!.withdraw_wallet,
                  disabled: false)),
        ],
      ),
    );
  }
  
  Widget banksLoading(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30,),
        BlinkContainer(width: 150, height: 30, borderRadius: 0),
        SizedBox(height: 10,),
        BlinkContainer(width: double.infinity, height: 60, borderRadius: 8),
        SizedBox(height: 10,),
        BlinkContainer(width: double.infinity, height: 60, borderRadius: 8),
        SizedBox(height: 10,),
        BlinkContainer(width: double.infinity, height: 60, borderRadius: 8),
        SizedBox(height: 10,),
        BlinkContainer(width: double.infinity, height: 60, borderRadius: 8),
        SizedBox(height: 50,),
        BlinkContainer(width: double.infinity, height: 60, borderRadius: 15)
      ],
    );
  }

  DropdownMenuItem<Bank> buildMenuCategories(Bank bank) => DropdownMenuItem(
      value: bank,
      child: Text(
        bank.name,
        style: TextStyle(
            color: primaryColor,
            fontSize: textFontSize2,
            fontWeight: FontWeight.w500),
      ));
}
