// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/base_table/ez_base_table.dart';
import '../../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../../data/models/config_table.dart';
import '../../../data/models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_model.dart';
import '../../../injector/injector.dart';
import '../../widgets/progress_hub.dart';
import '../../widgets/toast.dart';
import '../bloc/{{name.snakeCase()}}_bloc.dart';
import '../widgets/widgets.dart';

@RoutePage()
class {{name.pascalCase()}}Page extends StatelessWidget {
  const {{name.pascalCase()}}Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<{{name.pascalCase()}}Bloc>()
           ..add({{name.pascalCase()}}Loaded(params: {{name.pascalCase()}}GetParams())),
      child: BlocBuilder<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
        builder: (context, state) {
          return ProgressHub(
            running: state is {{name.pascalCase()}}LoadInProgress,
            child:  {{name.pascalCase()}}View(
              configTable: {{name.camelCase()}}ConfigTable,
            ),
          );
        },
      ),
    );
  }
}

class {{name.pascalCase()}}View extends StatefulWidget {
  const {{name.pascalCase()}}View({Key? key, required this.configTable}) : super(key: key);
  final ConfigTable configTable;

  @override
  State<{{name.pascalCase()}}View> createState() => _{{name.pascalCase()}}ViewState();
}

class _{{name.pascalCase()}}ViewState extends State<{{name.pascalCase()}}View> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<{{name.pascalCase()}}Bloc, {{name.pascalCase()}}State>(
      listener: (context, state) {
        if (state is {{name.pascalCase()}}LoadFailure) {
          errorToast(state.error);
        }
        if (state is {{name.pascalCase()}}UpdateFailure) {
          errorToast(state.error);
        }
        if (state is {{name.pascalCase()}}UpdateSuccess) {
          successToast(state.message);
        }
      },
      buildWhen: (previous, current) =>
          previous != current && current is {{name.pascalCase()}}LoadSuccess,
      builder: (context, state) {
        return _buildLayoutBuilder(state);
      },
    );
  }

  Widget _buildLayoutBuilder(final {{name.pascalCase()}}State state) {
      return BaseTable<{{name.pascalCase()}}Model>(
        configTable: widget.configTable,
        totalPage: state.totalPage,
        dataGridSource: _{{name.camelCase()}}DataGridSource(state),
      );
  }

  {{name.pascalCase()}}DataGridSource<{{name.pascalCase()}}Model> _{{name.camelCase()}}DataGridSource(
    final {{name.pascalCase()}}State state,
  ) =>
      {{name.pascalCase()}}DataGridSource<{{name.pascalCase()}}Model>(
        context: context,
        configTable: widget.configTable,
        data: state.data ?? [],
        currentPage: state.page,
        onPageChange: (currentPage) async {
          context.read<{{name.pascalCase()}}Bloc>().add(
                {{name.pascalCase()}}Loaded(
                  params: {{name.pascalCase()}}GetParams(page: currentPage, loadMore: true),
                ),
              );
        },
        objectToJson: (datum) => datum.toJson(),
        fromJsonT: {{name.pascalCase()}}Model.fromJson,
        customWidget: ({{name.camelCase()}}Model) {
          return {{name.pascalCase()}}TableAction(
            data: {{name.camelCase()}}Model,
            mainContext: context,
          );
        },
        onSearchPressed: (map) async {
          context.read<{{name.pascalCase()}}Bloc>().add(
                {{name.pascalCase()}}Loaded(
                  params: {{name.pascalCase()}}GetParams(
                    //TODO: Add Params to search
                  ),
                ),
              );
        },
        addNewWidget: Edit{{name.pascalCase()}}DialogWidget(
          {{name.camelCase()}}Bloc: context.read<{{name.pascalCase()}}Bloc>(),
        ),
      );
}
