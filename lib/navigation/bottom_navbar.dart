import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants/app_sizes.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Custom brand blue/teal colors matching the user's provided color (#257C92)
    final highlightStart = const Color(0xFF257C92);
    final highlightEnd = const Color(0xFF1B6477);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: AppSizes.xl,
          right: AppSizes.xl,
          bottom: AppSizes.lg,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final itemWidth = totalWidth / 4;
            
            // Fixed uniform dimensions for the active oval shape
            const indicatorWidth = 72.0;
            const indicatorHeight = 52.0;
            
            // Calculate exact position to center the indicator on the active item
            final indicatorLeft = (currentIndex * itemWidth) + (itemWidth - indicatorWidth) / 2;
            const indicatorTop = (76.0 - indicatorHeight) / 2;

            return ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 76,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.25)
                        : Colors.white.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.12)
                          : Colors.black.withOpacity(0.08),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Uniform shape active liquid / glow background blob
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutBack,
                        left: indicatorLeft,
                        top: indicatorTop,
                        width: indicatorWidth,
                        height: indicatorHeight,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              colors: [highlightStart, highlightEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: highlightStart.withOpacity(0.35),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Navigation row (each wrapped in Expanded to automatically size and prevent overflows)
                      Row(
                        children: [
                          Expanded(child: _buildNavItem(context, Icons.home_rounded, 'Home', 0)),
                          Expanded(child: _buildNavItem(context, Icons.upload_file_rounded, 'Upload', 1)),
                          Expanded(child: _buildNavItem(context, Icons.analytics_rounded, 'Results', 2)),
                          Expanded(child: _buildNavItem(context, Icons.person_rounded, 'Profile', 3)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use white for selected icon/text to contrast beautifully against the teal/blue bubble
    final color = isSelected
        ? Colors.white
        : (isDark ? Colors.white.withOpacity(0.45) : Colors.black.withOpacity(0.45));

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 76,
        alignment: Alignment.center,
        child: AnimatedScale(
          scale: isSelected ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: AppSizes.iconLg - 1,
              ),
              const SizedBox(height: 1),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: AppSizes.textXs - 1,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}