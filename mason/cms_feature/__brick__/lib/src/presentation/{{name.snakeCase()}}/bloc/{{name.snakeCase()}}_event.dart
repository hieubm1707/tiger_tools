// BlocSubject + Noun (optional) + Verb (event)
// Example >> class CounterIncrementPressed extends CounterEvent {}
part of '{{name.snakeCase()}}_bloc.dart';

@immutable
abstract class {{name.pascalCase()}}Event {}

class {{name.pascalCase()}}Loaded extends {{name.pascalCase()}}Event {
  {{name.pascalCase()}}Loaded({required this.params});
  final {{name.pascalCase()}}GetParams params;
}

class {{name.pascalCase()}}Deleted extends {{name.pascalCase()}}Event {
  {{name.pascalCase()}}Deleted(this.id);

  final String id;
}

class {{name.pascalCase()}}Updated extends {{name.pascalCase()}}Event {
  {{name.pascalCase()}}Updated({required this.params});

  final {{name.pascalCase()}}UpdateParams params;
}

class {{name.pascalCase()}}Created extends {{name.pascalCase()}}Event {
  {{name.pascalCase()}}Created({required this.params});

  final {{name.pascalCase()}}CreateParams params;
}
