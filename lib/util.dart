import 'package:flutter/material.dart';

const POSTS_API_URL = "https://ign-apis.herokuapp.com/content";
const COMMENTS_API_URL = "https://ign-apis.herokuapp.com/comments";

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
    color: color,
    child: tabBar,
  );
}