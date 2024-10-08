class PointSystemModel {
  final String name;
  final String value;
  final double point;
  bool isExpanded;

  PointSystemModel({required this.name, required this.value, required this.point, this.isExpanded = false});
}