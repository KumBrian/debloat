class Exercise {
  final String name;
  final String instruction;
  final String imageUrl;
  final int durationSeconds;

  const Exercise({
    required this.name,
    required this.instruction,
    required this.imageUrl,
    this.durationSeconds = 45, // Default Work time
  });
}

// The fixed routine based on your regimen
final List<Exercise> metabolicCircuit = [
  const Exercise(
    name: "SQUATS",
    instruction: "Keep heels flat, chest up",
    imageUrl: "",
  ),
  const Exercise(
    name: "PUSH-UPS",
    instruction: "Elbows at 45 degrees",
    imageUrl: "",
  ),
  const Exercise(
    name: "REVERSE LUNGES",
    instruction: "Step back far, keep balance",
    imageUrl: "",
  ),
  const Exercise(
    name: "MOUNTAIN CLIMBERS",
    instruction: "Drive knees to chest rapidly",
    imageUrl: "",
  ),
  const Exercise(
    name: "PLANK TAPS",
    instruction: "Tap shoulder without rocking hips",
    imageUrl: "",
  ),
  const Exercise(
    name: "BURPEES",
    instruction: "Chest to floor, jump up",
    imageUrl: "",
  ),
];
