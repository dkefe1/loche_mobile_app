import 'package:fantasy/core/services/language_provider.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/screens/create_coach_screen.dart';
import 'package:fantasy/features/index.dart';
import 'package:fantasy/features/onboard/presentation/screens/onboard_screen.dart';
import 'package:fantasy/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final prefService = PrefService();
  final profileRemoteDataSource = ProfileRemoteDataSource();

  @override
  void initState() {
    checkLanguage();
    navigate();
    super.initState();
  }

  Future checkLanguage() async{
    final lang = Provider.of<LanguageProvider>(context, listen: false);
    await prefService.getLanguage().then((value) {
      print(value);
      if(value == null){

      } else {
        if(value == "am"){
          lang.changeToAmharic();
        } else {
          lang.changeToEnglish();
        }
      }
    });
  }

  Future navigate() async{
    await Future.delayed(Duration(seconds: 2));
    prefService.getBoarded().then((value) {
      if(value == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoardingScreen()));
      } else {
        prefService.readLogin().then((value) {
          if(value == null) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
          } else {
            prefService.readCreatedTeam().then((value) {
              if(value == null) {
                profileRemoteDataSource.getProfile().then((value) {
                  if(value.profile.has_team){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 0,)));
                  } else {
                    final getCoaches = BlocProvider.of<CoachBloc>(context);
                    getCoaches.add(GetCoachEvent());
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateCoachScreen()));
                  }
                }).catchError((error) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                });
              } else {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IndexScreen(pageIndex: 0,)));
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/splash.png"), fit: BoxFit.fill)
        ),
        child: Center(child: Image.asset("images/logo.png", fit: BoxFit.cover, width: 164.67, height: 230,)),
      ),
    );
  }
}
