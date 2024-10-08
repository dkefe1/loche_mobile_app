// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/features/common_widgets/error_flashbar.dart';
// import 'package:fantasy/features/home/data/models/club.dart';
// import 'package:fantasy/features/home/data/models/player.dart';
// import 'package:fantasy/features/home/data/models/selected_players.dart';
// import 'package:fantasy/features/home/presentation/screens/payment_screen.dart';
// import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
// import 'package:fantasy/features/home/presentation/widgets/fantasy_match_widget.dart';
// import 'package:fantasy/features/home/presentation/widgets/preview_component.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
//
// class TeamPreviewScreen extends StatelessWidget {
//   TeamPreviewScreen({Key? key}) : super(key: key);
//
//   List<Club> clubs = [
//     Club(abbr: "Man", logo: "images/team1.png"),
//     Club(abbr: "Che", logo: "images/team2.png")
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<SelectedPlayers>(
//         builder: (context, data, child) {
//
//           List<Player> gkPlayers = data.selectedPlayers.where((player) => player.position == "Gk").toList();
//           List<Player> defPlayers = data.selectedPlayers.where((player) => player.position == "Def").toList();
//           List<Player> midPlayers = data.selectedPlayers.where((player) => player.position == "Mid").toList();
//           List<Player> forPlayers = data.selectedPlayers.where((player) => player.position == "For").toList();
//
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
//             child: Column(children: [
//               AppHeader(
//                   title: "Team Preview",
//                   desc:
//                       "Here is the preview of your team with the selected players."),
//               Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     margin: EdgeInsets.only(top: 20),
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(defaultBorderRadius))),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: 25,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                                   child: fantasyMatchWidget(club1Count: data.selectedClubs.where((club) => club == clubs[0].abbr).toList().length.toString(), club2Count: data.selectedClubs.where((club) => club == clubs[1].abbr).toList().length.toString()),
//                                 ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "Number of selected players ",
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: textColor),
//                                     ),
//                                     Text(
//                                       "(${data.selectedPlayers.length}",
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: textColor),
//                                     ),
//                                     Text(
//                                       "/",
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: textBlackColor),
//                                     ),
//                                     Text(
//                                       "11)",
//                                       style: TextStyle(
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: textColor),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 StepProgressIndicator(
//                                     totalSteps: 11,
//                                     currentStep: data.selectedPlayers.length,
//                                     selectedColor: Colors.black,
//                                     size: 20,
//                                     customStep: (index, color, _) => SvgPicture.asset(
//                                         "images/player.svg",
//                                         color: color == Colors.black ? primaryColor : unSelectedIconColor,
//                                         fit: BoxFit.fill,
//                                         semanticsLabel: 'A player icon'
//                                     )
//                                 ),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text("Team Preview ", style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.w600),),
//                                     Row(
//                                       children: [
//                                         Text("Points ", style: TextStyle(fontSize: 12, color: textBlackColor, fontWeight: FontWeight.w600),),
//                                         Text("(${data.credit} pts)", style: TextStyle(fontSize: 10, color: textColor, fontWeight: FontWeight.w400),),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             height: 428,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(image: AssetImage("images/pitch.png"), fit: BoxFit.cover)
//                             ),
//                             child: Column(
//                               children: [
//                                 previewComponent(players: gkPlayers, top: 60),
//                                 previewComponent(players: defPlayers, top: 20),
//                                 previewComponent(players: midPlayers, top: 28),
//                                 previewComponent(players: forPlayers, top: 28),
//                             ],),
//                           ),
//                           SizedBox(height: 40,),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(vertical: 20),
//                                         decoration: BoxDecoration(
//                                           color: Color(0xFF1E727E).withOpacity(0.12),
//                                             borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Text("Award:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),),
//                                             SizedBox(width: 10,),
//                                             Image.asset("images/reward.png", fit: BoxFit.cover, width: 15, height: 20,),
//                                             SizedBox(width: 5,),
//                                             Text("10,000", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor3),),
//                                             Text("Coin", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: primaryColor3),),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 2,),
//                                     Expanded(
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(vertical: 20),
//                                         decoration: BoxDecoration(
//                                             color: Color(0xFF1E727E).withOpacity(0.12),
//                                           borderRadius: BorderRadius.only(topRight: Radius.circular(5))
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: [
//                                             Text("Contesters:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),),
//                                             SizedBox(width: 10,),
//                                             Text("54+", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor3),),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 2,),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(vertical: 20),
//                                   decoration: BoxDecoration(
//                                       color: Color(0xFF1E727E).withOpacity(0.12),
//                                     borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text("Powered by:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Image.asset("images/powered.png", fit: BoxFit.fill, width: 40, height: 40,),
//                                           SizedBox(width: 5,),
//                                           Text("Zemen Bank", style: TextStyle(color: Color(0xFF000000).withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600),)
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 30,),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Reference:", style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w600),),
//                                 RichText(
//                                   text: TextSpan(
//                                     text: 'Achieve ',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 14,
//                                       color: textBlackColor,),
//                                     children: <TextSpan>[
//                                       TextSpan(
//                                         text: '78+', style: GoogleFonts.poppins(
//                                           color: textBlackColor,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 16),
//                                       ),
//                                       TextSpan(
//                                         text: ' points with your team and claim your rightful place among the winners. Good luck on your journey to triumph!', style: GoogleFonts.poppins(
//                                           color: textBlackColor,
//                                           fontSize: 14),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 50,),
//                                 Center(
//                                   child: ElevatedButton(
//                                       onPressed: (){
//                                         if(data.selectedPlayers.length != 11){
//                                           errorFlashBar(context: context, message: "Please select 11 players");
//                                           return;
//                                         }
//                                         if(data.isCaptainSelected && data.isViceCaptainSelected){
//                                           Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen()));
//                                         } else {
//                                           errorFlashBar(context: context, message: "Please select one captain and one vice captain");
//                                           return;
//                                         }
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: primaryColor,
//                                         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
//                                         side: BorderSide(color: primaryColor, width: 1.0),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(20)
//                                         ),
//                                       ),
//                                       child: Text("Join Contest", style: TextStyle(color: onPrimaryColor, fontSize: 14, fontWeight: FontWeight.w500),)),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 Center(child: Text("Here is the preview of your team with the selected players. Good Luck!",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(color: textColor, fontSize: 12),))
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 40,)
//                         ],
//                       ),
//                     ),
//               )
//               ),
//             ]),
//           );
//         }
//       ),
//     );
//   }
// }
