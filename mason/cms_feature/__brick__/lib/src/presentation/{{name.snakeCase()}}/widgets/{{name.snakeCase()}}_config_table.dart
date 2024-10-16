import '../../../core/base_table/ez_base_table.dart';
import '../../../data/models/config_table.dart';

final {{name.camelCase()}}ConfigTable = ConfigTable(
  header: '{{name.snakeCase()}}',
  actions: Actions(
    bulkDelete: false,
    list: true,
    //custom action
    delete: true,
    edit: true,
    actionsNew: true,
    search: true,
    show: true,
  ),
  navigation: 'menu.{{name.camelCase()}}',
  listProperties: const [
    'title',
    'active',
    'created_by',
    'created_at',
    'updated_at',
    'action',
  ],
  showProperties: const [
   'title',
    'active',
    'created_by',
    'created_at',
    'updated_at',
    'action',
  ],
  editProperties: const [
    'title',
    'active',
  ],
  searchProperties: [
    {
      'title': SearchProperty(
        label: 'Tiêu đề',
        type: SearchType.text,
      ),
    },
    {
      'active': SearchProperty(
        label: 'Active',
        type: SearchType.checkbox,
      ),
    },
  ],
  sortProperties: const [
    'created_at',
    'updated_at',
  ],
  properties: [
    {
      'title': Property(label: 'Tiêu đề', type: DataGridCellType.longText),
    },
    
    {'active': Property(label: 'Active', type: DataGridCellType.boolean)},
    {
      'created_by':
          Property(label: 'Tạo bởi', type: DataGridCellType.shortText),
    },
    {
      'created_at': Property(
        label: 'Ngày tạo',
        type: DataGridCellType.dateTime,
      ),
    },
    {
      'updated_at':
          Property(label: 'Ngày cập nhật', type: DataGridCellType.dateTime),
    },
    {
      'action': Property(label: 'Hành động', type: DataGridCellType.custom),
    },
  ],
  sort: Sort(direction: 'asc', sortBy: 'lastName'),
);
