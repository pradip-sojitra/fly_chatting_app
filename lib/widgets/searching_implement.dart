// import 'package:flutter/material.dart';
//
// class CustomSearchDelegate extends SearchDelegate {
//
//   TextEditingController searchController = TextEditingController();
//
//   List<String> searchTerms = [
//     "Apple",
//     "Banana",
//     "Mango",
//     "Pear",
//     "Watermelons",
//     "Blueberries",
//     "Pineapples",
//     "Strawberries"
//   ];
//
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: const Icon(Icons.clear),
//       ),
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }
//
//   // third overwrite to show query result
//   @override
//   Widget buildResults(BuildContext context) {
//     for (var fruit in searchTerms) {
//       fruit.toLowerCase().contains(searchController.text.toLowerCase());
//     }
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: snapshot.data?.length ?? 0,
//       itemBuilder: (context, index) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return ListTile(
//           contentPadding:
//           const EdgeInsets.only(left: 18, right: 10),
//           onTap: () async {
//             final targetData = await FirebaseFirestore.instance
//                 .collection('users')
//                 .where('phoneNumber',
//                 isEqualTo: snapshot.data![index].phoneNumber)
//                 .get();
//
//             UserModel targetUser =
//             UserModel.fromMap(targetData.docs.first.data());
//             ChatCheckModel? chatCheck =
//             await FirebaseData.getParticipantChat(targetUser);
//
//             if (chatCheck != null) {
//               Navigator.of(context).pop();
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(
//                     targetUser: targetUser,
//                     chatCheck: chatCheck,
//                   ),
//                 ),
//               );
//             }
//           },
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(snapshot.data![index].fullName.toString(),
//                   style: const TextStyle(
//                       fontFamily: 'Rounded ExtraBold')),
//               Text(
//                 snapshot.data![index].about.toString(),
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black54,
//                     fontFamily: 'Rounded ExtraBold'),
//               )
//             ],
//           ),
//           leading: CircleAvatar(
//             radius: 22,
//             backgroundColor: Colors.grey.withOpacity(.40),
//             backgroundImage: snapshot.data![index].profilePicture !=
//                 null
//                 ? NetworkImage(
//                 snapshot.data![index].profilePicture.toString())
//                 : null,
//           ),
//         );
//       },
//     );
//   }
//
//   // last overwrite to show the
//   // querying process at the runtime
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     for (var fruit in searchTerms) {
//       fruit.toLowerCase().contains(searchController.text.toLowerCase());
//     }
//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return ListTile(
//           title: Text(result),
//         );
//       },
//     );
//   }
// }
