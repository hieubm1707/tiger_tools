// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:ez_intl/l10n/arb/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import '../../../core/params/api_params/{{name.snakeCase()}}_params/{{name.snakeCase()}}_params.dart';
import '../../../core/utils/helper/helper_string.dart';
import '../../../data/models/{{name.snakeCase()}}_response/{{name.snakeCase()}}_model.dart';
import '../../branch_ip/widgets/dialog_cancel_button.dart';
import '../../widgets/dialog_button.dart';
import '../../widgets/dialog_checkbox.dart';
import '../../widgets/dialog_image.dart';
import '../../widgets/dialog_input.dart';
import '../../widgets/expanded_item.dart';
import '../../widgets/page_line.dart';
import '../../widgets/show_edit_dialog.dart';
import '../../widgets/toast.dart';
import '../bloc/{{name.snakeCase()}}_bloc.dart';

// Package imports:

Future<void> showEdit{{name.pascalCase()}}Dialog(
  BuildContext mainContext, {
  {{name.pascalCase()}}Model? editModel,
}) {
  final {{name.camelCase()}}Bloc = mainContext.read<{{name.pascalCase()}}Bloc>();
  return showEditDialog(
    mainContext,
    title: editModel != null
        ? AppLocalizations.of(mainContext).update
        : AppLocalizations.of(mainContext).addNew,
    body: Edit{{name.pascalCase()}}DialogWidget(
      {{name.camelCase()}}Bloc: {{name.camelCase()}}Bloc,
      editModel: editModel,
    ),
  );
}

class Edit{{name.pascalCase()}}DialogWidget extends StatefulWidget {
  const Edit{{name.pascalCase()}}DialogWidget({
    Key? key,
    required this.{{name.camelCase()}}Bloc,
    this.editModel,
  }) : super(key: key);
  final {{name.pascalCase()}}Bloc {{name.camelCase()}}Bloc;
  final {{name.pascalCase()}}Model? editModel;

  @override
  State<Edit{{name.pascalCase()}}DialogWidget> createState() =>
      _Edit{{name.pascalCase()}}DialogWidgetState();
}

class _Edit{{name.pascalCase()}}DialogWidgetState
    extends State<Edit{{name.pascalCase()}}DialogWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController sortController;

  bool active = false;
  DateTime? fromDate;
  DateTime? toDate;
  String? uploadImageUrl;

  @override
  void initState() {
    super.initState();
    _initData();
    _listenerState();
  }

  void _initData() {
    titleController = TextEditingController(text: widget.editModel?.title);
    sortController =
        TextEditingController(text: widget.editModel?.sort.toString());
    active = widget.editModel?.active ?? false;
    uploadImageUrl = widget.editModel?.icon;
  }

  void _listenerState() {
    widget.{{name.camelCase()}}Bloc.stream.listen((state) {
      if (state is {{name.pascalCase()}}UpdateSuccess) {
        if (mounted) {
          Navigator.pop(context);
          setState(() {});
        }
      }
    });
  }

  void _onUploadImageChanged(String? url) {
    uploadImageUrl = url;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const PageLine(),
          ExpandedItem(
            firstItem: _buildTitleInput(context),
            secondItem: _buildSortInput(context),
          ),
          const SizedBox(height: 20),
          _buildImagePicker(context),
          const SizedBox(height: 20),
          DialogCheckbox(
            active,
            label: AppLocalizations.of(context).active,
            onChanged: (val) {
              setState(() {
                active = val ?? false;
              });
            },
          ),
          const SizedBox(height: 20),
          const PageLine(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSubmitButton(context),
              const SizedBox(width: 10),
              const DialogCancelButton(),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTitleInput(BuildContext context) => DialogInput(
        text: AppLocalizations.of(context).promotionName,
        controller: titleController,
        request: true,
        validator: AppValidator.textValid,
      );

  Widget _buildSortInput(BuildContext context) => DialogInput(
        text: AppLocalizations.of(context).order,
        hintText: AppLocalizations.of(context).order,
        controller: sortController,
        validator: AppValidator.numberNonRequestValid,
      );

  Widget _buildImagePicker(BuildContext context) => DialogImage(
        uploadImageUrl,
        request: true,
        text: AppLocalizations.of(context).image,
        uploadImageUrlChanged: _onUploadImageChanged,
      );

  Widget _buildSubmitButton(BuildContext context) => DialogButton(
        text: widget.editModel != null
            ? AppLocalizations.of(context).update
            : AppLocalizations.of(context).add,
        press: () => onSubmitted(context),
      );
  void onSubmitted(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (uploadImageUrl == null) {
        validatorErrorToast(AppLocalizations.of(context).uploadImageReminder);
        return;
      }
      if (widget.editModel == null) {
        widget.{{name.camelCase()}}Bloc.add(
          {{name.pascalCase()}}Created(
            params: {{name.pascalCase()}}CreateParams(
              title: titleController.text,
              sort: int.parse(sortController.text),
              active: active,
              icon: uploadImageUrl ?? '',
            ),
          ),
        );
      } else {
        widget.{{name.camelCase()}}Bloc.add(
          {{name.pascalCase()}}Updated(
            params: {{name.pascalCase()}}UpdateParams(
              id: widget.editModel?.id ?? '',
              title: titleController.text,
              sort: int.parse(sortController.text),
              active: active,
              icon: uploadImageUrl,
            ),
          ),
        );
      }
    }
  }
}
