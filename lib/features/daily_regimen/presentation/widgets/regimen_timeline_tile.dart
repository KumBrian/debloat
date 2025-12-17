import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class RegimenTimelineTile extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;

  const RegimenTimelineTile({
    super.key,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isCompleted = false,
    this.isActive = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. The Timeline Column
          SizedBox(
            width: 60,
            child: Column(
              children: [
                // The Node Circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.backgroundDark
                        : Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive
                          ? AppColors.primary
                          : Colors.white.withValues(alpha: 0.1),
                      width: isActive ? 2 : 1,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 15,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    icon,
                    color: isActive
                        ? AppColors.primary
                        : Colors.white.withValues(alpha: 0.7),
                    size: 24,
                  ),
                ),
                // The Vertical Line (Gradient)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            isActive
                                ? AppColors.primary
                                : Colors.white.withValues(alpha: 0.1),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // 2. The Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: GlassCard(
                opacity: isActive ? 0.08 : 0.03, // Slightly brighter if active
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.primary.withValues(alpha: 0.2)
                                      : Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: isActive
                                        ? AppColors.primary
                                        : Colors.white.withValues(alpha: 0.5),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isCompleted) ...[
                                const SizedBox(width: 8),
                                Text(
                                  "DONE",
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Checkbox Circle
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.primary
                              : Colors.white.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.backgroundDark,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
