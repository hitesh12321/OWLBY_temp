import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Bottombutton {
  final IconData selected;
  final IconData unselected;
  final String title;

  Bottombutton({
    required this.selected,
    required this.unselected,
    required this.title,
  });
}

List<Bottombutton> bottombuttons = [
  Bottombutton(
    selected: Icons.home_outlined,
    unselected: Icons.home_outlined,
    title: "Home",
  ),
  Bottombutton(
    selected: Icons.notes_outlined,
    unselected: Icons.notes,
    title: "Notes",
  ),
  Bottombutton(
    selected: Icons.person_outline,
    unselected: Icons.person_outline,
    title: "Profile",
  ),
];
