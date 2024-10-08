import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:flutter/material.dart';

class ClientPlayersProvider extends ChangeNotifier {
  List<ClientPlayer> allPlayers = [];
  List<ClientPlayer> selectedPlayers = [];
  List<ClientPlayer> substitutePlayers = [];
  num credit = 100;
  List selectedClubs = [];
  bool isCaptainSelected = false;
  bool isViceCaptainSelected = false;
  bool isSwitch = false;
  ClientPlayer? isSwitchSelected;
  ClientPlayer? transferredPlayer;
  // bool deleteLater = false;

  void addAllPlayers(List<ClientPlayer> players){
    allPlayers.addAll(players);
    notifyListeners();
  }

  void addPlayer(ClientPlayer player){
    selectedPlayers.add(player);
    selectedClubs.add(player.club);
    notifyListeners();
  }

  void addBenchPlayer(ClientPlayer player){
    substitutePlayers.add(player);
    notifyListeners();
  }

  void addAllSelectedPlayers(List<ClientPlayer> players){
    selectedPlayers.addAll(players);
    notifyListeners();
  }

  void addAllSubstitutePlayers(List<ClientPlayer> players){
    substitutePlayers.addAll(players);
    notifyListeners();
  }

  void removePlayer(ClientPlayer player){
    selectedPlayers.remove(player);
    selectedClubs.remove(player.club);
    notifyListeners();
  }

  void removeBenchPlayer(ClientPlayer player){
    substitutePlayers.remove(player);
    notifyListeners();
  }

  void removeAllPlayers(){
    selectedPlayers.clear();
    selectedClubs.clear();
    substitutePlayers.clear();
    credit = 100;
    isCaptainSelected = false;
    isViceCaptainSelected = false;
    notifyListeners();
  }

  void decreaseCredit(num value) {
    credit = credit - value;
    notifyListeners();
  }

  void increaseCredit(num value) {
    credit = credit + value;
    notifyListeners();
  }

  List<ClientPlayer> switchPlayers(ClientPlayer player1, ClientPlayer player2){

    bool areSelectedPlayers = selectedPlayers.contains(player1) && selectedPlayers.contains(player2);
    bool areSubstitutePlayers = substitutePlayers.contains(player1) && substitutePlayers.contains(player2);

    if(areSubstitutePlayers || areSelectedPlayers){

    } else {
      if(selectedPlayers.contains(player1)){

        print(player1.pid);
        print("This is the substitute : ${player2.pid}");

        selectedPlayers.add(player2);
        selectedPlayers.remove(player1);
        substitutePlayers.add(player1);
        substitutePlayers.remove(player2);
        return [player2, player1];
      } else {

        print(player2.pid);
        print("This is the substitute : ${player1.pid}");

        selectedPlayers.add(player1);
        selectedPlayers.remove(player2);
        substitutePlayers.add(player2);
        substitutePlayers.remove(player1);
        return [player1, player2];
      }
    }
    isSwitch = !isSwitch;
    isSwitchSelected = null;
    notifyListeners();
    return [];
  }

  void transferPlayers(ClientPlayer player){

    bool isSelectedPlayer = selectedPlayers.contains(transferredPlayer!);

    if(isSelectedPlayer){
      selectedPlayers.add(player);
      selectedPlayers.remove(transferredPlayer!);
    } else {
      substitutePlayers.add(player);
      substitutePlayers.remove(transferredPlayer!);
    }
    allPlayers.add(player);
    allPlayers.remove(transferredPlayer!);
    notifyListeners();
  }

  void showSwitch(){
    isSwitch = !isSwitch;
    isSwitchSelected = null;
    notifyListeners();
  }

  void showSwitchSelectedPlayer(ClientPlayer player){
    isSwitchSelected = player;
    notifyListeners();
  }

  void saveTransferredPlayer(ClientPlayer player){
    transferredPlayer = player;
    notifyListeners();
  }

// void transferPlayers(Player player1, Player player2) {
//   selectedPlayers.add(player2);
//   selectedPlayers.remove(player1);
//   notifyListeners();
// }

// void deleteLaterFunction() {
//   deleteLater = true;
// }

}