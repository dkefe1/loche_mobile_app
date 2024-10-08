// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/features/common_widgets/error_flashbar.dart';
// import 'package:fantasy/features/home/data/models/club.dart';
// import 'package:fantasy/features/home/data/models/entity_player.dart';
// import 'package:fantasy/features/home/data/models/player.dart';
// import 'package:fantasy/features/home/data/models/selected_players.dart';
// import 'package:fantasy/features/home/presentation/screens/payment_screen.dart';
// import 'package:fantasy/features/home/presentation/screens/team_preview_screen.dart';
// import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
// import 'package:fantasy/features/home/presentation/widgets/create_captain_component.dart';
// import 'package:fantasy/features/home/presentation/widgets/fantasy_match_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class CreateCaptainScreen extends StatelessWidget {
//   CreateCaptainScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<SelectedPlayers>(builder: (context, data, child) {
//         List<EntityPlayer> gkPlayers = data.selectedPlayers
//             .where((player) => player.position == "Goalkeeper")
//             .toList();
//         List<EntityPlayer> defPlayers = data.selectedPlayers
//             .where((player) => player.position == "Defender")
//             .toList();
//         List<EntityPlayer> midPlayers = data.selectedPlayers
//             .where((player) => player.position == "Midfielder")
//             .toList();
//         List<EntityPlayer> forPlayers = data.selectedPlayers
//             .where((player) => player.position == "Forward")
//             .toList();
//
//         return Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
//           child: Column(
//             children: [
//               AppHeader(
//                   title: "Create Team",
//                   desc:
//                       "Assemble your winning squad by choosing players from both teams."),
//               Expanded(
//                   child: Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.only(top: 20),
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(defaultBorderRadius))),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                         child: fantasyMatchWidget(
//                             club1Count: data.selectedClubs
//                                 .where((club) => club == clubs[0].abbr)
//                                 .toList()
//                                 .length
//                                 .toString(),
//                             club2Count: data.selectedClubs
//                                 .where((club) => club == clubs[1].abbr)
//                                 .toList()
//                                 .length
//                                 .toString()),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         "Choose your captains and Vice Captains",
//                         style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: textColor),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 width: 50,
//                                 height: 50,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     color: Color(0xFF1E727E).withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(25)),
//                                 child: Text(
//                                   "C",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: 18,
//                                       color: primaryColor),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Captains",
//                                     style: TextStyle(
//                                         color: textBlackColor,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Gets ",
//                                         style: TextStyle(
//                                             color: Color(0xFF000000)
//                                                 .withOpacity(0.3),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                       Text(
//                                         "2x ",
//                                         style: TextStyle(
//                                             color: Color(0xFF000000)
//                                                 .withOpacity(0.3),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                       Text(
//                                         "Points",
//                                         style: TextStyle(
//                                             color: Color(0xFF000000)
//                                                 .withOpacity(0.3),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 width: 50,
//                                 height: 50,
//                                 alignment: Alignment.center,
//                                 decoration: BoxDecoration(
//                                     color: Color(0xFF1E727E).withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(25)),
//                                 child: Text(
//                                   "v",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: 18,
//                                       color: primaryColor),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Vice Captains",
//                                     style: TextStyle(
//                                         color: textBlackColor,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         "Gets ",
//                                         style: TextStyle(
//                                             color: Color(0xFF000000)
//                                                 .withOpacity(0.3),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                       Text(
//                                         "1.5x ",
//                                         style: TextStyle(
//                                             color: Color(0xFF000000)
//                                                 .withOpacity(0.3),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                       Text(
//                                         "Points",
//                                         style: TextStyle(
//                                             color: Color(0xFF000000)
//                                                 .withOpacity(0.3),
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w400),
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Select Players",
//                         style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: textColor),
//                       ),
//                       ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         title: Text(
//                           "Players",
//                           style: TextStyle(
//                               color: textBlackColor,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600),
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               "Captain",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 12),
//                             ),
//                             SizedBox(
//                               width: 20,
//                             ),
//                             Text(
//                               "V.Captain",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ),
//                       createCaptainComponent(
//                         text: "Goalkeepers",
//                         players: gkPlayers,
//                         onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
//                           if(isAddButton){
//                             if(isPlayerViceCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one captain");
//                               return;
//                             }
//                           }
//                           data.selectCaptain(id: id);
//                         },
//                         onTapVice: (id, isAddButton, isPlayerCaptain) {
//                           if(isAddButton){
//                             if(isPlayerCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isViceCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one vice captain");
//                               return;
//                             }
//                           }
//                           data.selectViceCaptain(id: id);
//                         },
//                       ),
//                       createCaptainComponent(
//                         text: "Defenders",
//                         players: defPlayers,
//                         onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
//                           if(isAddButton){
//                             if(isPlayerViceCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one captain");
//                               return;
//                             }
//                           }
//                           data.selectCaptain(id: id);
//                         },
//                         onTapVice: (id, isAddButton, isPlayerCaptain) {
//                           if(isAddButton){
//                             if(isPlayerCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isViceCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one vice captain");
//                               return;
//                             }
//                           }
//                           data.selectViceCaptain(id: id);
//                         },
//                       ),
//                       createCaptainComponent(
//                         text: "Midfielders",
//                         players: midPlayers,
//                         onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
//                           if(isAddButton){
//                             if(isPlayerViceCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one captain");
//                               return;
//                             }
//                           }
//                           data.selectCaptain(id: id);
//                         },
//                         onTapVice: (id, isAddButton, isPlayerCaptain) {
//                           if(isAddButton){
//                             if(isPlayerCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isViceCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one vice captain");
//                               return;
//                             }
//                           }
//                           data.selectViceCaptain(id: id);
//                         },
//                       ),
//                       createCaptainComponent(
//                         text: "Attackers",
//                         players: forPlayers,
//                         onTapCaptain: (id, isAddButton, isPlayerViceCaptain) {
//                           if(isAddButton){
//                             if(isPlayerViceCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one captain");
//                               return;
//                             }
//                           }
//                           data.selectCaptain(id: id);
//                         },
//                         onTapVice: (id, isAddButton, isPlayerCaptain) {
//                           if(isAddButton){
//                             if(isPlayerCaptain){
//                               errorFlashBar(context: context, message: "Player can not be both captain and vice captain");
//                               return;
//                             }
//                             if(data.isViceCaptainSelected){
//                               errorFlashBar(context: context, message: "You can only select one vice captain");
//                               return;
//                             }
//                           }
//                           data.selectViceCaptain(id: id);
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               )),
//               Container(
//                 color: Colors.white,
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => TeamPreviewScreen()));
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: backgroundColor,
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 20),
//                             side: BorderSide(color: primaryColor, width: 1.0),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20)),
//                           ),
//                           child: Text(
//                             "Team Preview",
//                             style: TextStyle(
//                                 color: primaryColor,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500),
//                           )),
//                     ),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Expanded(
//                       child: ElevatedButton(
//                           onPressed: () {
//                             if(data.isViceCaptainSelected && data.isCaptainSelected){
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
//                             } else {
//                               errorFlashBar(context: context, message: "Please select one captain and one vice captain");
//                               return;
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryColor,
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 20),
//                             side: BorderSide(color: primaryColor, width: 1.0),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20)),
//                           ),
//                           child: Text(
//                             "Join Contest",
//                             style: TextStyle(
//                                 color: onPrimaryColor,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500),
//                           )),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
