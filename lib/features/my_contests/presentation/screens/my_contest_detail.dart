// import 'dart:async';
//
// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/features/home/data/models/player.dart';
// import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
// import 'package:fantasy/features/home/presentation/widgets/preview_component.dart';
// import 'package:fantasy/features/my_contests/presentation/widgets/contest_detail_list_view.dart';
// import 'package:fantasy/features/my_contests/presentation/widgets/contest_detail_match_box.dart';
// import 'package:fantasy/features/my_contests/presentation/widgets/leaderboard_widget.dart';
// import 'package:fantasy/features/my_contests/presentation/widgets/result_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class MyContestDetailScreen extends StatefulWidget {
//   MyContestDetailScreen({Key? key, required this.isCompleted, required this.hasWon}) : super(key: key);
//
//   bool isCompleted, hasWon;
//
//   @override
//   State<MyContestDetailScreen> createState() => _MyContestDetailScreenState();
// }
//
// class _MyContestDetailScreenState extends State<MyContestDetailScreen> {
//
//   bool isPitchView = false;
//
//   List<Player> gkPlayers = [
//     Player(id: 1,name: "Degea", position: "Gk", club: "Man", point: 9),
//   ];
//
//   List<Player> defPlayers = [
//     Player(id: 5,name: "Martinez", position: "Def", club: "Man", point: 10),
//     Player(id: 6,name: "Varane", position: "Def", club: "Man", point: 10),
//     Player(id: 7,name: "Beka", position: "Def", club: "Man", point: 9),
//     Player(id: 8,name: "Becker", position: "Def", club: "Man", point: 9),
//   ];
//
//   List<Player> midPlayers = [
//     Player(id: 34,name: "Varane", position: "Mid", club: "Che", point: 7.5),
//     Player(id: 35,name: "Nebyu", position: "Mid", club: "Che", point: 8),
//     Player(id: 36,name: "Becker", position: "Mid", club: "Che", point: 8.5),
//   ];
//
//   List<Player> forPlayers = [
//     Player(id: 37,name: "Martinez", position: "For", club: "Man", point: 10),
//     Player(id: 38,name: "Varane", position: "For", club: "Man", point: 10),
//     Player(id: 39,name: "Onana", position: "For", club: "Man", point: 9),
//   ];
//
//   List contestors = ["Jaydon Siphron", "Cooper Bator", "Davis Stanton", "Justin Bergson", "Lincoln Septimus"];
//   List contestors2 = ["Jaydon Siphron", "Cooper Bator", "Davis Stanton", "Justin Bergson", "Lincoln Septimus"];
//
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
//         child: Column(
//           children: [
//             AppHeader(
//                 title: "",
//                 desc:
//                 "Explore the exciting details of your contest and best of luck on your journey to victory!"),
//             Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   margin: EdgeInsets.only(top: 20),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                       BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 30,
//                               ),
//                               Text(
//                                 "Contest Details",
//                                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                               ),
//                               SizedBox(height: 10,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                                 child: contestDetailMatchBox(isCompleted: widget.isCompleted),
//                               ),
//                               SizedBox(height: 30,),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Team List",
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                         color: textColor),
//                                   ),
//                                   widget.isCompleted ? SizedBox() : GestureDetector(
//                                     onTap: (){
//                                       setState(() {
//                                         isPitchView = !isPitchView;
//                                       });
//                                     },
//                                     child: Text(
//                                       isPitchView ? "List view" : "Pitch view",
//                                       style: TextStyle(
//                                           decoration: TextDecoration.underline,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: primaryColor),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 10,),
//                             ],
//                           ),
//                         ),
//                         isPitchView ? Container(
//                           height: 428,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               image: DecorationImage(image: AssetImage("images/pitch.png"), fit: BoxFit.cover)
//                           ),
//                           child: Column(
//                             children: [
//                               previewComponent(players: gkPlayers, top: 60),
//                               previewComponent(players: defPlayers, top: 20),
//                               previewComponent(players: midPlayers, top: 28),
//                               previewComponent(players: forPlayers, top: 28),
//                             ],),
//                         ) : Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             children: [
//                               contestDetailListView(text: "Goalkeeper", players: gkPlayers),
//                               contestDetailListView(text: "Defenders", players: defPlayers),
//                               contestDetailListView(text: "Midfielders", players: midPlayers),
//                               contestDetailListView(text: "Attackers", players: forPlayers),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 40,),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(vertical: 20),
//                                       decoration: BoxDecoration(
//                                           color: widget.isCompleted ? completedSurfaceColor : Color(0xFF1E727E).withOpacity(0.12),
//                                           borderRadius: BorderRadius.only(topLeft: Radius.circular(5))
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text("Award:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),),
//                                           SizedBox(width: 10,),
//                                           Image.asset("images/reward.png", fit: BoxFit.cover, width: 15, height: 20,),
//                                           SizedBox(width: 5,),
//                                           Text("10,000", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor3),),
//                                           Text("Coin", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: primaryColor3),),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 2,),
//                                   Expanded(
//                                     child: Container(
//                                       padding: EdgeInsets.symmetric(vertical: 20),
//                                       decoration: BoxDecoration(
//                                           color: widget.isCompleted ? completedSurfaceColor : Color(0xFF1E727E).withOpacity(0.12),
//                                           borderRadius: BorderRadius.only(topRight: Radius.circular(5))
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text("Contestors:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),),
//                                           SizedBox(width: 10,),
//                                           Text("54+", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor3),),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 2,),
//                               Container(
//                                 padding: EdgeInsets.symmetric(vertical: 20),
//                                 decoration: BoxDecoration(
//                                     color: widget.isCompleted ? completedSurfaceColor : Color(0xFF1E727E).withOpacity(0.12),
//                                     borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
//                                 ),
//                                 child: widget.isCompleted ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text("Total Points:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),),
//                                     SizedBox(width: 10,),
//                                     Text("84", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor),),
//                                   ],
//                                 ) : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text("Powered by:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset("images/powered.png", fit: BoxFit.fill, width: 40, height: 40,),
//                                         SizedBox(width: 5,),
//                                         Text("Zemen Bank", style: TextStyle(color: Color(0xFF000000).withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w600),)
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               widget.isCompleted ? SizedBox(height: 20,) : SizedBox(),
//                               widget.isCompleted ? widget.hasWon ? resultWidget(icon: "images/won.png", iconWidth: 95, iconHeight: 87.56, msg: "Congratulations! You have surpassed the reference point and achieved a top ten score among the contestants. You are now one of the lucky winners of the jackpot! Well done") : resultWidget(icon: "images/lost.png", iconWidth: 67, iconHeight: 67, msg: "Unfortunately, you didn't win this time as your entry didn't make it to the top ten. Don't worry, there are more exciting contests awaiting you! We appreciate your participation and encourage you to keep trying. Good luck with your next contest!") : SizedBox(),
//                               widget.isCompleted ? SizedBox(height: 40,) : SizedBox(),
//                               widget.isCompleted ? leaderBoardWidget(contestors: contestors, isLoading: isLoading, onPressed: () async {
//                                 setState(() {
//                                   isLoading = true;
//                                 });
//                                 await Future.delayed(Duration(seconds: 2));
//                                 setState(() {
//                                   contestors.addAll(contestors2);
//                                   isLoading = false;
//                                 });
//                               }) : SizedBox(),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30,),
//                         widget.isCompleted ? SizedBox() : Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Reference:", style: TextStyle(fontSize: 14, color: textColor, fontWeight: FontWeight.w600),),
//                               RichText(
//                                 text: TextSpan(
//                                   text: 'Achieve ',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 14,
//                                     color: textBlackColor,),
//                                   children: <TextSpan>[
//                                     TextSpan(
//                                       text: '78+', style: GoogleFonts.poppins(
//                                         color: textBlackColor,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16),
//                                     ),
//                                     TextSpan(
//                                       text: ' points with your team and claim your rightful place among the winners. Good luck on your journey to triumph!', style: GoogleFonts.poppins(
//                                         color: textBlackColor,
//                                         fontSize: 14),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 40,),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 23.0),
//                                 child: Center(child: Text("Stay patient until the final result is revealed. Best of luck on your thrilling journey!",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(color: textColor, fontSize: 12),)),
//                               ),
//                               SizedBox(height: 40,),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
//
// }
