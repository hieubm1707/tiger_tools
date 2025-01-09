

import { Sequelize } from 'sequelize';
import {
  AllowNull,
  Column,
  Comment,
  CreatedAt,
  DataType,
  Default,
  Model,
  PrimaryKey,
  Table,
  Unique,
  UpdatedAt,
  Index,
} from 'sequelize-typescript';

@Table({
  charset: 'utf8',
  collate: 'utf8_general_ci',
  tableName: '{{table_name}}',
})
export default class {{name.pascalCase()}}Model extends Model<{{name.pascalCase()}}Model> {
  // ─── MODEL ATTRIBUTES ───────────────────────────────────────────────────────────
  
}
