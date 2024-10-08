import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/awards.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/screens/payment_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/award_component2.dart';
import 'package:fantasy/features/profile/presentation/widgets/wallet_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AwardsScreen extends StatefulWidget {

  final String clientId;
  final Profile profile;

  AwardsScreen({Key? key, required this.clientId, required this.profile}) : super(key: key);

  @override
  State<AwardsScreen> createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {

  final prefs = PrefService();

  @override
  void initState() {
    final getAwards =
    BlocProvider.of<AwardsBloc>(context);
    getAwards.add(GetAwardsEvent(widget.clientId));
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
                AppLocalizations.of(context)!.my_awards),
            Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: BlocConsumer<AwardsBloc, AwardsState>(
                      listener: (_, state) async {
                        if(state is GetAwardsFailedState){
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
                        }
                      },
                      builder: (_, state) {
                        if (state is GetAwardsSuccessfulState) {
                          return state.awards.isEmpty ? Center(child: noDataWidget(icon: Healthicons.award_trophy_outline, message: AppLocalizations.of(context)!.you_have_not_yet_won_any_awards_g, iconSize: 120, iconColor: textColor)) : buildInitialInput(awards: state.awards);
                        } else if (state is GetAwardsLoadingState) {
                          return awardsLoading();
                        } else if (state is GetAwardsFailedState) {
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
                                  final getAwards =
                                  BlocProvider.of<AwardsBloc>(context);
                                  getAwards.add(GetAwardsEvent(widget.clientId));
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

  Widget buildInitialInput({required List<Awards> awards}){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(child: walletBox(value: widget.profile.earned_prize.toString(), type: AppLocalizations.of(context)!.earned_g)),
              SizedBox(
                width: 10,
              ),
              Expanded(child: walletBox(value: widget.profile.prize_balance.toString(), type: AppLocalizations.of(context)!.available_g)),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(withdrawalType: "Prize Withdrawal", amount: widget.profile.prize_balance.toString(), fromPrizeOrCommission: "Prize",)));
                },
                child: Text(
                  AppLocalizations.of(context)!.withdraw,
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
            AppLocalizations.of(context)!.lists_of_awards.toUpperCase(),
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
                fontSize: textFontSize),
          ),
          SizedBox(height: 10,),
          ListView.builder(
              itemCount: awards.length,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index){
                return awardComponent2(contestor: awards[index], index: index);
              }),
          SizedBox(height: 20,)
        ],
      ),
    );
  }

  Widget awardsLoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          BlinkContainer(width: 150, height: 30, borderRadius: 0),
          SizedBox(height: 10,),
          ListView.builder(
            padding: EdgeInsets.zero,
              itemCount: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: BlinkContainer(width: double.infinity, height: 100, borderRadius: 10),
            );
          })
        ],
      ),
    );
  }
}
