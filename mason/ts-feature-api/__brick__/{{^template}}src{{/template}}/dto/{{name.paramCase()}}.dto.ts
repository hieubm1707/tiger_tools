import { {{name.pascalCase()}}Model } from '../models';
import { {{name.pascalCase()}} } from '../types';

export const {{name.camelCase()}}DTO = ({{name.camelCase()}}: {{name.pascalCase()}}Model): {{name.pascalCase()}} => {
  const {{name.camelCase()}}Dto: {{name.pascalCase()}} = {
    // insert formatted attributes here
  };

  return {{name.camelCase()}}Dto;
};
