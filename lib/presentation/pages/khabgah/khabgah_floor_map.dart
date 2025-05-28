import 'package:flutter/material.dart';
import '../../../core/style/colors.dart';
import '../../../core/style/text_styles.dart';
import '../../../core/theme/dark_mode_controller.dart';
import 'khabgah_room_details.dart';

class KhabgahFloorMapPage extends StatelessWidget {
  final String blockName;
  final String floorName;

  const KhabgahFloorMapPage({
    super.key,
    required this.blockName,
    required this.floorName,
  });

  // Colors for light and dark modes
  static Map<String, Color> getLightColors() {
    return <String, Color>{
      'room': const Color(0xFFFFD700), // Golden yellow
      'corridor': const Color(0xFF64B5F6), // Light blue
      'central': const Color(0xFFEF5350), // Light red
      'facilities': const Color(0xFF78909C), // Blue grey
      'stairs': const Color(0xFF66BB6A), // Light green
      'prayer': const Color(0xFF9575CD), // Light purple
    };
  }

  static Map<String, Color> getDarkColors() {
    return <String, Color>{
      'room': const Color(0xFFB8860B), // Darker golden
      'corridor': const Color(0xFF1976D2), // Darker blue
      'central': const Color(0xFFC62828), // Darker red
      'facilities': const Color(0xFF455A64), // Darker blue grey
      'stairs': const Color(0xFF2E7D32), // Darker green
      'prayer': const Color(0xFF5E35B1), // Darker purple
    };
  }

  void _navigateToRoomDetails(BuildContext context, int roomNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KhabgahRoomDetailsPage(
          blockName: blockName,
          floorName: floorName,
          roomNumber: roomNumber,
        ),
      ),
    );
  }

  Widget _build3DContainer({
    required BuildContext context,
    required Widget child,
    required Color color,
    double elevation = 8,
    BorderRadius? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: Offset(elevation / 2, elevation / 2),
            blurRadius: elevation,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: Offset(-elevation / 4, -elevation / 4),
            blurRadius: elevation / 2,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(1),
            color.withOpacity(0.8),
          ],
        ),
      ),
      child: child,
    );
  }

  Widget _buildRoomContainer(
      BuildContext context, int roomNumber, bool isDarkMode,
      {bool isLeft = true}) {
    final colors = isDarkMode
        ? KhabgahFloorMapPage.getDarkColors()
        : KhabgahFloorMapPage.getLightColors();
    final color = colors['room']!;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: () => _navigateToRoomDetails(context, roomNumber),
      child: _build3DContainer(
        context: context,
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'اتاق',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                roomNumber.toString(),
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getFloorIndex() {
    // Try to extract a number from floorName (supports Persian and English digits)
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(floorName);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 1;
    }
    // Fallback: if not found, assume 1
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = DarkModeController();
    final screenSize = MediaQuery.of(context).size;
    final mapWidth = screenSize.width * 0.9;
    final mapHeight = screenSize.height * 0.7;
    final isDarkMode = darkMode.isDarkMode;
    final colors = isDarkMode
        ? KhabgahFloorMapPage.getDarkColors()
        : KhabgahFloorMapPage.getLightColors();

    final floorIndex = _getFloorIndex();
    final roomOffset = (floorIndex - 1) * 18;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$blockName - $floorName',
          style: AppTextStyles.blockTitle(isDarkMode),
        ),
        centerTitle: true,
        backgroundColor: isDarkMode
            ? AppColors.darkAppBarBackground
            : AppColors.appBarBackground,
        actions: [
          DarkModeToggle(controller: darkMode),
        ],
      ),
      body: Container(
        color: isDarkMode ? AppColors.darkBackground : AppColors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'نقشه طبقه',
                style: AppTextStyles.floorTitle(isDarkMode),
              ),
            ),
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  constrained: true,
                  boundaryMargin: const EdgeInsets.all(20),
                  minScale: 0.5,
                  maxScale: 2.0,
                  child: Container(
                    width: mapWidth,
                    height: mapHeight,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Prayer room (نمازخانه)
                        Positioned(
                          top: 0,
                          left: mapWidth * 0.3,
                          right: mapWidth * 0.3,
                          height: mapHeight * 0.1,
                          child: _build3DContainer(
                            context: context,
                            color: colors['prayer']!,
                            child: const Center(
                              child: Text(
                                'نمازخانه',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Main corridor (Blue)
                        Positioned(
                          top: mapHeight * 0.1,
                          bottom: 0,
                          left: mapWidth * 0.25,
                          right: mapWidth * 0.25,
                          child: _build3DContainer(
                            context: context,
                            color: colors['corridor']!,
                            elevation: 4,
                            child: Container(),
                          ),
                        ),

                        // Central empty space (Red)
                        Positioned(
                          top: mapHeight * 0.2,
                          bottom: mapHeight * 0.2,
                          left: mapWidth * 0.3,
                          right: mapWidth * 0.3,
                          child: _build3DContainer(
                            context: context,
                            color: colors['central']!,
                            elevation: 12,
                            child: Container(),
                          ),
                        ),

                        // Left side rooms
                        ...List.generate(9, (index) {
                          final roomNumber = roomOffset + index + 1;
                          return Positioned(
                            top: mapHeight * (0.1 + index * 0.09),
                            left: 0,
                            width: mapWidth * 0.25,
                            height: mapHeight * 0.08,
                            child: _buildRoomContainer(
                                context, roomNumber, isDarkMode,
                                isLeft: true),
                          );
                        }),

                        // Right side rooms
                        ...List.generate(9, (index) {
                          final roomNumber = roomOffset +
                              9 +
                              index +
                              1; // Ensures continuity with left rooms
                          return Positioned(
                            top: mapHeight * (0.1 + index * 0.09),
                            right: 0,
                            width: mapWidth * 0.25,
                            height: mapHeight * 0.08,
                            child: _buildRoomContainer(
                                context, roomNumber, isDarkMode,
                                isLeft: false),
                          );
                        }),

                        // Left kitchen (آشپزخانه)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          width: mapWidth * 0.25,
                          height: mapHeight * 0.1,
                          child: _build3DContainer(
                            context: context,
                            color: colors['facilities']!,
                            child: const Center(
                              child: Text(
                                'آشپزخانه',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Right kitchen (آشپزخانه)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          width: mapWidth * 0.25,
                          height: mapHeight * 0.1,
                          child: _build3DContainer(
                            context: context,
                            color: colors['facilities']!,
                            child: const Center(
                              child: Text(
                                'آشپزخانه',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Left stairway (راهپله)
                        Positioned(
                          bottom: 0,
                          left: mapWidth * 0.25,
                          width: mapWidth * 0.125,
                          height: mapHeight * 0.1,
                          child: _build3DContainer(
                            context: context,
                            color: colors['stairs']!,
                            child: const Center(
                              child: Text(
                                'راهپله',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Right stairway (راهپله)
                        Positioned(
                          bottom: 0,
                          right: mapWidth * 0.25,
                          width: mapWidth * 0.125,
                          height: mapHeight * 0.1,
                          child: _build3DContainer(
                            context: context,
                            color: colors['stairs']!,
                            child: const Center(
                              child: Text(
                                'راهپله',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Bathroom (حمام)
                        Positioned(
                          bottom: 0,
                          left: mapWidth * 0.375,
                          right: mapWidth * 0.375,
                          height: mapHeight * 0.1,
                          child: _build3DContainer(
                            context: context,
                            color: colors['facilities']!,
                            child: const Center(
                              child: Text(
                                'حمام',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
