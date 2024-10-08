import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/client_transaction.dart';
import 'package:fantasy/features/profile/data/models/transaction_history.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/widgets/no_data_img.dart';
import 'package:fantasy/features/profile/presentation/widgets/transaction_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ant_design.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionHistoryScreen extends StatefulWidget {

  String fullname;

  TransactionHistoryScreen({super.key, required this.fullname});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {

  final prefs = PrefService();
  int page = 1;

  List<TransactionHistory> allTransactions = [];
  bool isLoading = false;
  bool isFull = false;

  @override
  void initState() {
    final transactionHistory =
    BlocProvider.of<TransactionsHistoryBloc>(context);
    transactionHistory.add(GetTransactionsHistoryEvent(page.toString()));
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
            AppHeader(title: "", desc: AppLocalizations.of(context)!.transaction_g),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: BlocConsumer<TransactionsHistoryBloc, TransactionsHistoryState>(
                      listener: (_, state) async {
                        if(state is GetTransactionsHistoryFailedState){
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
                        } else if(state is GetTransactionsHistorySuccessfulState) {
                          allTransactions.addAll(state.transactions);
                          isLoading = false;
                          if(state.transactions.length < 10){
                            isFull = true;
                          }
                          setState(() {});
                        }
                      },
                      builder: (_, state) {
                        if (state is GetTransactionsHistorySuccessfulState) {
                          return allTransactions.isEmpty ? Center(child: noDataImageWidget(icon: "images/no_trans.png", message: "You have not yet made any transactions!", iconWidth: 120, iconHeight: 120, iconColor: textColor)) : buildInitialInput();
                        } else if (state is GetTransactionsHistoryLoadingState) {
                          return allTransactions.isEmpty ? transactionLoading() : buildInitialInput();
                        } else if (state is GetTransactionsHistoryFailedState) {
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
                                  BlocProvider.of<TransactionsHistoryBloc>(context);
                                  transactionHistory.add(GetTransactionsHistoryEvent(page.toString()));
                                }),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Transactions by ${widget.fullname}",
            style:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
          ),
          SizedBox(height: 10,),
          Divider(
            color: dividerColor,
            thickness: 1.0,
          ),
          SizedBox(height: 10,),
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: allTransactions.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return transactionComponent(context: context, clientTransaction: ClientTransaction(id: allTransactions[index].id, client_id: allTransactions[index].client_id, transactionType: allTransactions[index].transactionType, amount: allTransactions[index].amount, createdAt: allTransactions[index].createdAt, updatedAt: allTransactions[index].updatedAt));
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
                BlocProvider.of<TransactionsHistoryBloc>(context);
                transactionHistory.add(GetTransactionsHistoryEvent(page.toString()));
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
          SizedBox(height: 30,)
        ],
      ),
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
