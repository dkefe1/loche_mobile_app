// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/core/services/assign_kit.dart';
// import 'package:fantasy/features/common_widgets/error_flashbar.dart';
// import 'package:fantasy/features/home/data/models/player.dart';
// import 'package:fantasy/features/home/data/models/selected_players.dart';
// import 'package:fantasy/features/home/presentation/widgets/player_detail_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/ic.dart';
// import 'package:iconify_flutter/icons/material_symbols.dart';
// import 'package:provider/provider.dart';
//
// Widget playerList({required String text, required List<Player> players}) {
//
//   Kit kit = Kit();
//
//   return Consumer<SelectedPlayers>(
//     builder: (context, data, child) {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Text("Players ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
//                   Text("(Select ${text})", style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w400),),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text("Points ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
//                   Text("(${data.credit} pts)", style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w400),),
//                 ],
//               ),
//             ],
//           ),
//           ListView.builder(
//               itemCount: players.length,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: (){
//                     showDialog(context: context, builder: (context) {
//                       return playerDetailDialog(player: players[index], context: context);
//                     });
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: Container(
//                       color: Color(0xFF1E727E).withOpacity(0.04),
//                       child: ListTile(
//                         leading: Container(
//                           width: 41.79,
//                           height: 38.5,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(image: AssetImage(kit.getKit(team: players[index].club)), fit: BoxFit.fill)
//                           ),
//                           child: Center(child: Text("1", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 9, color: onPrimaryColor),)),
//                         ),
//                         title: Text(players[index].name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
//                         subtitle: Text(players[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(players[index].point.toString(), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
//                             SizedBox(width: 20,),
//                             data.selectedPlayers.contains(players[index]) ? GestureDetector(
//                               onTap: () {
//                                 data.removePlayer(players[index]);
//                                 data.increaseCredit(players[index].point);
//                               },
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 padding: EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                     color: primaryColor,
//                                     borderRadius: BorderRadius.circular(100)
//                                 ),
//                                 child: Iconify(Ic.round_done_all, color: onPrimaryColor,),
//                               ),
//                             ) :  GestureDetector(
//                               onTap: () {
//                                 bool isGkSelected = data.selectedPlayers.any((player) => player.position == "Gk");
//                                 bool isForSelected = data.selectedPlayers.any((player) => player.position == "For");
//                                 int maxForward = 0;
//                                 int maxDefense = 0;
//                                 int maxMidfield = 0;
//
//                                 for(final player in data.selectedPlayers){
//                                   if(player.position == "For"){
//                                     maxForward++;
//                                   } else if(player.position == "Def"){
//                                     maxDefense++;
//                                   } else if(player.position == "Mid"){
//                                     maxMidfield++;
//                                   }
//                                 }
//
//                                 bool hasMoreThan7Players(List selectedClubs) {
//                                   Map<String, int> clubCount = {};
//
//                                   for (var club in selectedClubs) {
//                                     clubCount[club] = (clubCount[club] ?? 0) + 1;
//                                     if (clubCount[club]! > 6 && players[index].club == club) {
//                                       return true;
//                                     }
//                                   }
//
//                                   return false;
//                                 }
//
//                                 if (data.selectedPlayers.length == 11) {
//                                   errorFlashBar(context: context, message: "Maximum of 11 players allowed");
//                                   return;
//                                 }
//
//                                 if (isGkSelected && players[index].position == "Gk") {
//                                   errorFlashBar(context: context, message: "Maximum of 1 goalkeeper allowed");
//                                   return;
//                                 }
//
//                                 if (!isForSelected && players[index].position != "For" && data.selectedPlayers.length == 10) {
//                                   errorFlashBar(context: context, message: "Please select at least 1 forward");
//                                   return;
//                                 }
//
//                                 if(maxDefense < 2 && players[index].position != "Def" && data.selectedPlayers.length >= 8){
//                                   errorFlashBar(context: context, message: "Please select at least 3 defenders");
//                                   return;
//                                 }
//
//                                 if(maxMidfield < 2 && players[index].position != "Mid" && data.selectedPlayers.length >= 8){
//                                   errorFlashBar(context: context, message: "Please select at least 3 midfielders");
//                                   return;
//                                 }
//
//                                 if (maxForward > 2 && players[index].position == "For") {
//                                   errorFlashBar(context: context, message: "Maximum of 3 forwards allowed");
//                                   return;
//                                 }
//
//                                 if (maxDefense > 4 && players[index].position == "Def") {
//                                   errorFlashBar(context: context, message: "Maximum of 5 defenders allowed");
//                                   return;
//                                 }
//
//                                 if (maxMidfield > 4 && players[index].position == "Mid") {
//                                   errorFlashBar(context: context, message: "Maximum of 5 midfielders allowed");
//                                   return;
//                                 }
//
//                                 if (hasMoreThan7Players(data.selectedClubs)) {
//                                   errorFlashBar(context: context, message: "A maximum of 7 players from each team allowed");
//                                   return;
//                                 }
//
//                                 if (players[index].point > data.credit) {
//                                   errorFlashBar(context: context, message: "You don't have the credit to select this player");
//                                   return;
//                                 }
//
//                                 data.addPlayer(players[index]);
//                                 data.decreaseCredit(players[index].point);
//                               },
//                               child: Iconify(MaterialSymbols.add_circle_outline_rounded, color: primaryColor, size: 30,),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               })
//         ],
//       );
//     }
//   );
// }