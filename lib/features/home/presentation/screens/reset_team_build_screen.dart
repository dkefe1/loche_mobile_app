import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/app_header3.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/home/presentation/screens/reset_bench_screen.dart';
import 'package:fantasy/features/home/presentation/widgets/unselected_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetTeamBuildScreen extends StatefulWidget {
  const ResetTeamBuildScreen({super.key});

  @override
  State<ResetTeamBuildScreen> createState() => _ResetTeamBuildScreenState();
}

class _ResetTeamBuildScreenState extends State<ResetTeamBuildScreen> with TickerProviderStateMixin {

  DateTime? currentBackPressTime;

  @override
  void initState() {
    generateFakePlayers();
    super.initState();
  }

  Future generateFakePlayers() async {
    final generatePlayers = Provider.of<SelectedPlayersProvider>(context, listen: false);
    generatePlayers.allPlayers = List.generate(15, (index) => null);
  }

  @override
  Widget build(BuildContext context) {
    return buildInitialInput();
  }

  Widget buildInitialInput(){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<SelectedPlayersProvider>(builder: (context, data, child) {

        List<EntityPlayer?> gkPlayers = data.allPlayers.getRange(0, 2).toList();
        List<EntityPlayer?> defPlayers = data.allPlayers.getRange(2, 7).toList();
        List<EntityPlayer?> midPlayers = data.allPlayers.getRange(7, 12).toList();
        List<EntityPlayer?> forPlayers = data.allPlayers.getRange(12, 15).toList();

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
                  data.credit.toStringAsFixed(1), desc: "Here is the preview of your team with the selected players."),
              Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(defaultBorderRadius))),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/pitch.png"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 20,),
                          unSelectedPlayer(players: gkPlayers, position: "Goalkeeper", value: 0),
                          unSelectedPlayer(players: defPlayers, position: "Defender", value: 2),
                          unSelectedPlayer(players: midPlayers, position: "Midfielder", value: 7),
                          unSelectedPlayer(players: forPlayers, position: "Forward", value: 12),
                          SizedBox(height: 10,)
                        ],),
                    ),
                  )),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 20, 15, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 15,),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: data.selectedPlayers.length != 15 ? null : (){
                            if(data.selectedPlayers.length != 15) {
                              errorFlashBar(context: context, message: "Please select 15 players");
                              return;
                            }
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetTeamBenchScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                            ),
                          ),
                          child: Text("Next", style: TextStyle(color: data.selectedPlayers.length != 15 ? Color(0xFFA7A7A7) : onPrimaryColor, fontSize: 18, fontWeight: FontWeight.w500),)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

}
