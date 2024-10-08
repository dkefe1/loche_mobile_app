import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/data/models/transfer_history.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/home/presentation/widgets/transfer_history_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class TransferHistoryScreen extends StatefulWidget {
  const TransferHistoryScreen({super.key});

  @override
  State<TransferHistoryScreen> createState() => _TransferHistoryScreenState();
}

class _TransferHistoryScreenState extends State<TransferHistoryScreen> {

  final prefs = PrefService();

  int page = 1;

  List<TransferHistory> transferHistory = [];
  bool isLoading = false;
  bool isFull = false;

  @override
  void initState() {
    final transferHistory = BlocProvider.of<TransferHistoryBloc>(context);
    transferHistory.add(GetTransferHistoryEvent(page.toString()));
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
            AppHeader(title: "", desc: "Transfer History"),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: BlocConsumer<TransferHistoryBloc, TransferHistoryState>(
                      listener: (_, state) async {
                        if(state is GetTransferHistoryFailedState){
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
                        } else if(state is GetTransferHistorySuccessfulState) {
                          transferHistory.addAll(state.content);
                          isLoading = false;
                          if(state.content.length < 10){
                            isFull = true;
                          }
                          setState(() {});
                        }
                      },
                      builder: (_, state) {
                        if (state is GetTransferHistorySuccessfulState) {
                          return transferHistory.isEmpty ? Center(child: noDataWidget(icon: Mdi.history, message: "You have not yet transferred a player", iconSize: 120, iconColor: textColor)) : buildInitialInput();
                        } else if (state is GetTransferHistoryLoadingState) {
                          return transferHistory.isEmpty ? transfersLoading() : buildInitialInput();
                        } else if (state is GetTransferHistoryFailedState) {
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
                                  final transferHistory =
                                  BlocProvider.of<TransferHistoryBloc>(context);
                                  transferHistory.add(GetTransferHistoryEvent(page.toString()));
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
            "Transfer History",
            style:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: transferHistory.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return transferHistoryBox(transferHistory: transferHistory[index]);
              }),
          SizedBox(height: 5,),
          isFull ? SizedBox() : transferHistory.length < 10 ? SizedBox() : isLoading ? Center(
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
                final transferHistory = BlocProvider.of<TransferHistoryBloc>(context);
                transferHistory.add(GetTransferHistoryEvent(page.toString()));
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

  Widget transfersLoading() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          BlinkContainer(width: 100, height: 30, borderRadius: 0),
          SizedBox(height: 10,),
          ListView.builder(
            padding: EdgeInsets.zero,
              itemCount: 8,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: BlinkContainer(width: double.infinity, height: 300, borderRadius: 20),
            );
          })
        ],
      ),
    );
  }

}
