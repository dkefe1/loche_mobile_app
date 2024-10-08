// import 'package:fantasy/core/constants.dart';
// import 'package:fantasy/features/my_contests/presentation/widgets/best_managers_carousel.dart';
// import 'package:fantasy/features/my_contests/presentation/widgets/contests_list.dart';
// import 'package:flutter/material.dart';
//
// class MyContestsScreen extends StatefulWidget {
//   const MyContestsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MyContestsScreen> createState() => _MyContestsScreenState();
// }
//
// class _MyContestsScreenState extends State<MyContestsScreen> with TickerProviderStateMixin {
//
//   int _selectedTabbar = 0;
//   late TabController tabController;
//
//   List<bool> matches = [true, true, false, false, true, true, false, false, true, false, true, true, false, false];
//
//   @override
//   void initState() {
//     tabController = TabController(length: 2, vsync: this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: Container(
//           width: double.infinity,
//           margin: EdgeInsets.only(top: 20),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius:
//               BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 30,
//                       ),
//                       Text(
//                         "Best manager of the week",
//                         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                       ),
//                       SizedBox(height: 10,),
//                       BestManagerCarousel(),
//                       SizedBox(height: 20,),
//                       Text(
//                         "My contests",
//                         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//                       ),
//                       Container(
//                         width: double.infinity,
//                         margin: EdgeInsets.symmetric(vertical: 20),
//                         decoration: BoxDecoration(
//                             color: backgroundColor,
//                             borderRadius: BorderRadius.circular(60),
//                             boxShadow: [BoxShadow(color: Color(0xFF000000).withOpacity(0.1), blurRadius: 7)]),
//                         child: TabBar(
//                           onTap: (index) {
//                             setState(() {
//                               _selectedTabbar = index;
//                               tabController.animateTo(index, duration: Duration(seconds: 2));
//                             });
//                           },
//                           labelColor: onPrimaryColor,
//                           unselectedLabelColor: textBlackColor,
//                           labelStyle: TextStyle(fontSize: 13),
//                           indicator: BoxDecoration(
//                               color: Color(0xFF1E727E).withOpacity(0.6),
//                               borderRadius: BorderRadius.circular(60)),
//                           controller: tabController,
//                           tabs: [
//                             Tab(
//                               child: Text("Active"),
//                             ),
//                             Tab(
//                               child: Text("Completed"),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Builder(builder: (_) {
//
//                   List<bool> completed = matches.where((match) => match == true).toList();
//                   List<bool> active = matches.where((match) => match == false).toList();
//
//                   if (_selectedTabbar == 0) {
//                     return contestsList(matches: active);
//                   } else {
//                     return contestsList(matches: completed);
//                   }
//                 })
//               ],
//             ),
//           ),
//         ));
//   }
// }
