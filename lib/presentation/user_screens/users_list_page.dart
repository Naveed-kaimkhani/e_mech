// import 'package:e_mech/presentation/controllers/user_provider.dart';
// import 'package:e_mech/presentation/widgets/user_card.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class UsersListPage extends StatefulWidget {
//   const UsersListPage({super.key});

//   @override
//   State<UsersListPage> createState() => _UsersListPageState();
// }

// class _UsersListPageState extends State<UsersListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: ListView(
//           children: context
//               .watch<UserProvider>()
//               .users
//               .map(
//                 (e) => UserCard(user: e),
//               )
//               .toList(),
//         ),
//       ),
//     );
//   }
// }
