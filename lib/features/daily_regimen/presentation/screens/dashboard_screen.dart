// features/daily_regimen/presentation/screens/dashboard_screen.dart
import 'package:debloat/features/daily_regimen/presentation/screens/workout_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../widgets/regimen_timeline_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // 1. Ambient Glow (Background Blob)
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.8,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // HEADER
                  _buildHeader(),
                  const SizedBox(height: 32),

                  // HYDRATION WIDGET
                  _buildHydrationWidget(),
                  const SizedBox(height: 40),

                  // TIMELINE HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Regimen",
                        style: GoogleFonts.splineSans(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // TIMELINE LIST
                  const RegimenTimelineTile(
                    time: "07:00 AM",
                    title: "Lemon Water",
                    subtitle: "Alkalize & hydrate",
                    icon: Icons
                        .local_drink_outlined, // close to emoji_food_beverage
                    isCompleted: true,
                    isActive: false,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Use GoRouter context extension
                      context.push('/workout');
                    },
                    child: const RegimenTimelineTile(
                      time: "07:15 AM",
                      title: "Thermal Shock",
                      subtitle: "2 min cold shower",
                      icon: Icons.ac_unit,
                      isCompleted: false,
                      isActive: true, // Highlights this node
                    ),
                  ),
                  const RegimenTimelineTile(
                    time: "08:00 AM",
                    title: "Protein Breakfast",
                    subtitle: "3 eggs + Avocado",
                    icon: Icons.egg_alt_outlined,
                    isCompleted: false,
                    isActive: false,
                  ),
                  const RegimenTimelineTile(
                    time: "12:00 PM",
                    title: "Low Impact Walk",
                    subtitle: "20 mins sunshine",
                    icon: Icons.directions_walk,
                    isCompleted: false,
                    isActive: false,
                    isLast: true, // Hides the line going down
                  ),
                  const SizedBox(height: 100), // Spacing for floating nav
                ],
              ),
            ),
          ),

          // 3. Floating Bottom Nav
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: GlassCard(
                opacity: 0.1, // Higher opacity for nav
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavButton(Icons.today, true),
                    const SizedBox(width: 8),
                    _buildNavButton(Icons.bar_chart, false),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const WorkoutSessionScreen(),
                            ),
                          );
                        },
                        splashFactory: InkSplash.splashFactory,
                        splashColor: AppColors.primary.withValues(alpha: 0.1),
                        child: _buildNavButton(Icons.person_outline, false),
                      ),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monday, Oct 24",
              style: GoogleFonts.splineSans(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Good Morning,\nAlex",
              style: GoogleFonts.splineSans(
                color: Colors.white,
                fontSize: 28,
                height: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // Streak Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.glassSurface,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                "12 Day Streak",
                style: GoogleFonts.splineSans(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHydrationWidget() {
    return GlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hydration",
                        style: GoogleFonts.splineSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "1250 / 3000 ml",
                        style: GoogleFonts.splineSans(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "GOAL",
                    style: GoogleFonts.splineSans(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "42%",
                    style: GoogleFonts.splineSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.42,
              backgroundColor: Colors.black26,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 20),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Keep it up! 💧",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
              const Spacer(),
              _buildAddButton("+ 250ml"),
              const SizedBox(width: 12),
              _buildAddButton("+ 500ml"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, bool isActive) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isActive ? AppColors.backgroundDark : Colors.white54,
      ),
    );
  }
}
