// Project imports:
import '../../../core/base_table/base_data_grid_source.dart';

class {{name.pascalCase()}}DataGridSource<T> extends BaseDataGridSource<T> {
  {{name.pascalCase()}}DataGridSource({
    required super.context,
    required super.configTable,
    required super.data,
    super.currentPage,
    required super.onPageChange,
    required super.objectToJson,
    required super.fromJsonT,
    super.customWidget,
    required super.onSearchPressed,
    required super.addNewWidget,
  });
}
