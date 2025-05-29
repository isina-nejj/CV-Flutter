import '../entities/room.dart';

abstract class KhabgahRepository {
  Future<List<String>> getBlocks();
  Future<List<String>> getFloors(String blockName);
  Future<Room?> getRoomDetails(
      String blockName, String floorName, int roomNumber);
  Future<List<Room>> getRoomsInFloor(String blockName, String floorName);
}
