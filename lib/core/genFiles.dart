class GenFiles{
  static int selectedIndex = 0;
  static int innerSelectedIndex = (DateTime.now().weekday == 7)? 0 : DateTime.now().weekday-1;
}