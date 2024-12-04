import 'package:mason/mason.dart';

void run(HookContext context) {
  final now = DateTime.now();
  final dateTimeNow =
      '${now.year}${now.month}${now.day}${now.hour}${now.minute}${now.second}';
  context.vars = context.vars
    ..addAll({
      'date_now': dateTimeNow,
    });
}
