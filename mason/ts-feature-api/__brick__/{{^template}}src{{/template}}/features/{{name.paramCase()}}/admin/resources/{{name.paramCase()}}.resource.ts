import { ResourceWithOptions } from 'adminjs';
import { Sequelize } from 'sequelize';
import { menu } from '..';

export default (sequelize: Sequelize): ResourceWithOptions => {
  const resource: ResourceWithOptions = {
    resource: sequelize.models.{{name.pascalCase()}}Model,
    options: {
      actions: {
        delete: {
          isAccessible: true,
        },
        bulkDelete: {
          isAccessible: true,
        },
        edit: {
          isAccessible: true,
        },
        list: {
          isAccessible: true,
        },
        new: {
          isAccessible: true,
        },
        search: {
          isAccessible: true,
        },
        show: {
          isAccessible: true,
        },
      },
      navigation: menu.{{name.camelCase()}},
      listProperties: // insert list here
      showProperties: // insert show here
      editProperties: // insert edit here
      filterProperties: // insert filter here
      sort: // insert sort here
    },
  };

  return resource;
};
