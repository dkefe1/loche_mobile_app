// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/features/my_contests/presentation/screens/my_contest_detail.dart';
// import 'package:fantasy/features/my_contests/presentation/widgets/contests_list_box.dart';
// import 'package:flutter/material.dart';
//
// Widget contestsList({required List<bool> matches}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         decoration: BoxDecoration(
//             color: Color(0xFF1E727E).withOpacity(0.1)
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//                 borderRadius: BorderRadius.circular(2),
//                 child: Image.asset("images/flag2.png", width: 19.83, height: 14, fit: BoxFit.fill,)),
//             SizedBox(width: 10,),
//             Text("UEFA Champions League", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),)
//           ],
//         ),
//       ),
//       SizedBox(height: 10,),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: ListView.builder(
//           padding: EdgeInsets.zero,
//             itemCount: matches.length,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//           return contestsListBox(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context) => MyContestDetailScreen(isCompleted: matches[index], hasWon: index % 2 == 0 ? true : false,)));
//           }, isCompleted: matches[index]);
//         }),
//       ),
//       Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         decoration: BoxDecoration(
//             color: Color(0xFF1E727E).withOpacity(0.1)
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//                 borderRadius: BorderRadius.circular(2),
//                 child: Image.asset("images/flag1.png", width: 19.83, height: 14, fit: BoxFit.fill,)),
//             SizedBox(width: 10,),
//             Text("Premier League", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14),)
//           ],
//         ),
//       ),
//       SizedBox(height: 10,),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: matches.length,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return contestsListBox(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => MyContestDetailScreen(isCompleted: matches[index], hasWon: index % 2 == 0 ? true : false,)));
//               }, isCompleted: matches[index]);
//             }),
//       ),
//     ],
//   );
// }
