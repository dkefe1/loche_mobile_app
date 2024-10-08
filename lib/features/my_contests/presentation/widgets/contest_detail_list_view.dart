// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/core/services/assign_kit.dart';
// import 'package:fantasy/features/home/data/models/player.dart';
// import 'package:fantasy/features/home/presentation/widgets/player_detail_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/ic.dart';
//
// Widget contestDetailListView({required String text, required List<Player> players}) {
//
//   Kit kit = Kit();
//
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 12),),
//           text == "Goalkeeper" ? Row(
//             children: [
//               Text("Points", style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 12),),
//               SizedBox(width: 57,)
//             ],
//           ) : SizedBox(),
//         ],
//       ),
//       SizedBox(height: 5,),
//       ListView.builder(
//           padding: EdgeInsets.zero,
//           itemCount: players.length,
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index){
//             return GestureDetector(
//               onTap: (){
//                 showDialog(context: context, builder: (context) {
//                   return playerDetailDialog(player: players[index], context: context);
//                 });
//               },
//               child: Container(
//                 color: Color(0xFF1E727E).withOpacity(0.04),
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 margin: EdgeInsets.only(bottom: 10),
//                 child: ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: Container(
//                     width: 41.79,
//                     height: 38.5,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(image: AssetImage(kit.getKit(team: players[index].club)), fit: BoxFit.fill)
//                     ),
//                     child: Center(child: Text("1", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 9, color: onPrimaryColor),)),
//                   ),
//                   title: Text(players[index].name, style: TextStyle(color: textBlackColor, fontSize: 12, fontWeight: FontWeight.w700),),
//                   subtitle: Text(players[index].position, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w400),),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       players[index].name == "Beka" ? Container(
//                         width: 22,
//                         height: 22,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             color: Color(0xFF1E727E).withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(25)),
//                         child: Text(
//                           "V",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               fontSize: 12,
//                               color: primaryColor),
//                         ),
//                       ) : SizedBox(),
//                       players[index].name == "Nebyu" ? Container(
//                         width: 22,
//                         height: 22,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                             color: Color(0xFF1E727E).withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(25)),
//                         child: Text(
//                           "c",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               fontSize: 12,
//                               color: primaryColor),
//                         ),
//                       ) : SizedBox(),
//                       SizedBox(width: 10,),
//                       Text("0", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: textColor),),
//                       SizedBox(width: 43,),
//                       Container(
//                         width: 30,
//                         height: 30,
//                         padding: EdgeInsets.all(5),
//                         decoration: BoxDecoration(
//                             color: primaryColor,
//                             borderRadius: BorderRadius.circular(100)
//                         ),
//                         child: Iconify(Ic.round_done_all, color: onPrimaryColor,),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           })
//     ],
//   );
// }