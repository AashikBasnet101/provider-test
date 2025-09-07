// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:provider_test/core/constants/app_color.dart';
// import 'package:provider_test/core/constants/app_string.dart';
// import 'package:provider_test/features/assignment/assignment.dart';
// import 'package:provider_test/features/provider/dashboard_provider.dart';
// import 'package:provider_test/features/widgets/custom_elevatedbutton.dart';

// class Dashboard extends StatelessWidget {
//   const Dashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dashboard"),
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Row(
//           children: [
//             CustomElevatedButton(
//               backgroundColor: primaryColor,
//               width: MediaQuery.of(context).size.width * 0.42,
//               height: MediaQuery.of(context).size.height * 0.1,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const AssignmentScreen(),
//                   ),
//                 );
//               },
//               child: Text(
//                 getLabel,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//             const SizedBox(width: 40),
//             Consumer<UserRoleProvider>(
//               builder: (context, roleProvider, _) {
//                 if (roleProvider.role == "admin" ||
//                     roleProvider.role == "teacher") {
//                   return CustomElevatedButton(
//                     backgroundColor: primaryColor,
//                     width: MediaQuery.of(context).size.width * 0.42,
//                     height: MediaQuery.of(context).size.height * 0.1,
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const AssignmentScreen(),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       uploadLabel,
//                       style: const TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   );
//                 }
//                 return const SizedBox();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
