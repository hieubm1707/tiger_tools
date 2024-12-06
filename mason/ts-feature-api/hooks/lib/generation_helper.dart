void handleWriteFile(
  void Function() run,
) async {
  try {
    run();
  } catch (error, stackTrace) {
    print('Error: $error');
    print('Stack: $stackTrace');
  }
}
