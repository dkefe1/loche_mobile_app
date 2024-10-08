import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/ads_component.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/client_players.dart';
import 'package:fantasy/features/home/data/models/client_team_model.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/screens/reset_team_build_screen.dart';
import 'package:fantasy/features/home/presentation/screens/transfer_history_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/home_app_header.dart';
import 'package:fantasy/features/home/presentation/widgets/join_deadline_passed_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/join_deposit_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/join_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/join_gameweek_button.dart';
import 'package:fantasy/features/home/presentation/widgets/joined_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/loading_icon.dart';
import 'package:fantasy/features/home/presentation/widgets/loading_shirt.dart';
import 'package:fantasy/features/home/presentation/widgets/no_active_gameweek_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/player_avatar.dart';
import 'package:fantasy/features/home/presentation/widgets/preview_component2.dart';
import 'package:fantasy/features/home/presentation/widgets/reset_team_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/team_information_dialog.dart';
import 'package:fantasy/features/home/presentation/widgets/transfer_component.dart';
import 'package:fantasy/features/home/presentation/widgets/transfer_preview_component.dart';
import 'package:fantasy/features/home/presentation/widgets/update_dialog.dart';
import 'package:fantasy/features/profile/presentation/screens/deposit_choice_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/deposit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with TickerProviderStateMixin {

  final prefs = PrefService();

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool customDialRoot = true;
  bool rmIcons = false;

  int _selectedTabbar = 0;
  late TabController tabController;
  late TabController tabLoadingController;

  bool isJoinLoading = false;

  TextEditingController depositController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabLoadingController = TabController(length: 2, vsync: this);
    prefs.getPhoneNumber().then((value) {
      if(value != null){
        phoneNumberController.text = value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    depositController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  DateTime? _lastPressedTime;
  bool isReloading = false;

  void onReload() async {
    DateTime currentTime = DateTime.now();
    if (_lastPressedTime == null ||
        currentTime.difference(_lastPressedTime!).inMinutes >= 5) {
      final getClientTeam = BlocProvider.of<ClientTeamBloc>(context);
      getClientTeam.add(GetClientTeamEvent());
      _lastPressedTime = currentTime;
    } else {
      setState(() {
        isReloading = true;
      });
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        isReloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<ClientTeamBloc, ClientTeamState>(
      listener: (_, state) async {
        if(state is ClientTeamSuccessfulState){

          if(Platform.isIOS){
            final appUpdate = BlocProvider.of<AppVersionBloc>(context);
            appUpdate.add(GetAppVersionEvent("iOS"));
          } else if(Platform.isAndroid){
            final appUpdate = BlocProvider.of<AppVersionBloc>(context);
            appUpdate.add(GetAppVersionEvent("Android"));
          }

          if(state.team.players.length < 15){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ResetTeamBuildScreen()), (route) => false);
            return;
          }

          final data = Provider.of<ClientPlayersProvider>(context, listen: false);

          List<ClientPlayer> selectedPlayers = state.team.players
              .where((player) => player.is_bench == false)
              .toList();

          List<ClientPlayer> substitutePlayers = state.team.players
              .where((player) => player.is_bench == true)
              .toList();

          data.selectedPlayers = [];
          data.substitutePlayers = [];
          data.allPlayers = [];
          data.addAllSelectedPlayers(selectedPlayers);
          data.addAllSubstitutePlayers(substitutePlayers);
          data.addAllPlayers(state.team.players);
        }

        if(state is ClientTeamFailedState){
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
        setState(() {});
      },
      builder: (_, state) {
      if (state is ClientTeamSuccessfulState) {
      return isReloading ? teamLoading() : buildInitialInput(team: state.team);
      } else if (state is ClientTeamLoadingState) {
      return teamLoading();
      } else if (state is ClientTeamFailedState) {
        if(state.error == pinChangedMessage || state.error == notCreatedATeam){
          return pinChangedErrorView(
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
              });
        }
      return errorView(
          iconPath: state.error == socketErrorMessage
              ? "images/connection.png"
              : "images/error.png",
          title: "Ooops!",
          text: state.error,
          onPressed: () {
            final getClientTeam =
            BlocProvider.of<ClientTeamBloc>(context);
            getClientTeam.add(GetClientTeamEvent());
          });
      } else {
      return SizedBox();
      }
      }),
    );
  }

  Widget buildInitialInput({required ClientTeam team}) {
    return Column(
      children: [
        BlocConsumer<AppVersionBloc, AppVersionState>(
            listener: (_, state) async {
              if(state is GetAppVersionFailedState){
                errorFlashBar(context: context, message: state.error);
              } else if(state is GetAppVersionSuccessfulState) {

                PackageInfo packageInfo = await PackageInfo.fromPlatform();

                String version = packageInfo.version;

                if(state.appUpdate != null){
                  if(version != state.appUpdate!.latest_version){
                    if(state.appUpdate!.highly_severe){
                      showDialog(
                          barrierDismissible: false,
                          context: context, builder: (BuildContext context){
                        return updateAppDialog(context: context, onPressed: () async {

                          final Uri _url = Uri.parse(state.appUpdate!.url);

                          if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
                            throw Exception('Could not launch $_url');
                          }
                        });
                      });
                    }
                  }
                }
              }
            },
            builder: (_, state) {
              return SizedBox();
            }),
        HomeAppHeader(gameWeek: team.gameWeek, budget: team.budget.toStringAsFixed(1), totalFantasyPoint: team.total_fantasy_point.toStringAsFixed(1), gameWeekFantasyPoint: team.gameweek_fantasy_point.toStringAsFixed(1), isLoading: false,),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
                  child: TabBar(
                      indicatorColor: _selectedTabbar == 1 ? Colors.transparent : null,
                      onTap: (index) {
                        setState(() {
                          _selectedTabbar = index;
                          tabController.animateTo(index,
                              duration: Duration(seconds: 2));
                        });
                        if(index == 1){
                          if(!team.joinedGameWeekTeam.activeGameWeekAvailable){
                            // No Active Game Week
                            showDialog(context: context, builder: (context) {
                              return noActiveGameeWeekDialog(context: context);
                            });
                            return;
                          }
                          if(team.joinedGameWeekTeam.clientGameWeekTeam == null){
                            if(team.joinedGameWeekTeam.deadlinePassed){
                              // DEADLINE PASSED
                              showDialog(context: context, builder: (context) {
                                return joinDeadlinePassedDialog(context: context);
                              });
                              return;
                            }
                            if(team.joinedGameWeekTeam.lowBalance && !team.joinedGameWeekTeam.isGameWeekFree && team.joinedGameWeekTeam.no_package){
                              // LOW BALANCE(DEPOSIT)
                              showDialog(context: context, builder: (context) {
                                return joinDepositDialog(context: context, phoneNumber: phoneNumberController.text, onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DepositChoiceScreen(depositController: depositController, phoneNumberController: phoneNumberController, credit: team.budget, autoJoin: true)));
                                });
                              });
                              return;
                            }
                            // NOT JOINED
                            if(team.joinedGameWeekTeam.isGameWeekFree){
                              // GAMEWEEK FREE
                              showDialog(context: context, builder: (context) {
                                return joinDialog(context: context, phoneNumber: phoneNumberController.text, isFree: true, onPressed: (){
                                  final joinTeam = BlocProvider.of<JoinGameWeekTeamBloc>(context);
                                  joinTeam.add(PostJoinGameWeekTeamEvent(team.competition));
                                });
                              });
                              return;
                            } else {
                              // NOT JOINED SO JOIN
                              showDialog(context: context, builder: (context) {
                                return joinDialog(context: context, phoneNumber: phoneNumberController.text, isFree: false, onPressed: (){
                                  final joinTeam = BlocProvider.of<JoinGameWeekTeamBloc>(context);
                                  joinTeam.add(PostJoinGameWeekTeamEvent(team.competition));
                                });
                              });
                              return;
                            }
                          } else if (team.joinedGameWeekTeam.clientGameWeekTeam != null){
                            // JOINED
                            showDialog(context: context, builder: (context) {
                              return joinedGameweekDialog(context: context);
                            });
                            return;
                          }
                        } else if(index == 2){
                          final getTransferModel =
                          BlocProvider.of<TransferModelBloc>(context);
                          getTransferModel.add(GetTransferModelEvent());
                        }
                      },
                      controller: tabController,
                      tabs: [
                        Tab(
                            child: Text(
                              AppLocalizations.of(context)!.my_team,
                              style:
                              GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                            )),
                        joinGameWeekButton(joinedGameWeekTeam: team.joinedGameWeekTeam, context: context),
                        Tab(
                            child: Text(
                              AppLocalizations.of(context)!.transfers,
                              style:
                              GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                            )),
                      ]),
                ),
                Builder(builder: (_) {
                  if (_selectedTabbar == 0) {
                    return myTeamWidget(clientTeam: team);
                  } else if (_selectedTabbar == 1) {
                    return myTeamWidget(clientTeam: team);
                  } else {
                    return transfersWidget(clientPlayer: team.players, budget: team.budget.toStringAsFixed(1));
                  }
                })
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget transfersWidget({required List<ClientPlayer> clientPlayer, required String budget}) {
    return Expanded(
      child: BlocConsumer<TransferModelBloc, TransferModelState>(
          listener: (_, state) async {
            if(state is GetTransferModelSuccessfulState){
            }

            if(state is GetTransferModelFailedState){
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
            setState(() {});
          },
          builder: (_, state) {
            if (state is GetTransferModelSuccessfulState) {
              return transferBody(clientPlayer: clientPlayer, budget: budget, gameWeek: state.transferModel.activeGameWeek, matches: state.transferModel.matches);
            } else if (state is GetTransferModelLoadingState) {
              return teamLoading();
            } else if (state is GetTransferModelFailedState) {
              if(state.error == pinChangedMessage || state.error == notCreatedATeam){
                return pinChangedErrorView(
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
                    });
              }
              return errorView(
                  iconPath: state.error == socketErrorMessage
                      ? "images/connection.png"
                      : "images/error.png",
                  title: "Ooops!",
                  text: state.error,
                  onPressed: () {
                    final getActiveGameWeek =
                    BlocProvider.of<ActiveGameWeekBloc>(context);
                    getActiveGameWeek.add(GetActiveGameWeekEvent());
                  });
            } else {
              return SizedBox();
            }
          }),
    );
  }

  Widget transferBody({required List<ClientPlayer> clientPlayer, required String budget, required GameWeek? gameWeek, required List<MatchModel> matches}){
    return Consumer<ClientPlayersProvider>(builder: (context, data, child) {
      List<ClientPlayer> gkPlayers =
      clientPlayer.where((player) => player.position == "Goalkeeper").toList();
      List<ClientPlayer> defPlayers =
      clientPlayer.where((player) => player.position == "Defender").toList();
      List<ClientPlayer> midPlayers =
      clientPlayer.where((player) => player.position == "Midfielder").toList();
      List<ClientPlayer> forPlayers =
      clientPlayer.where((player) => player.position == "Forward").toList();

      List<String> myPlayersId = [];
      for(int i=0; i<clientPlayer.length; i++){
        myPlayersId.add(clientPlayer[i].pid);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/pitch.png"),
                      fit: BoxFit.fill)),
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraint) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraint.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              transferPreviewComponent(players: gkPlayers, myPlayersId: myPlayersId, budget: budget, matches: matches),
                              transferPreviewComponent(players: defPlayers, myPlayersId: myPlayersId, budget: budget, matches: matches),
                              transferPreviewComponent(players: midPlayers, myPlayersId: myPlayersId, budget: budget, matches: matches),
                              transferPreviewComponent(players: forPlayers, myPlayersId: myPlayersId, budget: budget, matches: matches),
                              SizedBox(),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                  Positioned(
                    right: 20,
                    top: 30,
                    child: FloatingActionButton(
                      heroTag: "transfer history button",
                      backgroundColor: primaryColor,
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TransferHistoryScreen()));
                      }, child: Iconify(Mdi.history, color: Colors.white, size: 35,),),
                  ),
                  Positioned(
                    left: 20,
                    top: 30,
                    child: FloatingActionButton(
                      heroTag: "reset team",
                      backgroundColor: primaryColor,
                      onPressed: (){
                        showDialog(context: context, builder: (context) {
                          return resetTeamDialog(context: context, onPressed: (){
                            final resetTeam = BlocProvider.of<ResetTeamBloc>(context);
                            resetTeam.add(PatchResetTeamEvent());
                          });
                        });
                      }, child: Iconify(Mdi.delete_outline, color: Colors.white, size: 35,),),
                  ),
                  BlocConsumer<TransferPlayerBloc, TransferPlayerState>(builder: (_, state){
                    if(state is TransferPlayerLoadingState) {
                      return Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Align(
                          alignment: Alignment.center,
                          child: LoadingIcon(),
                        ),
                      );
                    }
                    return SizedBox();
                  }, listener: (_, state) async {

                    if(state is TransferPlayerSuccessfulState){
                      final getClientTeam =
                      BlocProvider.of<ClientTeamBloc>(context);
                      getClientTeam.add(GetClientTeamEvent());
                    }

                    if(state is TransferPlayerFailedState){
                      if(state.error == jwtExpired || state.error == doesNotExist){
                        await prefs.signout();
                        await prefs.removeToken();
                        await prefs.removeCreatedTeam();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                                (route) => false);
                      } else {
                        errorFlashBar(context: context, message: state.error);
                      }
                    }
                  }),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/splash.png"), fit: BoxFit.cover),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Color(0xFF000000).withOpacity(0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          transferComponent(key: "${AppLocalizations.of(context)!.ft} : ", value: AppLocalizations.of(context)!.unlimited),
                          transferComponent(key: "${AppLocalizations.of(context)!.bank} : ", value: "$budget LC"),
                        ],
                      ),
                      Column(
                        children: [
                          gameWeek == null ? Text(AppLocalizations.of(context)!.no_active, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.5),) : Text("${AppLocalizations.of(context)!.gw}${gameWeek.game_week} ${AppLocalizations.of(context)!.deadline}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.5),),
                          gameWeek == null ? Text(AppLocalizations.of(context)!.game_week, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.5),) : Text(formatDate(gameWeek.transfer_deadline), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, letterSpacing: 1.5),),
                          gameWeek == null ? SizedBox() : Text(formatTime(gameWeek.transfer_deadline), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16, letterSpacing: 1.5),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget myTeamWidget({required ClientTeam clientTeam}) {
    return Expanded(
      child: Consumer<ClientPlayersProvider>(builder: (context, data, child) {
        List<ClientPlayer> selectedGkPlayers = clientTeam.players
            .where((player) => player.position == "Goalkeeper" && player.is_bench == false)
            .toList();
        List<ClientPlayer> selectedDefPlayers = clientTeam.players
            .where((player) => player.position == "Defender" && player.is_bench == false)
            .toList();
        List<ClientPlayer> selectedMidPlayers = clientTeam.players
            .where((player) => player.position == "Midfielder" && player.is_bench == false)
            .toList();
        List<ClientPlayer> selectedForPlayers = clientTeam.players
            .where((player) => player.position == "Forward" && player.is_bench == false)
            .toList();

        List<ClientPlayer> substituteGkPlayers = clientTeam.players
            .where((player) => player.position == "Goalkeeper" && player.is_bench == true)
            .toList();
        List<ClientPlayer> substituteDefPlayers = clientTeam.players
            .where((player) => player.position == "Defender" && player.is_bench == true)
            .toList();
        List<ClientPlayer> substituteMidPlayers = clientTeam.players
            .where((player) => player.position == "Midfielder" && player.is_bench == true)
            .toList();
        List<ClientPlayer> substituteForPlayers = clientTeam.players
            .where((player) => player.position == "Forward" && player.is_bench == true)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/pitch.png"),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: LayoutBuilder(
                        builder: (context, constraint) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: constraint.maxHeight),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(height: 10,),
                                  previewComponent2(
                                      players: selectedGkPlayers, isSwitch: data.isSwitch),
                                  previewComponent2(
                                      players: selectedDefPlayers, isSwitch: data.isSwitch),
                                  previewComponent2(
                                      players: selectedMidPlayers, isSwitch: data.isSwitch),
                                  previewComponent2(
                                      players: selectedForPlayers, isSwitch: data.isSwitch),
                                  SizedBox(),
                                ],
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                    Positioned(
                      right: 20,
                      top: 30,
                      child: FloatingActionButton(
                        heroTag: "team info button",
                        backgroundColor: primaryColor,
                        onPressed: (){
                          final getMyCoach =
                          BlocProvider.of<MyCoachBloc>(context);
                          getMyCoach.add(GetMyCoachEvent(clientTeam.favorite_coach, true));
                          showDialog(context: context, builder: (BuildContext context){
                            return teamInfoDialog(context: context, clientTeam: clientTeam);
                          });
                        }, child: Iconify(Mdi.information_variant, color: Colors.white,),),
                    ),
                    Positioned(
                      left: 20,
                      top: 30,
                      child: FloatingActionButton(
                        heroTag: "reload button",
                        backgroundColor: primaryColor,
                        onPressed: onReload, child: Iconify(Mdi.reload, color: Colors.white,),),
                    ),
                    BlocConsumer<SwitchPlayerBloc, SwitchPlayerState>(builder: (_, state){
                      if(state is SwitchPlayerLoadingState) {
                        return Container(
                          color: Colors.black.withOpacity(0.4),
                          child: Align(
                            alignment: Alignment.center,
                            child: LoadingIcon(),
                          ),
                        );
                      }
                      return SizedBox();
                    }, listener: (_, state) async {

                      if(state is SwitchPlayerSuccessfulState){
                        final getClientTeam =
                        BlocProvider.of<ClientTeamBloc>(context);
                        getClientTeam.add(GetClientTeamEvent());
                      }

                      if(state is SwitchPlayerFailedState){
                        if(state.error == jwtExpired || state.error == doesNotExist){
                          await prefs.signout();
                          await prefs.removeToken();
                          await prefs.removeCreatedTeam();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                                  (route) => false);
                        } else {
                          errorFlashBar(context: context, message: state.error);
                        }
                      }
                    }),
                    BlocConsumer<SwapPlayerBloc, SwapPlayerState>(builder: (_, state){
                      if(state is SwapPlayerLoadingState) {
                        return Container(
                          color: Colors.black.withOpacity(0.4),
                          child: Align(
                            alignment: Alignment.center,
                            child: LoadingIcon(),
                          ),
                        );
                      }
                      return SizedBox();
                    }, listener: (_, state) async {

                      if(state is SwapPlayerSuccessfulState){
                        final getClientTeam =
                        BlocProvider.of<ClientTeamBloc>(context);
                        getClientTeam.add(GetClientTeamEvent());
                      }

                      if(state is SwapPlayerFailedState){
                        if(state.error == jwtExpired || state.error == doesNotExist){
                          await prefs.signout();
                          await prefs.removeToken();
                          await prefs.removeCreatedTeam();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                                  (route) => false);
                        } else {
                          errorFlashBar(context: context, message: state.error);
                        }
                      }
                    }),
                  ],
                ),
              ),
            ),
            // AdsComponent(ads: clientTeam.ads, height: 50),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/splash.png"), fit: BoxFit.fill),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                color: Color(0xFF000000).withOpacity(0.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.substitute,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: substituteGkPlayers
                              .map((player) => playerAvatar(
                                  player: player, context: context, isSwitch: data.isSwitch))
                              .toList(),
                        ),
                        Row(
                          children: [
                            Row(
                              children: substituteDefPlayers
                                  .map((player) => playerAvatar(
                                      player: player, context: context, isSwitch: data.isSwitch))
                                  .toList(),
                            ),
                            Row(
                              children: substituteMidPlayers
                                  .map((player) => playerAvatar(
                                      player: player, context: context,  isSwitch: data.isSwitch))
                                  .toList(),
                            ),
                            Row(
                              children: substituteForPlayers
                                  .map((player) => playerAvatar(
                                      player: player, context: context,  isSwitch: data.isSwitch))
                                  .toList(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget teamLoading() {
    return Column(
      children: [
        _selectedTabbar == 2 ? SizedBox() : HomeAppHeader(gameWeek: null, budget: "", isLoading: true, totalFantasyPoint: "", gameWeekFantasyPoint: "",),
        Expanded(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: _selectedTabbar == 2 ? 0 : 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
            child: Column(
              children: [
                _selectedTabbar == 2 ? SizedBox() : Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
                  child: TabBar(
                      indicatorColor: _selectedTabbar == 1 ? Colors.transparent : null,
                      onTap: (index) {

                      },
                      controller: tabLoadingController,
                      tabs: [
                        Tab(
                            child: Text(
                              AppLocalizations.of(context)!.my_team,
                              style:
                              GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                            )),
                        Tab(
                            child: Text(
                              AppLocalizations.of(context)!.transfers,
                              style:
                              GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                            )),
                      ]),
                ),
                Expanded(
                  child: Builder(builder: (_) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/pitch.png"),
                                    fit: BoxFit.cover)),
                            child: LayoutBuilder(
                              builder: (context, constraint) {
                                return SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(height: 10,),
                                        Center(child: BlinkShirt(width: 39.81, height: 55)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BlinkShirt(width: 39.81, height: 55),
                                            SizedBox(width: 15,),
                                            BlinkShirt(width: 39.81, height: 55),
                                            SizedBox(width: 15,),
                                            BlinkShirt(width: 39.81, height: 55),
                                            SizedBox(width: 15,),
                                            BlinkShirt(width: 39.81, height: 55),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BlinkShirt(width: 39.81, height: 55),
                                            SizedBox(width: 15,),
                                            BlinkShirt(width: 39.81, height: 55),
                                            SizedBox(width: 15,),
                                            BlinkShirt(width: 39.81, height: 55),
                                            SizedBox(width: 15,),
                                            BlinkShirt(width: 39.81, height: 55),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BlinkShirt(width: 39.81, height: 55),
                                            SizedBox(width: 15,),
                                            BlinkShirt(width: 39.81, height: 55),
                                          ],
                                        ),
                                        SizedBox(),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                        _selectedTabbar == 2 ? SizedBox() : Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("images/splash.png"), fit: BoxFit.fill),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            color: Color(0xFF000000).withOpacity(0.2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.substitute,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BlinkShirt(width: 39.81, height: 55),
                                    Row(
                                      children: [
                                        BlinkShirt(width: 39.81, height: 55),
                                        SizedBox(width: 15,),
                                        BlinkShirt(width: 39.81, height: 55),
                                        SizedBox(width: 15,),
                                        BlinkShirt(width: 39.81, height: 55),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDateTime =
    DateFormat('EEE dd MMM').format(dateTime.toLocal());
    return formattedDateTime;
  }

  String formatTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDateTime =
    DateFormat('hh:mm a').format(dateTime.toLocal());
    return formattedDateTime;
  }

}
