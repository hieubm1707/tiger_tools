// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:ez_intl/l10n/arb/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../data/models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_model.dart';
import '../../widgets/action_type.dart';
import '../../widgets/show_delete_dialog.dart';
import '../bloc/{{name.snakeCase()}}_bloc.dart';
import 'show_edit_{{name.snakeCase()}}_dialog.dart';

class {{name.pascalCase()}}TableAction extends StatelessWidget {
  const {{name.pascalCase()}}TableAction({
    super.key,
    required this.data,
    required this.mainContext,
  });

  final {{name.pascalCase()}}Model data;
  final BuildContext mainContext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionButton(
          ActionType.edit,
          onPress: () => showEdit{{name.pascalCase()}}Dialog(
            context,
            editModel: data,
          ),
        ),
        ActionButton(
          ActionType.delete,
          onPress: () => showDeleteDialog(
            context,
            () => context
                .read<{{name.pascalCase()}}Bloc>()
                .add({{name.pascalCase()}}Deleted(data.id)),
            title: AppLocalizations.of(context).delete{{name.pascalCase()}},
            desc: AppLocalizations.of(context).delete{{name.pascalCase()}}Desc,
          ),
        ),
      ],
    );
  }
}
