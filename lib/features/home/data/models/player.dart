class Player {
  final int id;
  final String name;
  final String position;
  final String club;
  final num point;
  bool isCaptain;
  bool isViceCaptain;
  bool isBench;

  Player(
      {
        required this.id,
        required this.name,
      required this.position,
      required this.club,
      required this.point,
      this.isCaptain = false,
      this.isViceCaptain = false, this.isBench = false});
}
