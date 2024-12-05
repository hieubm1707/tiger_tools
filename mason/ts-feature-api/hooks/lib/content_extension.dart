import 'package:mason/mason.dart';

extension StringExtension on String {
  String add(String newContent, {bool isAdd = true}) {
    if (isAdd) return this + newContent;
    return this;
  }

  String get defaultPath => 'src/features/${this.paramCase}';
}
