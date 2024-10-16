// BlocSubject + Verb (action) + State
// Example >> class CounterLoadSuccess extends CounterState {}

part of '{{name.snakeCase()}}_bloc.dart';

@immutable
abstract class {{name.pascalCase()}}State {
  const {{name.pascalCase()}}State({
    this.data,
    this.total = 0,
    this.page = 1,
    this.totalPage = 1,
  });

  final List<{{name.pascalCase()}}Model>? data;
  final int total;
  final int page;
  final int totalPage;

}

class {{name.pascalCase()}}Initial extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}LoadInProgress extends {{name.pascalCase()}}State {}

class {{name.pascalCase()}}LoadFailure extends {{name.pascalCase()}}State {
  {{name.pascalCase()}}LoadFailure(this.error) : super(data: []);
  final ApiError? error;
}

class {{name.pascalCase()}}LoadSuccess extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}LoadSuccess({
    required List<{{name.pascalCase()}}Model> data,
    required int total,
    required int page,
    required int totalPage,
}) : super(
          data: data,
          total: total,
          page: page,
          totalPage: totalPage,
        );
}

class {{name.pascalCase()}}UpdateFailure extends {{name.pascalCase()}}State {
  {{name.pascalCase()}}UpdateFailure(this.error) : super(data: []);
  final ApiError? error;
}

class {{name.pascalCase()}}UpdateSuccess extends {{name.pascalCase()}}State {
  const {{name.pascalCase()}}UpdateSuccess(this.message);
  final String message;
}
