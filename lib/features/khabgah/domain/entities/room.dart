class Room {
  final String blockName;
  final String floorName;
  final int roomNumber;
  final List<String> residents;

  const Room({
    required this.blockName,
    required this.floorName,
    required this.roomNumber,
    this.residents = const [],
  });
}
