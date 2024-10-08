import 'package:fantasy/features/home/data/models/client_player.dart';
import 'package:fantasy/features/home/data/models/club.dart';
import 'package:fantasy/features/home/data/models/entity_player.dart';
import 'package:flutter/material.dart';

class SelectedPlayersProvider extends ChangeNotifier {
  List<EntityPlayer?> allPlayers = [];
  List<EntityPlayer> selectedPlayers = [];
  List<EntityPlayer> substitutePlayers = [];
  num credit = 100;
  List selectedClubs = [];
  bool isCaptainSelected = false;
  bool isViceCaptainSelected = false;
  bool isSwitch = false;
  ClientPlayer? isSwitchSelected;
  ClientPlayer? playerToBeIn;
  ClientPlayer? playerToBeOut;
  ClientPlayer? transferredPlayer;
  // bool deleteLater = false;
  List<Club> categories = [];

  void addAllPlayers(List<EntityPlayer> players){
    allPlayers.addAll(players);
    notifyListeners();
  }

  void addPlayer(EntityPlayer player){
    selectedPlayers.add(player);
    selectedClubs.add(player.clubAbbr);
    notifyListeners();
  }

  void addBenchPlayer(EntityPlayer player){
    player.isBench = true;
    substitutePlayers.add(player);
    notifyListeners();
  }

  void addAllSelectedPlayers(List<EntityPlayer> players){
    selectedPlayers.addAll(players);
    notifyListeners();
  }

  void addAllSubstitutePlayers(List<EntityPlayer> players){
    substitutePlayers.addAll(players);
    notifyListeners();
  }

  void removePlayer(EntityPlayer player){
    selectedPlayers.remove(player);
    selectedClubs.remove(player.clubAbbr);
    notifyListeners();
  }

  void removeBenchPlayer(EntityPlayer player){
    player.isBench = false;
    substitutePlayers.remove(player);
    notifyListeners();
  }

  void removeAllBenchPlayers(){
    for(int i = 0; i<substitutePlayers.length; i++){
      substitutePlayers[i].isBench = false;
    }
    substitutePlayers.clear();
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

  void selectCaptain({required String id}) {
    if(isCaptainSelected){
      for(int i = 0; i<selectedPlayers.length; i++){
        selectedPlayers[i].isCaptain = false;
      }
      for(int i = 0; i<selectedPlayers.length; i++){
        if(id == selectedPlayers[i].pid) {
          selectedPlayers[i].isCaptain = !selectedPlayers[i].isCaptain;
        }
      }
    } else {
      for(int i = 0; i<selectedPlayers.length; i++){
        if(id == selectedPlayers[i].pid) {
          selectedPlayers[i].isCaptain = !selectedPlayers[i].isCaptain;
        }
      }
      isCaptainSelected = !isCaptainSelected;
    }
    notifyListeners();
  }

  void selectViceCaptain({required String id}) {
    if(isViceCaptainSelected){
      for(int i = 0; i<selectedPlayers.length; i++){
        selectedPlayers[i].isViceCaptain = false;
      }
      for(int i = 0; i<selectedPlayers.length; i++){
        if(id == selectedPlayers[i].pid) {
          selectedPlayers[i].isViceCaptain = !selectedPlayers[i].isViceCaptain;
        }
      }
    } else {
      for(int i = 0; i<selectedPlayers.length; i++){
        if(id == selectedPlayers[i].pid) {
          selectedPlayers[i].isViceCaptain = !selectedPlayers[i].isViceCaptain;
        }
      }
      isViceCaptainSelected = !isViceCaptainSelected;
    }
    notifyListeners();
  }

  void removeCaptainAndViceCaptain(){
    for(int i = 0; i<selectedPlayers.length; i++){
      selectedPlayers[i].isCaptain = false;
      selectedPlayers[i].isViceCaptain = false;
    }
    isCaptainSelected = false;
    isViceCaptainSelected = false;
    notifyListeners();
  }

  void switchPlayers(EntityPlayer player1, EntityPlayer player2){

    bool areSelectedPlayers = selectedPlayers.contains(player1) && selectedPlayers.contains(player2);
    bool areSubstitutePlayers = substitutePlayers.contains(player1) && substitutePlayers.contains(player2);

    if(areSubstitutePlayers || areSelectedPlayers){

    } else {
      if(selectedPlayers.contains(player1)){

        print(player1.full_name);
        print("This is the substitute : ${player2.full_name}");

        selectedPlayers.add(player2);
        selectedPlayers.remove(player1);
        substitutePlayers.add(player1);
        substitutePlayers.remove(player2);
      } else {

        print(player2.full_name);
        print("This is the substitute : ${player1.full_name}");

        selectedPlayers.add(player1);
        selectedPlayers.remove(player2);
        substitutePlayers.add(player2);
        substitutePlayers.remove(player1);
      }
    }
    isSwitch = !isSwitch;
    isSwitchSelected = null;
    notifyListeners();
  }

  void transferPlayers(EntityPlayer player){

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
    if(player.is_bench){
      playerToBeIn = player;
    } else {
      playerToBeOut = player;
    }
    notifyListeners();
  }

  void saveTransferredPlayer(ClientPlayer player){
    transferredPlayer = player;
    notifyListeners();
  }

  void replacePlayer(int index, EntityPlayer player){
    allPlayers[index] = player;
    notifyListeners();
  }

  void addCategories(List<Club> clubs){
    categories.addAll(clubs);
    notifyListeners();
  }

}