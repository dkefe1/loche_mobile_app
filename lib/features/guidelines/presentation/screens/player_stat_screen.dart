import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/search_bar.dart';
import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/player_stat_header.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/player_stat_list_widget.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/search_player_stat_widget.dart';
import 'package:fantasy/features/home/data/models/game_week.dart';
import 'package:fantasy/features/home/data/models/club.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlayerStatScreen extends StatefulWidget {
  const PlayerStatScreen({super.key});

  @override
  State<PlayerStatScreen> createState() => _PlayerStatScreenState();
}

class _PlayerStatScreenState extends State<PlayerStatScreen> with TickerProviderStateMixin {

  int _selectedTabbar = 0;
  late TabController tabController;

  TextEditingController searchController = TextEditingController();
  List<PlayerStat> searchedPlayers = [];

  Club? selectedClub;

  List<Club> categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
  List<String> teamAbbr = [];

  GameWeek? gameWeekValue;
  List<GameWeek> gameWeeks = [GameWeek(id: "id", game_week: "All Time", transfer_deadline: "", is_done: false)];

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    final getPlayerStat = BlocProvider.of<PlayerStatBloc>(context);
    getPlayerStat.add(GetPlayerStatEvent("initial", false));
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SelectedPlayersProvider>(builder: (context, data, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              playerStatHeader(
                  title: AppLocalizations.of(context)!.player_stat),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(defaultBorderRadius))),
                  child: BlocConsumer<PlayerStatBloc, PlayerStatState>(builder: (_, state){
                    if (state is GetPlayerStatSuccessfulState) {
                      return buildInitialInput(allPlayers: state.players.players);
                    } else if (state is GetPlayerStatLoadingState) {
                      return squadLoading();
                    } else if (state is GetPlayerStatFailedState) {
                      return errorView(
                          iconPath: state.error == socketErrorMessage
                              ? "images/connection.png"
                              : "images/error.png",
                          title: "Ooops!",
                          text: state.error,
                          onPressed: () {
                            if(gameWeekValue != null){
                              if(gameWeekValue!.game_week == "All Time"){
                                final getPlayerStat = BlocProvider.of<PlayerStatBloc>(context);
                                getPlayerStat.add(GetPlayerStatEvent(gameWeekValue!.id, true));
                                return;
                              }
                            }
                            final getPlayerStat = BlocProvider.of<PlayerStatBloc>(context);
                            getPlayerStat.add(GetPlayerStatEvent("initial", false));
                          });
                    } else {
                      return SizedBox();
                    }
                  }, listener: (_, state){
                    if(state is GetPlayerStatSuccessfulState){
                      gameWeekValue ?? gameWeeks.addAll(state.players.gameWeeks);
                      gameWeekValue ??= state.players.gameWeeks[0];
                      List<Club> clubs = [];
                      categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
                      teamAbbr = [];
                      for(int i=0; i<state.players.players.length; i++){
                        if(teamAbbr.contains(state.players.players[i].club)){
                          continue;
                        } else {
                          teamAbbr.add(state.players.players[i].club);
                          clubs.add(Club(name: state.players.players[i].club, logo: state.players.players[i].club, abbr: state.players.players[i].club));
                        }
                      }
                      clubs.sort((a, b) => a.name.compareTo(b.name));
                      categories.addAll(clubs);
                    }
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildInitialInput({required List<PlayerStat> allPlayers}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        SearchBarWidget(controller: searchController, hintText: AppLocalizations.of(context)!.search_all_players, icon: Ri.search_line, onChanged: (){
          setState(() {
            searchedPlayers = allPlayers.where((player) => player.full_name.toUpperCase().contains(searchController.text.toUpperCase())).toList();
          });
        }, clear: (){
          searchController.clear();
          setState(() {
          });
        }),
        SizedBox(height: 10,),
        searchController.text.isEmpty ? SizedBox() : Expanded(child: SingleChildScrollView(child: searchedPlayerStatWidget(searchedPlayers: searchedPlayers))),
        searchController.text.isNotEmpty ? SizedBox() : Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<GameWeek>(
                            value: gameWeekValue,
                            isExpanded: true,
                            hint: Text(
                              AppLocalizations.of(context)!.game_weeks,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: textFontSize2,
                                  fontWeight: FontWeight.w500),
                            ),
                            items: gameWeeks.map(buildMenuCategories).toList(),
                            icon: Iconify(
                              MaterialSymbols.arrow_drop_down_rounded,
                              color: primaryColor,
                              size: 30,
                            ),
                            onChanged: (value) {
                              gameWeekValue = value;
                              if(value!.game_week == "All Time"){
                                final getPlayerStat = BlocProvider.of<PlayerStatBloc>(context);
                                getPlayerStat.add(GetPlayerStatEvent(gameWeekValue!.id, true));
                              } else {
                                final getPlayerStat = BlocProvider.of<PlayerStatBloc>(context);
                                getPlayerStat.add(GetPlayerStatEvent(gameWeekValue!.id, false));
                              }
                              setState(() {
                              });
                            }),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: textFormFieldBackgroundColor,
                          border: Border.all(color: primaryColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Club>(
                            value: selectedClub,
                            isExpanded: true,
                            hint: Text(AppLocalizations.of(context)!.filter_by_club, style: TextStyle(
                                color: textColor,
                                fontSize: textFontSize2,
                                fontWeight: FontWeight.w500),),
                            items: categories.map(buildClubCategories).toList(),
                            icon: Iconify(
                              MaterialSymbols.arrow_drop_down_rounded,
                              color: primaryColor,
                              size: 30,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedClub = value;
                              });
                            }),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              TabBar(
                onTap: (index) {
                  setState(() {
                    _selectedTabbar = index;
                    tabController.animateTo(index,
                        duration: Duration(seconds: 2));
                  });
                },
                labelColor: primaryColor,
                unselectedLabelColor: primaryColor,
                indicator: BoxDecoration(
                    color: selectedTabColor,
                    borderRadius: BorderRadius.circular(7)),
                controller: tabController,
                tabs: [
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.gk,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.def,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.mid,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.forward,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Expanded(
                child: SingleChildScrollView(
                  child: Builder(builder: (_) {

                    if(selectedClub != null){
                      if(selectedClub!.name == "All Players"){
                        allPlayers = allPlayers;
                      } else {
                        allPlayers = allPlayers.where((player) => player.club == selectedClub!.abbr).toList();
                      }
                    }

                    List<PlayerStat> gkPlayers =
                    allPlayers.where((player) => player.position == "Goalkeeper").toList();
                    List<PlayerStat> defPlayers =
                    allPlayers.where((player) => player.position == "Defender").toList();
                    List<PlayerStat> midPlayers =
                    allPlayers.where((player) => player.position == "Midfielder").toList();
                    List<PlayerStat> forPlayers =
                    allPlayers.where((player) => player.position == "Forward").toList();

                    gkPlayers.sort((a, b) => b.fantasy_point.compareTo(a.fantasy_point));
                    defPlayers.sort((a, b) => b.fantasy_point.compareTo(a.fantasy_point));
                    midPlayers.sort((a, b) => b.fantasy_point.compareTo(a.fantasy_point));
                    forPlayers.sort((a, b) => b.fantasy_point.compareTo(a.fantasy_point));

                    if (_selectedTabbar == 0) {
                      return playerStatList(players: gkPlayers);
                    } else if (_selectedTabbar == 1) {
                      return playerStatList(players: defPlayers);
                    } else if (_selectedTabbar == 2) {
                      return playerStatList(players: midPlayers);
                    } else {
                      return playerStatList(players: forPlayers);
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget squadLoading() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25,),
          Row(
            children: [
              Expanded(child: BlinkContainer(width: double.infinity, height: 40, borderRadius: 6)),
              SizedBox(width: 10,),
              Expanded(child: BlinkContainer(width: double.infinity, height: 40, borderRadius: 6)),
              SizedBox(width: 10,),
              Expanded(child: BlinkContainer(width: double.infinity, height: 40, borderRadius: 6)),
              SizedBox(width: 10,),
              Expanded(child: BlinkContainer(width: double.infinity, height: 40, borderRadius: 6)),
              SizedBox(width: 10,)
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlinkContainer(width: 80, height: 30, borderRadius: 0),
              BlinkContainer(width: 80, height: 30, borderRadius: 0),
            ],
          ),
          SizedBox(height: 20,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
          BlinkContainer(width: double.infinity, height: 80, borderRadius: 0),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  DropdownMenuItem<Club> buildClubCategories(Club category) =>
      DropdownMenuItem(
          value: category,
          child: Text(
            category.name,
            style: TextStyle(
                color: primaryColor,
                fontSize: textFontSize2,
                fontWeight: FontWeight.w500),
          ));

  DropdownMenuItem<GameWeek> buildMenuCategories(GameWeek gameWeek) => DropdownMenuItem(
      value: gameWeek,
      child: Text(
        gameWeek.game_week == "All Time" ? gameWeek.game_week : "Game Week ${gameWeek.game_week}",
        style: TextStyle(
            color: primaryColor,
            fontSize: textFontSize2,
            fontWeight: FontWeight.w500),
      ));

}

