// import 'package:flutter/material.dart';
// import 'package:owlby_serene_m_i_n_d_s/home_screen/home_screen_widget.dart';
// import 'package:owlby_serene_m_i_n_d_s/notes_screen/notes_screen_widget.dart';
// import 'package:owlby_serene_m_i_n_d_s/profile_screen/profile_screen_widget.dart';
// import 'package:owlby_serene_m_i_n_d_s/bottom_nav.dart/custom_bottom_navigation_bar.dart';

// class MainPageDart extends StatefulWidget {
//   const MainPageDart({super.key});

//   @override
//   State<MainPageDart> createState() => _MainPageDartState();
// }

// class _MainPageDartState extends State<MainPageDart> {
//   int selectedIndex = 0;

//   List<Widget> _tabs = [
//     HomeScreenWidget(),
//     NotesScreenWidget(),
//     ProfileScreenWidget(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _tabs[selectedIndex],
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: selectedIndex,
//         onTap: (index) => setState(() => selectedIndex = index),
//       ),
//     );
//   }
// }
