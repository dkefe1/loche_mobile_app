import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/app_header3.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/search_bar.dart';
import 'package:fantasy/features/home/presentation/widgets/player_choice_component.dart';
import 'package:fantasy/features/home/data/models/club.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:fantasy/features/home/presentation/blocs/home_state.dart';
import 'package:fantasy/features/home/presentation/widgets/search_player_choice_component.dart';
import 'package:fantasy/features/home/presentation/widgets/team_build_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:provider/provider.dart';

class PlayerChoiceScreen extends StatefulWidget {

  int index;
  String position;
  PlayerChoiceScreen({super.key, required this.index, required this.position});

  @override
  State<PlayerChoiceScreen> createState() => _PlayerChoiceScreenState();
}

class _PlayerChoiceScreenState extends State<PlayerChoiceScreen> {

  TextEditingController searchController = TextEditingController();
  List<EntityPlayer> searchedPlayers = [];

  Club? selectedClub;

  List<Club> categories = [Club(name: "All Players", logo: "logo", abbr: "abbr")];
  List<String> teamAbbr = [];

  String priceSort = "Price";
  String pointSort = "Point";
  String? defaultSort;


  bool dataLoaded() {
    final data = Provider.of<SelectedPlayersProvider>(context, listen: false);
    if(data.allPlayers.any((player) => player != null)){
      categories = [];
      categories.addAll(data.categories);
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    if(!dataLoaded()){
      final getTransferSquad = BlocProvider.of<TransferSquadBloc>(context);
      getTransferSquad.add(GetTransferSquadEvent());
    }
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
                  title: "Players",
                  budget:
                  "${data.allPlayers[widget.index] != null ? (data.credit + num.parse(data.allPlayers[widget.index]!.price)).toStringAsFixed(1) : data.credit.toStringAsFixed(1)} LC"),
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
                      return buildInitialInput(allPlayers: state.transferSquad.players);
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
                      data.addCategories(categories);
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

  Widget buildInitialInput({required List<EntityPlayer> allPlayers}) {
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
        searchController.text.isEmpty ? SizedBox() : Expanded(child: SingleChildScrollView(child: playerChoiceSearchWidget(searchedPlayers: searchedPlayers.where((player) => player.position == widget.position).toList(), playerIndex: widget.index),)),
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

                    List<EntityPlayer> players =
                    allPlayers.where((player) => player.position == widget.position).toList();

                    if(defaultSort == pointSort){
                      players = players..sort((a, b) => b.point.compareTo(a.point));
                    } else {
                      players = players..sort((a, b) => num.parse(b.price).compareTo(num.parse(a.price)));
                    }

                    return playerChoiceComponent(text: "2 Goal Keepers", players: players, playerIndex: widget.index);

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
