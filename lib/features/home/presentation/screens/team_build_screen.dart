import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/app_header3.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/search_bar.dart';
import 'package:fantasy/features/home/data/models/club.dart';
import 'package:fantasy/features/home/data/models/create_team_model.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/screens/create_coach_screen.dart';
import 'package:fantasy/features/home/presentation/screens/select_benches_screen.dart';
import 'package:fantasy/features/home/presentation/screens/team_preview_screen2.dart';
import 'package:fantasy/features/home/presentation/widgets/player_list_v1.1.dart';
import 'package:fantasy/features/home/presentation/widgets/tab_widget.dart';
import 'package:fantasy/features/home/presentation/widgets/team_build_search_widget.dart';
import 'package:fantasy/features/home/presentation/widgets/team_removal_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:provider/provider.dart';

class TeamBuildScreen extends StatefulWidget {

  CreateTeamModel createTeamModel;
  TeamBuildScreen({required this.createTeamModel});

  @override
  State<TeamBuildScreen> createState() => _TeamBuildScreenState();
}

class _TeamBuildScreenState extends State<TeamBuildScreen> with TickerProviderStateMixin {

  int _selectedTabbar = 0;
  late TabController tabController;

  TextEditingController searchController = TextEditingController();
  List<EntityPlayer> searchedPlayers = [];

  Club? selectedClub;

  List<Club> categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
  List<String> teamAbbr = [];

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    final getSquad = BlocProvider.of<SquadBloc>(context);
    getSquad.add(GetSquadEvent());
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
    return WillPopScope(
      onWillPop: () async {
        final removePlayers = Provider.of<SelectedPlayersProvider>(context, listen: false);
        if(removePlayers.selectedPlayers.isNotEmpty){
          showDialog(context: context, builder: (context) {
            return teamRemovalAlert(context: context, onPressed: () {
              removePlayers.removeAllPlayers();
              final getCoaches = BlocProvider.of<CoachBloc>(context);
              getCoaches.add(GetCoachEvent());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CreateCoachScreen()), (route) => false);
            });
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<SelectedPlayersProvider>(builder: (context, data, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
            child: Column(
              children: [
                appHeader3(
                    title: "Create Team",
                    budget:
                    data.credit.toStringAsFixed(1)),
                Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(defaultBorderRadius))),
                      child: BlocConsumer<SquadBloc, SquadState>(builder: (_, state){
                        if (state is GetSquadSuccessfulState) {
                          return buildInitialInput(allPlayers: state.players, data: data);
                        } else if (state is GetSquadLoadingState) {
                          return squadLoading();
                        } else if (state is GetSquadFailedState) {
                          return errorView(
                              iconPath: state.error == socketErrorMessage
                                  ? "images/connection.png"
                                  : "images/error.png",
                              title: "Ooops!",
                              text: state.error,
                              onPressed: () {
                                final getSquad = BlocProvider.of<SquadBloc>(context);
                                getSquad.add(GetSquadEvent());
                              });
                        } else {
                          return SizedBox();
                        }
                      }, listener: (_, state){
                        if(state is GetSquadSuccessfulState){
                          List<Club> clubs = [];
                          categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
                          teamAbbr = [];
                          for(int i=0; i<state.players.length; i++){
                            if(teamAbbr.contains(state.players[i].clubAbbr)){
                              continue;
                            } else {
                              teamAbbr.add(state.players[i].clubAbbr);
                              clubs.add(Club(name: state.players[i].clubName, logo: state.players[i].club_logo, abbr: state.players[i].clubAbbr));
                            }
                          }
                          clubs.sort((a, b) => a.name.compareTo(b.name));
                          categories.addAll(clubs);
                        }
                      }),
                    )),
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TeamPreviewScreen2(createTeamModel: widget.createTeamModel,)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: backgroundColor,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              side: BorderSide(color: primaryColor, width: 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            child: Text("Team Preview", style: TextStyle(color: primaryColor, fontSize: 14, fontWeight: FontWeight.w500),)),
                      ),
                      SizedBox(width: 15,),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: (){
                              if(data.selectedPlayers.length != 15) {
                                errorFlashBar(context: context, message: "Please select 15 players");
                                return;
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectBenchesScreen(createTeamModel: widget.createTeamModel,)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              side: BorderSide(color: primaryColor, width: 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                            child: Text("Next", style: TextStyle(color: onPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500),)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildInitialInput({required List<EntityPlayer> allPlayers, required SelectedPlayersProvider data}){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        SearchBarWidget(controller: searchController, hintText: "Search All Players", icon: Ri.search_line, onChanged: (){
          setState(() {
            searchedPlayers = allPlayers.where((player) => player.full_name.toUpperCase().contains(searchController.text.toUpperCase())).toList();
          });
        }, clear: (){
          searchController.clear();
          setState(() {
          });
        }),
        SizedBox(height: 10,),
        searchController.text.isEmpty ? SizedBox() : Expanded(child: SingleChildScrollView(child: teamBuildSearchWidget(searchedPlayers: searchedPlayers))),
        searchController.text.isNotEmpty ? SizedBox() :
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: textFormFieldBackgroundColor,
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Club>(
                      value: selectedClub,
                      isExpanded: true,
                      hint: Text("Filter by club", style: TextStyle(
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
              SizedBox(height: 10,),
              Row(
                children: [
                  Text(
                    "Number of selected players ",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor),
                  ),
                  Text(
                    "(",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor),
                  ),
                  Text(
                    "${data.selectedPlayers.length}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textBlackColor),
                  ),
                  Text(
                    "/",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textBlackColor),
                  ),
                  Text(
                    "15)",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Select Players",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor),
              ),
              SizedBox(
                height: 5,
              ),
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
                    child: tabWidget(position: "GK", count: data.selectedPlayers.where((player) => player.position == "Goalkeeper").toList().length),
                  ),
                  Tab(
                    child: tabWidget(position: "DEF", count: data.selectedPlayers.where((player) => player.position == "Defender").toList().length),
                  ),
                  Tab(
                    child: tabWidget(position: "MID", count: data.selectedPlayers.where((player) => player.position == "Midfielder").toList().length),
                  ),
                  Tab(
                    child: tabWidget(position: "FOR", count: data.selectedPlayers.where((player) => player.position == "Forward").toList().length),
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
                        allPlayers = allPlayers.where((player) => player.clubAbbr == selectedClub!.abbr).toList();
                      }
                    }

                    List<EntityPlayer> gkPlayers =
                    allPlayers.where((player) => player.position == "Goalkeeper").toList();
                    List<EntityPlayer> defPlayers =
                    allPlayers.where((player) => player.position == "Defender").toList();
                    List<EntityPlayer> midPlayers =
                    allPlayers.where((player) => player.position == "Midfielder").toList();
                    List<EntityPlayer> forPlayers =
                    allPlayers.where((player) => player.position == "Forward").toList();

                    gkPlayers.sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));
                    defPlayers.sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));
                    midPlayers.sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));
                    forPlayers.sort((a, b) => double.parse(b.price).compareTo(double.parse(a.price)));

                    if (_selectedTabbar == 0) {
                      return playerList2(text: "2 Goal Keepers", players: gkPlayers);
                    } else if (_selectedTabbar == 1) {
                      return playerList2(text: "5 Defenders", players: defPlayers);
                    } else if (_selectedTabbar == 2) {
                      return playerList2(text: "5 Midfielders", players: midPlayers);
                    } else {
                      return playerList2(text: "3 Forwards", players: forPlayers);
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
          BlinkContainer(width: 150, height: 30, borderRadius: 0),
          SizedBox(height: 20,),
          BlinkContainer(width: 100, height: 30, borderRadius: 0),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: BlinkContainer(width: double.infinity, height: 30, borderRadius: 15)),
              SizedBox(width: 10,),
              Expanded(child: BlinkContainer(width: double.infinity, height: 30, borderRadius: 15)),
              SizedBox(width: 10,),
              Expanded(child: BlinkContainer(width: double.infinity, height: 30, borderRadius: 15)),
              SizedBox(width: 10,),
              Expanded(child: BlinkContainer(width: double.infinity, height: 30, borderRadius: 15)),
              SizedBox(width: 10,)
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: BlinkContainer(width: double.infinity, height: 30, borderRadius: 15)),
              SizedBox(width: 50,),
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

}
