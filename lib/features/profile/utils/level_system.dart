class LevelSystem {
  /// Returns the level calculated from total XP.
  /// Level 1: 0 - 99 XP
  /// Level 2: 100 - 299 XP (requires 200 XP)
  /// Level 3: 300 - 599 XP (requires 300 XP)
  /// Level 4: 600 - 999 XP (requires 400 XP)
  /// Formula: Total XP required to reach Level L = (L * (L - 1) / 2) * 100
  static int getLevel(int xp) {
    int level = 1;
    while (xp >= xpForLevel(level + 1)) {
      level++;
    }
    return level;
  }

  /// Total cumulative XP required to reach a specific level.
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    return (level * (level - 1) ~/ 2) * 100;
  }

  /// XP required to level up from current level to next level.
  static int xpNeededForNextLevel(int currentLevel) {
    return currentLevel * 100;
  }

  /// XP progressed inside the current level.
  static int xpProgressInCurrentLevel(int xp) {
    final currentLevel = getLevel(xp);
    final baseXP = xpForLevel(currentLevel);
    return xp - baseXP;
  }

  /// Title based on level
  static String getTitle(int level) {
    if (level < 2) return "Novice Gamer";
    if (level < 5) return "Casual Gamer";
    if (level < 10) return "Pro Gamer";
    if (level < 15) return "Hardcore Gamer";
    return "Legendary Gamer";
  }
}
