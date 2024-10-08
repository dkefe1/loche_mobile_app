// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/features/common_widgets/advertisment_section.dart';
// import 'package:fantasy/features/home/presentation/screens/create_team_screen.dart';
// import 'package:fantasy/features/home/presentation/widgets/match_component.dart';
// import 'package:flutter/material.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/jam.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: Container(
//       width: double.infinity,
//       margin: EdgeInsets.only(top: 20),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius:
//               BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 30,
//                   ),
//                   AdvertisementSection(),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     decoration: BoxDecoration(
//                       color: dangerBgColor,
//                       borderRadius: BorderRadius.circular(12)
//                     ),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Iconify(Jam.triangle_danger_f, color: onDangerBgColor, size: 40,),
//                         SizedBox(width: 10,),
//                         Expanded(child: Text("Running low on credit! Don't miss out on the excitement. Top up now and continue playing. Click here to make a deposit.", textAlign: TextAlign.justify, style: TextStyle(color: onDangerBgColor, fontSize: 12, fontWeight: FontWeight.w600),))
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                   Row(
//                     children: [
//                       Text(
//                         "Popular Players",
//                         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                       ),
//                       Text(
//                         " (This Week)",
//                         style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: textColor),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10,),
//                   SizedBox(
//                     height: 120,
//                     child: ListView.builder(
//                         itemCount: 9,
//                         shrinkWrap: true,
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(right: 20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   width: 61,
//                                   height: 56.64,
//                                   decoration: BoxDecoration(
//                                       image: DecorationImage(image: AssetImage("images/kits/jersey.png"))
//                                   ),
//                                   child: Center(
//                                     child: Text("9", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),),
//                                   ),
//                                 ),
//                                 SizedBox(height: 5,),
//                                 Text("Haaland", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textBlackColor),),
//                                 Text("Attacker", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),),
//                                 Text("9.5", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: primaryColor2),),
//                               ],
//                             ),
//                           );
//                         }),
//                   ),
//                   SizedBox(height: 20,),
//                   Text(
//                     "Today's Match",
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                   ),
//                   SizedBox(height: 10,),
//                 ],
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Color(0xFF1E727E).withOpacity(0.1)
//               ),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(2),
//                       child: Image.asset("images/flag2.png", width: 19.83, height: 14, fit: BoxFit.fill,)),
//                   SizedBox(width: 10,),
//                   Text("UEFA Champions League", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),)
//                 ],
//               ),
//             ),
//             SizedBox(height: 10,),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                   itemCount: 2,
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                 return matchComponent(onPressed: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTeamScreen()));
//                 });
//               }),
//             ),
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//               decoration: BoxDecoration(
//                   color: Color(0xFF1E727E).withOpacity(0.1)
//               ),
//               child: Row(
//                 children: [
//                   ClipRRect(
//                       borderRadius: BorderRadius.circular(2),
//                       child: Image.asset("images/flag1.png", width: 19.83, height: 14, fit: BoxFit.fill,)),
//                   SizedBox(width: 10,),
//                   Text("Premier League", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),)
//                 ],
//               ),
//             ),
//             SizedBox(height: 10,),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: 9,
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return matchComponent(onPressed: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTeamScreen()));
//                     });
//                   }),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }
