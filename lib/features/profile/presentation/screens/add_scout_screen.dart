import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/search_bar.dart';
import 'package:fantasy/features/home/data/models/club.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header2.dart';
import 'package:fantasy/features/profile/presentation/widgets/scout_list.dart';
import 'package:fantasy/features/profile/presentation/widgets/scout_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddScoutScreen extends StatefulWidget {

  List<String> scouts;

  AddScoutScreen({super.key, required this.scouts});

  @override
  State<AddScoutScreen> createState() => _AddScoutScreenState();
}

class _AddScoutScreenState extends State<AddScoutScreen> with TickerProviderStateMixin {

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
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
        child: Column(
          children: [
            appHeader2(
                title: AppLocalizations.of(context)!.add_scout,
                desc:
                AppLocalizations.of(context)!.choose_the_players_you_want_to_add_in_the_scouts_list),
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
                      return buildInitialInput(allPlayers: state.players);
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
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput({required List<EntityPlayer> allPlayers}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        SearchBarWidget(controller: searchController, hintText: AppLocalizations.of(context)!.search_all_players_g, icon: Ri.search_line, onChanged: (){
          setState(() {
            searchedPlayers = allPlayers.where((player) => player.full_name.toUpperCase().contains(searchController.text.toUpperCase())).toList();
          });
        }, clear: (){
          searchController.clear();
          setState(() {
          });
        }),
        SizedBox(height: 10,),
        searchController.text.isEmpty ? SizedBox() : Expanded(child: SingleChildScrollView(child: scoutSearchWidget(searchedPlayers: searchedPlayers, scouts: widget.scouts))),
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
                      hint: Text(AppLocalizations.of(context)!.filter_by_club_g, style: TextStyle(
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
              Text(
                AppLocalizations.of(context)!.select_players,
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
                      return scoutList(players: gkPlayers, scouts: widget.scouts);
                    } else if (_selectedTabbar == 1) {
                      return scoutList(players: defPlayers, scouts: widget.scouts);
                    } else if (_selectedTabbar == 2) {
                      return scoutList(players: midPlayers, scouts: widget.scouts);
                    } else {
                      return scoutList(players: forPlayers, scouts: widget.scouts);
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
