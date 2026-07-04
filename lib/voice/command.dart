class Command {
  static Future<void> process(String command) async {
    final originalCommand = command.trim();
    command = originalCommand.toLowerCase();

    if (command.contains("send email")) {
      final emailRegex = RegExp(
        r'[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
      );
      final match = emailRegex.firstMatch(command);

      return ;
    }
  }
}
