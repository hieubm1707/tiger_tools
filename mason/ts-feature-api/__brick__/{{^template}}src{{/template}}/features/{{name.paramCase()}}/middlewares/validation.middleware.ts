import Joi from '@hapi/joi';
import { celebrate } from 'celebrate';

// Declare here custom validation schemas
const schemas = {
  id: Joi.number().integer().positive(),
  uuid: Joi.string().guid(),
  string: Joi.string().trim(),
  boolean: Joi.boolean(),
  date: Joi.date(),
  number: Joi.number(),
  array: Joi.array(),
  object: Joi.object(),
};

const create{{name.pascalCase()}}Schema = Joi.object({
  // insert fields here
}).required();

const update{{name.pascalCase()}}Schema = Joi.object({
  // insert fields here
}).required();


export { celebrate, Joi, schemas, create{{name.pascalCase()}}Schema, update{{name.pascalCase()}}Schema };
