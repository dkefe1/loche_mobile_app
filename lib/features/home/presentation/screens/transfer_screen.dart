import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/app_header3.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/search_bar.dart';
import 'package:fantasy/features/fixture/data/models/match.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/guidelines/data/models/player_stat.dart';
import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/presentation/widgets/searched_players.dart';
import 'package:fantasy/features/home/data/models/club.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/widgets/transfer_player_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:provider/provider.dart';

class TransferScreen extends StatefulWidget {

  List<String> myPlayersId;
  int tab;
  String budget;
  ClientPlayer player;
  List<MatchModel> matches;
  TransferScreen({super.key, required this.myPlayersId, required this.budget, required this.tab, required this.player, required this.matches});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> with TickerProviderStateMixin {

  int _selectedTabbar = 0;
  late TabController tabController;
  
  TextEditingController searchController = TextEditingController();
  List<EntityPlayer> searchedPlayers = [];

  Club? selectedClub;

  List<Club> categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
  List<String> teamAbbr = [];

  String priceSort = "Price";
  String pointSort = "Point";
  String? defaultSort;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    final getSquad = BlocProvider.of<TransferSquadBloc>(context);
    getSquad.add(GetTransferSquadEvent());
    setState(() {
      _selectedTabbar = widget.tab;
      tabController.animateTo(widget.tab,
          duration: Duration(seconds: 2));
    });
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
              appHeader3(
                  title: "Transfer",
                  budget:
                  "${(num.parse(widget.budget) + widget.player.price).toStringAsFixed(1)} LC"),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(defaultBorderRadius))),
                    child: BlocConsumer<TransferSquadBloc, TransferSquadState>(builder: (_, state){
                      if (state is GetTransferSquadSuccessfulState) {
                        return buildInitialInput(allPlayers: state.transferSquad.players, budget: num.parse(widget.budget), injuredPlayers: state.transferSquad.injuredPlayers);
                      } else if (state is GetTransferSquadLoadingState) {
                        return squadLoading();
                      } else if (state is GetTransferSquadFailedState) {
                        return errorView(
                            iconPath: state.error == socketErrorMessage
                                ? "images/connection.png"
                                : "images/error.png",
                            title: "Ooops!",
                            text: state.error,
                            onPressed: () {
                              final getSquad = BlocProvider.of<TransferSquadBloc>(context);
                              getSquad.add(GetTransferSquadEvent());
                            });
                      } else {
                        return SizedBox();
                      }
                    }, listener: (_, state){
                      if(state is GetTransferSquadSuccessfulState){
                        List<Club> clubs = [];
                        categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
                        teamAbbr = [];
                        for(int i=0; i<state.transferSquad.players.length; i++){
                          if(teamAbbr.contains(state.transferSquad.players[i].clubAbbr)){
                            continue;
                          } else {
                            teamAbbr.add(state.transferSquad.players[i].clubAbbr);
                            clubs.add(Club(name: state.transferSquad.players[i].clubName, logo: state.transferSquad.players[i].club_logo, abbr: state.transferSquad.players[i].clubAbbr));
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

  Widget buildInitialInput({required List<EntityPlayer> allPlayers, required num budget, required List<InjuryModel> injuredPlayers}) {
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
        searchController.text.isEmpty ? SizedBox() : Expanded(child: SingleChildScrollView(child: searchedPlayersWidget(searchedPlayers: searchedPlayers, myPlayersId: widget.myPlayersId, budget: budget, matches: widget.matches, injuredPlayers: injuredPlayers))),
        searchController.text.isNotEmpty ? SizedBox() : Expanded(
          child: Column(
            children: [
              Row(
                children: [
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
                  ),
                  SizedBox(width: 10,),
                  PopupMenuButton(
                    child: Icon(Icons.sort, color: primaryColor, size: 35,),
                    itemBuilder: (context) => [
                      PopupMenuItem(child: Text(
                        pointSort,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: textFontSize2,
                            fontWeight: FontWeight.w500),
                      ),
                      value: pointSort,),
                      PopupMenuItem(child: Text(
                        priceSort,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: textFontSize2,
                            fontWeight: FontWeight.w500),
                      ),
                        value: priceSort,)
                    ],
                  onSelected: (value){
                      setState(() {
                        defaultSort = value;
                      });
                  },
                  )
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
                      "GK",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "DEF",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "MID",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "FOR",
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
                        allPlayers = allPlayers.where((player) => player.clubAbbr == selectedClub!.abbr).toList();
                      }
                    }

                    if(defaultSort == pointSort){
                      allPlayers = allPlayers..sort((a, b) => b.point.compareTo(a.point));
                    } else {
                      allPlayers = allPlayers..sort((a, b) => num.parse(b.price).compareTo(num.parse(a.price)));
                    }

                    List<EntityPlayer> gkPlayers =
                    allPlayers.where((player) => player.position == "Goalkeeper").toList();
                    List<EntityPlayer> defPlayers =
                    allPlayers.where((player) => player.position == "Defender").toList();
                    List<EntityPlayer> midPlayers =
                    allPlayers.where((player) => player.position == "Midfielder").toList();
                    List<EntityPlayer> forPlayers =
                    allPlayers.where((player) => player.position == "Forward").toList();

                    if (_selectedTabbar == 0) {
                      return transferPlayerList(players: gkPlayers, myPlayersId: widget.myPlayersId, budget: budget, matches: widget.matches, injuredPlayers: injuredPlayers);
                    } else if (_selectedTabbar == 1) {
                      return transferPlayerList(players: defPlayers, myPlayersId: widget.myPlayersId, budget: budget, matches: widget.matches, injuredPlayers: injuredPlayers);
                    } else if (_selectedTabbar == 2) {
                      return transferPlayerList(players: midPlayers, myPlayersId: widget.myPlayersId, budget: budget, matches: widget.matches, injuredPlayers: injuredPlayers);
                    } else {
                      return transferPlayerList(players: forPlayers, myPlayersId: widget.myPlayersId, budget: budget, matches: widget.matches, injuredPlayers: injuredPlayers);
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

}
