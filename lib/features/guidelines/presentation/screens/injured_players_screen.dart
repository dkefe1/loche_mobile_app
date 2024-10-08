import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/no_data_widget.dart';
import 'package:fantasy/features/common_widgets/search_bar.dart';
import 'package:fantasy/features/guidelines/data/models/injury_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/injured_players_list_widget.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/player_stat_header.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/search_injured_widget.dart';
import 'package:fantasy/features/home/data/models/club.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InjuredPlayersScreen extends StatefulWidget {
  const InjuredPlayersScreen({super.key});

  @override
  State<InjuredPlayersScreen> createState() => _InjuredPlayersScreenState();
}

class _InjuredPlayersScreenState extends State<InjuredPlayersScreen> with SingleTickerProviderStateMixin {

  TextEditingController searchController = TextEditingController();
  List<InjuryModel> searchedPlayers = [];

  Club? selectedClub;

  List<Club> categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
  List<String> teamAbbr = [];

  int _selectedTabbar = 0;
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    final getInjuredPlayers = BlocProvider.of<InjuredPlayerBloc>(context);
    getInjuredPlayers.add(GetInjuredPlayerEvent(false));
    super.initState();
  }

  @override
  void dispose() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              playerStatHeader(
                  title: AppLocalizations.of(context)!.injured_banned_players),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
                child: TabBar(
                    onTap: (index) {
                      setState(() {
                        _selectedTabbar = index;
                        tabController.animateTo(index,
                            duration: Duration(seconds: 2));
                      });
                      if(index == 0){
                        final getInjuredPlayers = BlocProvider.of<InjuredPlayerBloc>(context);
                        getInjuredPlayers.add(GetInjuredPlayerEvent(false));
                      } else{
                        final getInjuredPlayers = BlocProvider.of<InjuredPlayerBloc>(context);
                        getInjuredPlayers.add(GetInjuredPlayerEvent(true));
                      }
                    },
                    controller: tabController,
                    tabs: [
                      Tab(
                          child: Text(
                            "All",
                            style:
                            GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                          )),
                      Tab(
                          child: Text(
                            "Latest",
                            style:
                            GoogleFonts.poppins(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                          )),
                    ]),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,),
                  child: BlocConsumer<InjuredPlayerBloc, InjuredPlayerState>(builder: (_, state){
                    if (state is GetInjuredPlayerSuccessfulState) {
                      return buildInitialInput(allPlayers: state.injuredPlayers);
                    } else if (state is GetInjuredPlayerLoadingState) {
                      return squadLoading();
                    } else if (state is GetInjuredPlayerFailedState) {
                      return errorView(
                          iconPath: state.error == socketErrorMessage
                              ? "images/connection.png"
                              : "images/error.png",
                          title: "Ooops!",
                          text: state.error,
                          onPressed: () {
                            final getInjuredPlayers = BlocProvider.of<InjuredPlayerBloc>(context);
                            getInjuredPlayers.add(GetInjuredPlayerEvent(_selectedTabbar == 0 ? false : true));
                          });
                    } else {
                      return SizedBox();
                    }
                  }, listener: (_, state){
                    if(state is GetInjuredPlayerSuccessfulState){
                      List<Club> clubs = [];
                      categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
                      teamAbbr = [];
                      for(int i=0; i<state.injuredPlayers.length; i++){
                        if(teamAbbr.contains(state.injuredPlayers[i].injuredPlayer.tname)){
                          continue;
                        } else {
                          teamAbbr.add(state.injuredPlayers[i].injuredPlayer.tname);
                          clubs.add(Club(name: state.injuredPlayers[i].injuredPlayer.tname, logo: state.injuredPlayers[i].injuredPlayer.tlogo, abbr: state.injuredPlayers[i].injuredPlayer.tname));
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
        ),
    );
  }

  Widget buildInitialInput({required List<InjuryModel> allPlayers}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        SearchBarWidget(controller: searchController, hintText: AppLocalizations.of(context)!.search_all_players, icon: Ri.search_line, onChanged: (){
          setState(() {
            searchedPlayers = allPlayers.where((player) => player.injuredPlayer.pname.toUpperCase().contains(searchController.text.toUpperCase())).toList();
          });
        }, clear: (){
          searchController.clear();
          setState(() {
          });
        }),
        SizedBox(height: 10,),
        searchController.text.isEmpty ? SizedBox() : Expanded(child: SingleChildScrollView(child: searchedInjuredPlayerWidget(searchedPlayers: searchedPlayers))),
        searchController.text.isNotEmpty ? SizedBox() : Expanded(
          child: Column(
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
              SizedBox(height: 10,),
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () async {
                    final getInjuredPlayers = BlocProvider.of<InjuredPlayerBloc>(context);
                    getInjuredPlayers.add(GetInjuredPlayerEvent(_selectedTabbar == 0 ? false : true));
                    return await Future.delayed(Duration(seconds: 2));
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Builder(builder: (_) {

                      if(selectedClub != null){
                        if(selectedClub!.name == "All Players"){
                          allPlayers = allPlayers;
                        } else {
                          allPlayers = allPlayers.where((player) => player.injuredPlayer.tname == selectedClub!.abbr).toList();
                        }
                      }

                      return allPlayers.isEmpty ? Center(child: noDataWidget(icon: MaterialSymbols.personal_injury, message: AppLocalizations.of(context)!.no_players_on_the_list, iconSize: 120, iconColor: textColor)) : injuredPlayerList(players: allPlayers);
                    }),
                  ),
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

