import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/profile/data/models/package.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/screens/deposit_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/profile_payement_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget packageWidget({required PackageModel package, required BuildContext context, required bool autoJoin, required bool isAppCredit, required Function() onPressed, required String phoneNumber}){

  bool isLoading = false;

  return BlocConsumer<DepositCreditBloc, DepositCreditState>(builder: (_, state){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: textColor, width: 1.0)
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      color: Color(0xFF136A8A).withOpacity(0.15),
                      border: Border.all(color: textColor, width: 1.0)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Text(package.game_weeks.toString(), style: TextStyle(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 50),),
                      Text("Round", style: TextStyle(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 14),),
                      SizedBox(height: 15,)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Text("${package.discount} Coin", style: TextStyle(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 20),),
                SizedBox(height: 40,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)
                        )
                    ),
                    onPressed: () async {
                      final x = await onPressed();
                      if(x == false){
                        return;
                      }
                      print(phoneNumber);
                      if(isAppCredit){
                        final buyPackageWithCredit = BlocProvider.of<DepositCreditBloc>(context);
                        buyPackageWithCredit.add(PostDepositCreditEvent(package.discount, "0$phoneNumber", autoJoin, true, package.game_weeks, true));
                      } else{
                        final depositCredit = BlocProvider.of<DepositCreditBloc>(context);
                        depositCredit.add(PostDepositCreditEvent(package.discount, "0$phoneNumber", autoJoin, true, package.game_weeks, false));
                      }
                    }, child: isLoading ? SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(color: Colors.white,),) : Text(AppLocalizations.of(context)!.choose, style:  TextStyle(color: Colors.white, fontSize: 18),))
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(3)
              ),
              child: Text("${((package.discounted_total_amount/package.total_amount)* 100).toStringAsFixed(1)}%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),),
            ),
          ),
        ],
      ),
    );
  }, listener: (_, state) async {
    isLoading = false;
    if(state is PostDepositCreditLoadingState){
      isLoading = true;
    } else if(state is PostDepositCreditSuccessfulState){
      Navigator.pop(context);
      if(state.checkout_url == ""){
        final getClientTeam = BlocProvider.of<ClientTeamBloc>(context);
        getClientTeam.add(GetClientTeamEvent());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePaymentSuccessScreen(isPackage: true)));
      } else {
        final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => DepositScreen(checkout_url: state.checkout_url, isPackage: true)));
        print(result);
      }
    } else if(state is PostDepositCreditFailedState){
      errorFlashBar(context: context, message: state.error);
      return;
    }
  });
}