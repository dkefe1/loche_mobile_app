import 'dart:io';

import 'package:fantasy/core/services/firebase_api.dart';
import 'package:fantasy/core/services/language_provider.dart';
import 'package:fantasy/features/auth/signin/data/datasources/remote_datasource/signin_datasource.dart';
import 'package:fantasy/features/auth/signin/data/repositories/signin_repository.dart';
import 'package:fantasy/features/auth/signin/presentation/blocs/login_bloc.dart';
import 'package:fantasy/features/auth/signup/data/datasources/remote_datasource/signup_datasource.dart';
import 'package:fantasy/features/auth/signup/data/repositories/signup_repository.dart';
import 'package:fantasy/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:fantasy/features/fixture/data/datasource/fixture_remote_datasource.dart';
import 'package:fantasy/features/fixture/data/repositories/fixture_repositories.dart';
import 'package:fantasy/features/fixture/presentation/blocs/fixture_bloc.dart';
import 'package:fantasy/features/guidelines/data/datasources/remote/guidelines_remote_datasource.dart';
import 'package:fantasy/features/guidelines/data/repositories/guidelines_repository.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:fantasy/features/home/data/models/client_players.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/data/repositories/home_repositories.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/leaderboard/data/datasources/leaderboard_datasources.dart';
import 'package:fantasy/features/leaderboard/data/repositories/leaderboard_repositories.dart';
import 'package:fantasy/features/leaderboard/presentation/blocs/leaderboard_bloc.dart';
import 'package:fantasy/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:fantasy/features/profile/data/repositories/profile_repository.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/splash_screen.dart';
import 'package:fantasy/firebase_options.dart';
import 'package:fantasy/l10n/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final signUpRepository = SignUpRepository(SignUpDatasource());
  final signInRepository = SignInRepository(SignInRemoteDataSource());
  final homeRepository = HomeRepositories(HomeRemoteDataSource());
  final guidelinesRepository = GuidelinesRepository(GuidelinesRemoteDataSource());
  final profileRepository = ProfileRepository(ProfileRemoteDataSource());
  final fixtureRepository = FixtureRepositories(FixtureRemoteDataSource());
  final leaderboardRepository = LeaderboardRepositories(LeaderboardDatasource());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpBloc(signUpRepository)),
        BlocProvider(create: (_) => LoginBloc(signInRepository)),
        BlocProvider(create: (_) => CodeAgentBloc(signUpRepository)),
        BlocProvider(create: (_) => AdvertisementBloc(homeRepository)),
        BlocProvider(create: (_) => SquadBloc(homeRepository)),
        BlocProvider(create: (_) => TransferSquadBloc(homeRepository)),
        BlocProvider(create: (_) => CoachBloc(homeRepository)),
        BlocProvider(create: (_) => JoinedGameWeekTeamBloc(homeRepository)),
        BlocProvider(create: (_) => JoinGameWeekTeamBloc(homeRepository)),
        BlocProvider(create: (_) => JoinedClientGameWeekBloc(homeRepository)),
        BlocProvider(create: (_) => ClientTeamBloc(homeRepository)..add(GetClientTeamEvent())),
        // BlocProvider(create: (_) => GameWeekBloc(homeRepository)..add(GetGameWeekEvent())),
        BlocProvider(create: (_) => CreateTeamBloc(homeRepository)),
        BlocProvider(create: (_) => TransferModelBloc(homeRepository)),
        BlocProvider(create: (_) => RecreateTeamBloc(homeRepository)),
        BlocProvider(create: (_) => TeamNameBloc(homeRepository)),
        BlocProvider(create: (_) => TransferHistoryBloc(homeRepository)),
        BlocProvider(create: (_) => SwitchPlayerBloc(homeRepository)),
        BlocProvider(create: (_) => TransferPlayerBloc(homeRepository)),
        BlocProvider(create: (_) => JoinedGameWeekBloc(homeRepository)),
        BlocProvider(create: (_) => AppVersionBloc(homeRepository)),
        BlocProvider(create: (_) => SwapPlayerBloc(homeRepository)),
        BlocProvider(create: (_) => ActiveGameWeekBloc(homeRepository)),
        BlocProvider(create: (_) => MyCoachBloc(homeRepository)),
        BlocProvider(create: (_) => PatchTeamBloc(homeRepository)),
        BlocProvider(create: (_) => ResetTeamBloc(homeRepository)),
        BlocProvider(create: (_) => FAQsBloc(guidelinesRepository)..add(GetAllFAQsEvent())),
        BlocProvider(create: (_) => TermsBloc(guidelinesRepository)..add(GetAllTermsEvent())),
        BlocProvider(create: (_) => PrivacyBloc(guidelinesRepository)..add(GetAllPrivacyEvent())),
        BlocProvider(create: (_) => FeedbackTitleBloc(guidelinesRepository)..add(GetAllFeedbackTitleEvent())),
        BlocProvider(create: (_) => AboutUsBloc(guidelinesRepository)..add(GetAboutUsEvent())),
        BlocProvider(create: (_) => PostFeedbackBloc(guidelinesRepository)),
        BlocProvider(create: (_) => PlayerStatBloc(guidelinesRepository)),
        BlocProvider(create: (_) => PlayerSelectedStatBloc(guidelinesRepository)),
        BlocProvider(create: (_) => DoneGameWeekBloc(guidelinesRepository)),
        BlocProvider(create: (_) => InjuredPlayerBloc(guidelinesRepository)),
        BlocProvider(create: (_) => PollsBloc(guidelinesRepository)),
        BlocProvider(create: (_) => PatchPollsBloc(guidelinesRepository)),
        BlocProvider(create: (_) => ProfileBloc(profileRepository)),
        BlocProvider(create: (_) => ClientRequestBloc(profileRepository)),
        BlocProvider(create: (_) => NotesBloc(profileRepository)..add(GetAllNotesEvent())),
        BlocProvider(create: (_) => ScoutsBloc(profileRepository)..add(GetAllScoutsEvent())),
        BlocProvider(create: (_) => PostNoteBloc(profileRepository)),
        BlocProvider(create: (_) => PostScoutBloc(profileRepository)),
        BlocProvider(create: (_) => PatchNoteBloc(profileRepository)),
        BlocProvider(create: (_) => DeleteNoteBloc(profileRepository)),
        BlocProvider(create: (_) => DeleteScoutBloc(profileRepository)),
        BlocProvider(create: (_) => DeleteAllNoteBloc(profileRepository)),
        BlocProvider(create: (_) => UpdateProfileBloc(profileRepository)),
        BlocProvider(create: (_) => UpdatePinBloc(profileRepository)),
        BlocProvider(create: (_) => UpdateProPicBloc(profileRepository)),
        BlocProvider(create: (_) => AgentCodeBloc(profileRepository)),
        BlocProvider(create: (_) => DepositCreditBloc(profileRepository)),
        BlocProvider(create: (_) => TransferCreditBloc(profileRepository)),
        BlocProvider(create: (_) => TransactionsHistoryBloc(profileRepository)),
        BlocProvider(create: (_) => AgentTransactionsHistoryBloc(profileRepository)),
        BlocProvider(create: (_) => AgentBloc(profileRepository)),
        BlocProvider(create: (_) => PackagesBloc(profileRepository)),
        BlocProvider(create: (_) => WithdrawBloc(profileRepository)),
        BlocProvider(create: (_) => BankBloc(profileRepository)),
        BlocProvider(create: (_) => AwardsBloc(profileRepository)),
        BlocProvider(create: (_) => FixtureBloc(fixtureRepository)),
        BlocProvider(create: (_) => MatchInfoBloc(fixtureRepository)),
        BlocProvider(create: (_) => WeeklyLeaderboardBloc(leaderboardRepository)),
        BlocProvider(create: (_) => YearlyLeaderboardBloc(leaderboardRepository)),
        BlocProvider(create: (_) => MonthlyLeaderboardBloc(leaderboardRepository)),
        BlocProvider(create: (_) => LeaderClientTeamBloc(leaderboardRepository)),
        BlocProvider(create: (_) => OtherClientTeamBloc(leaderboardRepository))
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SelectedPlayersProvider()),
          ChangeNotifierProvider(create: (_) => ClientPlayersProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: Consumer<LanguageProvider>(
          builder: (context, data, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Loche Fantasy Football App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                useMaterial3: false,
                textTheme: GoogleFonts.poppinsTextTheme(
                  Theme.of(context).textTheme,
                ),
              ),
              locale: data.lang,
              supportedLocales: L10n.all,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: const SplashScreen(),
            );
          }
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
