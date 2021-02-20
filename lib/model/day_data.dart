class DayData {
  int dayIndex = 0;
  String dayStr = '';
  bool isSelected = false;
  DayData({this.dayIndex, this.dayStr, this.isSelected});

  int getDayIndex() => dayIndex;
  String getDayStr() => dayStr;
  bool IsSelected() => isSelected;

  void changeSelection() {
    isSelected = !isSelected;
  }
}
