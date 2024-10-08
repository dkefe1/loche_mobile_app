import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/agent_transaction.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/screens/payment_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/withdraw_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/agent_transaction_component.dart';
import 'package:fantasy/features/profile/presentation/widgets/no_data_img.dart';
import 'package:fantasy/features/profile/presentation/widgets/wallet_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletScreen extends StatefulWidget {

  final Profile profile;

  WalletScreen({super.key, required this.profile});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final prefs = PrefService();
  int page = 1;

  List<AgentTransaction> allTransactions = [];
  bool isLoading = false;
  bool isFull = false;

  @override
  void initState() {
    final transactionHistory =
    BlocProvider.of<AgentTransactionsHistoryBloc>(context);
    transactionHistory.add(GetAgentTransactionsHistoryEvent(page.toString(), widget.profile.id));
    super.initState();
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
          children: [
            AppHeader(
                title: "",
                desc:
                AppLocalizations.of(context)!.wallet),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(child: walletBox(value: widget.profile.earned_commission.toString(), type: AppLocalizations.of(context)!.earned_g)),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(child: walletBox(value: widget.profile.commission_balance.toString(), type: AppLocalizations.of(context)!.available_g)),
                          ],
                        ),
                        SizedBox(height: 10,),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(withdrawalType: "Commission Withdrawal", amount: widget.profile.commission_balance.toString(), fromPrizeOrCommission: "Commission",)));
                              },
                              child: Text(
                                AppLocalizations.of(context)!.withdraw_g,
                                style: TextStyle(color: onPrimaryColor, fontSize: 20),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: dividerColor,
                          thickness: 1.0,
                        ),
                        SizedBox(height: 10,),
                        Text(
                          AppLocalizations.of(context)!.commission_history_g.toUpperCase(),
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        Divider(
                          color: dividerColor,
                          thickness: 1.0,
                        ),
                        BlocConsumer<AgentTransactionsHistoryBloc, AgentTransactionsHistoryState>(
                            listener: (_, state) async {
                              if(state is GetAgentTransactionsHistoryFailedState){
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
                              } else if(state is GetAgentTransactionsHistorySuccessfulState) {
                                allTransactions.addAll(state.transactions);
                                isLoading = false;
                                if(state.transactions.length < 10){
                                  isFull = true;
                                }
                                setState(() {});
                              }
                            },
                            builder: (_, state) {
                              if (state is GetAgentTransactionsHistorySuccessfulState) {
                                return allTransactions.isEmpty ? Center(child: noDataImageWidget(icon: "images/no_trans.png", message: AppLocalizations.of(context)!.you_have_not_yet_made_any_commissions, iconWidth: 120, iconHeight: 120, iconColor: textColor)) : buildInitialInput();
                              } else if (state is GetAgentTransactionsHistoryLoadingState) {
                                return allTransactions.isEmpty ? transactionLoading() : buildInitialInput();
                              } else if (state is GetAgentTransactionsHistoryFailedState) {
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
                                        final transactionHistory =
                                        BlocProvider.of<AgentTransactionsHistoryBloc>(context);
                                        transactionHistory.add(GetAgentTransactionsHistoryEvent(page.toString(), widget.profile.id));
                                      }),
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                        SizedBox(height: 30,)
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: allTransactions.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return agentTransactionComponent(agentTransaction: allTransactions[index]);
            }),
        SizedBox(height: 5,),
        isFull ? SizedBox() : allTransactions.length < 10 ? SizedBox() : isLoading ? Center(
          child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: primaryColor, strokeWidth: 2,)),
        ) : Center(
          child: GestureDetector(
            onTap: (){
              setState(() {
                isLoading = true;
              });
              page += 1;
              final transactionHistory =
              BlocProvider.of<AgentTransactionsHistoryBloc>(context);
              transactionHistory.add(GetAgentTransactionsHistoryEvent(page.toString(), widget.profile.id));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Iconify(Mdi.reload, color: primaryColor, size: 16,),
                SizedBox(width: 5,),
                Text("More", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget transactionLoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          BlinkContainer(width: 250, height: 20, borderRadius: 0),
          SizedBox(height: 10,),
          Divider(color: dividerColor, thickness: 1.0,),
          SizedBox(height: 10,),
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 8,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlinkContainer(width: 150, height: 25, borderRadius: 0),
                          BlinkContainer(width: 150, height: 25, borderRadius: 0),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlinkContainer(width: 150, height: 25, borderRadius: 0),
                          BlinkContainer(width: 150, height: 25, borderRadius: 0),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(color: dividerColor, thickness: 1.0,)
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}
