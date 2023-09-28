// //not using added whole to home.dart for better UI and render speed


// import 'package:SoundDash/cards/fav_card_home.dart';
// import 'package:SoundDash/services/database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ShowFavourites extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//         width: double.infinity,
//         // height: 150,
//         child: StreamBuilder<QuerySnapshot>(
//           stream: DatabaseService().getFavStream(),
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }

//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return Container();
//             }

//             return GridView(
//               scrollDirection: Axis.horizontal,
//               gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 100,
//                 childAspectRatio: 0.35,
//                 crossAxisSpacing: 4,
//                 mainAxisSpacing: 4,
//               ),
//               children: [
//                 for (var doc in snapshot.data!.docs)
//                   if (doc.data() != null)
//                     FavouriteCard(data: doc.data() as Map<String, dynamic>),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildGridTile(Map<String, dynamic> data) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         color: Colors.black.withOpacity(0.2),
//       ),
//       child: Center(
//         child: ListTile(
//           leading: ClipRRect(
//             borderRadius:
//                 BorderRadius.circular(8), // Adjust the radius as needed
//             child: Image.network(
//               data['image'],
//               height: 70,
//               fit: BoxFit.cover,
//             ),
//           ),
//           title: Text(
//             data['title'],
//             style: const TextStyle(fontSize: 15),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           subtitle: Text(
//             data['artist'],
//             style: const TextStyle(fontSize: 12),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ),
//     );
//   }
// }
