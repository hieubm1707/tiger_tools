import { BadRequest, NotFound } from 'http-errors';
import { i18n as I18n } from 'i18next';
import { CreationAttributes } from 'sequelize';
import { Inject, Service } from 'typedi';
import { {{name.camelCase()}}DTO } from '../dto';
import { {{name.pascalCase()}}Model } from '../models';
import { Create{{name.pascalCase()}}DTO, Filter{{name.pascalCase()}}DTO, {{name.pascalCase()}}, Update{{name.pascalCase()}}DTO } from '../types';

@Service()
export default class {{name.pascalCase()}}Service {
  @Inject('i18n')
  i18n!: I18n;

  /**
   * Returns the details of a user or throws a `NotFound` error if not found.
   */
  async get{{name.pascalCase()}}ById(userId: string): Promise<{{name.pascalCase()}}> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findByPk(userId);

    if (!{{name.camelCase()}}) {
      throw new NotFound(this.i18n.t('errors:userNotFound'));
    }

    return {{name.camelCase()}}DTO({{name.camelCase()}});
  }

  /**
   * Creates a new user or throws a `BadRequest` error if a user with the same email address already exists.
   */
  async create{{name.pascalCase()}}(userDetails: Create{{name.pascalCase()}}DTO): Promise<{{name.pascalCase()}}> {
    const existing{{name.pascalCase()}} = await {{name.pascalCase()}}Model.findOne({ where: { title: userDetails.title } });

    if (existing{{name.pascalCase()}}) {
      throw new BadRequest(this.i18n.t('errors:titleAlreadyUsed'));
    }
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.create(userDetails as CreationAttributes<{{name.pascalCase()}}Model>);

    return {{name.camelCase()}}DTO({{name.camelCase()}});
  }

  /**
   * Returns list users by filtering them.
   */

  async get{{name.pascalCase()}}(filter: Filter{{name.pascalCase()}}DTO): Promise<{{name.pascalCase()}}[]> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findAll({ where: filter });

    return {{name.camelCase()}}.map({{name.camelCase()}}DTO);
  }

  /**
   * Creates a new user or throws a `BadRequest` error if a user with the same email address already exists.
   */
  async update{{name.pascalCase()}}({{name.camelCase()}}Id: string, {{name.camelCase()}}Details: Update{{name.pascalCase()}}DTO): Promise<{{name.pascalCase()}}> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findByPk({{name.camelCase()}}Id);

    if (!{{name.camelCase()}}) {
      throw new NotFound(this.i18n.t('errors:{{name.camelCase()}}NotFound'));
    }

    await {{name.camelCase()}}.update({{name.camelCase()}}Details as CreationAttributes<{{name.pascalCase()}}Model>);

    return {{name.camelCase()}}DTO({{name.camelCase()}});
  }

  /**
   * Deletes a user or throws a `NotFound` error if not found.
   */
  async delete{{name.pascalCase()}}({{name.camelCase()}}Id: string): Promise<void> {
    const {{name.camelCase()}} = await {{name.pascalCase()}}Model.findByPk({{name.camelCase()}}Id);

    if (!{{name.camelCase()}}) {
      throw new NotFound(this.i18n.t('errors:{{name.camelCase()}}NotFound'));
    }

    await {{name.camelCase()}}.destroy();
  }
  /// //// Add the following methods here ///////
}
