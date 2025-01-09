import { BadRequest, NotFound } from 'http-errors';
import { i18n as I18n } from 'i18next';
import { CreationAttributes, Op } from 'sequelize';
import { Inject, Service } from 'typedi';
import { {{name.camelCase()}}DTO } from '../dto';
import { {{name.pascalCase()}}Model } from '../models';
import { Create{{name.pascalCase()}}DTO, Filter{{name.pascalCase()}}DTO, {{name.pascalCase()}}, Update{{name.pascalCase()}}DTO } from '../types';

@Service()
export default class {{name.pascalCase()}}Service {
  @Inject('i18n')
  i18n!: I18n;

  /**
   * Returns the details of a {{name.camelCase()}} or throws a `NotFound` error if not found.
   */
  async get{{name.pascalCase()}}ById({{name.camelCase()}}Id: string): Promise<{{name.pascalCase()}}> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findByPk({{name.camelCase()}}Id);

    if (!{{name.camelCase()}}) {
      throw new NotFound(this.i18n.t('errors:dataNotFound'));
    }

    return {{name.camelCase()}}DTO({{name.camelCase()}});
  }

  /**
   * Creates a new {{name.camelCase()}} or throws a `BadRequest` error if a {{name.camelCase()}} already exists.
   */
  async create{{name.pascalCase()}}({{name.camelCase()}}Details: Create{{name.pascalCase()}}DTO): Promise<{{name.pascalCase()}}> {
    // check exist model

    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.create({{name.camelCase()}}Details as CreationAttributes<{{name.pascalCase()}}Model>);

    return {{name.camelCase()}}DTO({{name.camelCase()}});
  }

  /**
   * Returns list {{name.camelCase()}}s by filtering them.
   */

  async get{{name.pascalCase()}}(filter: Filter{{name.pascalCase()}}DTO): Promise<{{name.pascalCase()}}[]> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findAll({ where: filter });

    return {{name.camelCase()}}.map({{name.camelCase()}}DTO);
  }

  /**
   * Creates a new {{name.camelCase()}} or throws a `BadRequest` error if a {{name.camelCase()}} already exists.
   */
  async update{{name.pascalCase()}}({{name.camelCase()}}Id: string, {{name.camelCase()}}Details: Update{{name.pascalCase()}}DTO): Promise<{{name.pascalCase()}}> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findByPk({{name.camelCase()}}Id);

    if (!{{name.camelCase()}}) {
      throw new NotFound(this.i18n.t('errors:dataNotFound'));
    }

    // check exist model

    await {{name.camelCase()}}.update({{name.camelCase()}}Details as CreationAttributes<{{name.pascalCase()}}Model>);

    return {{name.camelCase()}}DTO({{name.camelCase()}});
  }

  /**
   * Deletes a {{name.camelCase()}} or throws a `NotFound` error if not found.
   */
  async delete{{name.pascalCase()}}({{name.camelCase()}}Id: string): Promise<void> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findByPk({{name.camelCase()}}Id);

    if (!{{name.camelCase()}}) {
      throw new NotFound(this.i18n.t('errors:dataNotFound'));
    }

    await {{name.camelCase()}}.destroy();
  }
  /// //// Add the following methods here ///////
}
