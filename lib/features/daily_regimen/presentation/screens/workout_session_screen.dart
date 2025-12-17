import 'package:debloat/features/daily_regimen/domain/entities/workout_entity.dart';
import 'package:debloat/features/daily_regimen/presentation/providers/workout_controller.dart';
import 'package:debloat/features/daily_regimen/presentation/providers/workout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'dart:ui'; // For ImageFilter

class WorkoutSessionScreen extends ConsumerWidget {
  const WorkoutSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workoutControllerProvider);
    final controller = ref.read(workoutControllerProvider.notifier);

    // If completed, show celebration (basic check)
    if (state.status == WorkoutStatus.completed) {
      return const Scaffold(body: Center(child: Text("Workout Complete!")));
    }
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // 1. BACKGROUND GLOWS (Ambient Light)
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: .15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: const SizedBox(),
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildHeader(state),
                  const Spacer(), // Pushes timer to visual center
                  _buildTimerSection(state),
                  const Spacer(),
                  if (!state.isResting && state.nextExercise != null)
                    _buildUpNextCard(state.nextExercise!),
                  // If resting, maybe show "Get Ready for X"
                  if (state.isResting) _buildRestingCard(state),

                  const SizedBox(height: 32),

                  // 4. CONTROLS (Hook up buttons)
                  _buildControls(
                    controller,
                    state.status == WorkoutStatus.inProgress,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildHeader(WorkoutState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: AppColors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "CIRCUIT 1/3",
                  style: GoogleFonts.splineSans(
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Active Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: .1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "ACTIVE",
                    style: GoogleFonts.splineSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Progress Bar Info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Progress",
              style: GoogleFonts.splineSans(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
            Text(
              "12:45 Total",
              style: GoogleFonts.splineSans(
                color: AppColors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Custom Linear Progress
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.35, // 35% Progress
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .5),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestingCard(WorkoutState state) {
    final nextExercise = state.nextExercise;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Orange tint to signify "Rest/Warning" phase distinct from the Yellow "Work"
            color: Colors.orangeAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.orangeAccent.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // 1. Animated Icon or Static "Chill" Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.self_improvement,
                  color: Colors.orangeAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // 2. Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BREATHE & RECOVER",
                      style: GoogleFonts.splineSans(
                        color: Colors.orangeAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Coming Up: ",
                          style: GoogleFonts.splineSans(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            nextExercise?.name ?? "Finish",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.splineSans(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerSection(WorkoutState state) {
    final color = state.isResting ? Colors.orangeAccent : AppColors.primary;
    final label = state.isResting ? "REST" : "WORK";
    final timeStr = "0:${state.secondsRemaining.toString().padLeft(2, '0')}";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The Glowing Ring
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glow
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: .1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            // The Progress Indicator
            SizedBox(
              width: 280,
              height: 280,
              child: CircularProgressIndicator(
                value:
                    1.0 -
                    state
                        .progressPercent, // Fills up or down based on preference
                strokeWidth: 20,
                backgroundColor: Colors.white.withValues(alpha: .1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                strokeCap: StrokeCap.round,
              ),
            ),
            // Center Text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: GoogleFonts.splineSans(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    // Fix monospaced numbers to prevent jitter
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 40),
        // Exercise Name
        Text(
          state.isResting ? "REST" : state.currentExercise.name,
          style: GoogleFonts.splineSans(
            color: Colors.white,
            fontSize: state.isResting ? 40 : 48,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Keep your core tight & heels flat",
          style: GoogleFonts.splineSans(
            color: AppColors.grey,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUpNextCard(Exercise nextExercise) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: .1)),
          ),
          child: Row(
            children: [
              // Image Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=2070&auto=format&fit=crop",
                    ), // Pushup image placeholder
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "UP NEXT",
                      style: GoogleFonts.splineSans(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextExercise.name,
                      style: GoogleFonts.splineSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Time Info
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "15s",
                      style: GoogleFonts.splineSans(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "REST",
                      style: GoogleFonts.splineSans(
                        color: AppColors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls(WorkoutController controller, bool isPlaying) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: controller.skipBackward,
          child: _buildCircleButton(
            Icons.skip_previous,
            size: 56,
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: controller.togglePause,
          child: _buildCircleButton(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 88,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: controller.skipForward,
          child: _buildCircleButton(
            Icons.skip_next,
            size: 56,
            isPrimary: false,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton(
    IconData icon, {
    required double size,
    required bool isPrimary,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primary
            : Colors.white.withValues(alpha: .05),
        shape: BoxShape.circle,
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: .4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Icon(
        icon,
        color: isPrimary ? Colors.black : Colors.white.withValues(alpha: .5),
        size: isPrimary ? 40 : 28,
      ),
    );
  }
}
