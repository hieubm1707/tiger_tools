import 'package:mason/mason.dart';

void run(HookContext context) {
  final now = DateTime.now();
  final dateTimeNow = now.millisecondsSinceEpoch;
  context.vars = context.vars
    ..addAll({
      'date_now': dateTimeNow,
    });
}
